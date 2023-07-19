import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dumbkey/model/card_details_model/card_details_model.dart';
import 'package:dumbkey/model/notes_model/notes_model.dart';
import 'package:dumbkey/model/password_model/password_model.dart';
import 'package:dumbkey/model/type_base_model.dart';
import 'package:dumbkey/services/database/local/isar_mixin.dart';
import 'package:dumbkey/services/database/remote/dart_firestore.dart';
import 'package:dumbkey/utils/logger.dart';
import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';

class DatabaseHandler with IsarDbMixin {
  DatabaseHandler() {
    firestore = DartFireStore();
    try {
      fireListener ??= _listenToChangesFromFireBase();
    } on SocketException catch (e) {
      fireListener?.cancel();
      logger.e('No connection canceling listener', e);
    }
    // syncing.addListener(() {
    //   logger.w('Syncing status:', syncing.value);
    // });
    _listenToConnectionState();
  }

  late final DartFireStore firestore;
  final connection = Connectivity();

  StreamSubscription<List<TypeBase>>? fireListener;

  ValueNotifier<ConnectivityResult> connectionState = ValueNotifier(ConnectivityResult.none);
  ValueNotifier<bool> syncing = ValueNotifier(false);

  Future<void> createData(TypeBase data) async {
    logger.w('Creating Data', data.toJson());

    try {
      await firestore.createData(data.toJson());
    } catch (e) {
      logger
        ..e('Error adding Data to firebase', e)
        ..d('data to be locally stored', data.toJson());
      data.syncStatus = SyncStatus.notSynced;
    }
    await isarCreateOrUpdate(data);
  }

  Future<void> updateData(Map<String, dynamic> updateData, TypeBase updatedModel) async {
    // here we use map instead of passkey
    // because we only want data that is changed to be updated
    assert(
      !updateData.containsValue(null),
      'update data contains null,$updateData',
    );

    try {
      await firestore.updateData(updateData);
      logger.i('Updated Data', updateData);
    } catch (e) {
      logger.e('Error updating Data to firebase', e);
      updatedModel.syncStatus = SyncStatus.notSynced;
    }

    logger.w('Update Data', updateData);
    await isarCreateOrUpdate(updatedModel);
  }

  Future<void> deleteData(TypeBase data) async {
    logger.w('Deleting Data', data.toJson());

    if (data.syncStatus == SyncStatus.notSynced) {
      await isarDelete(data.id, data.dataType);
      logger.i('Deleting local only data', data.toJson());
      return;
    }

    try {
      await firestore.deleteData(data.id);
      await isarDelete(data.id, data.dataType); // let the fire store complete first
      logger.i('Deleted Data', data.toJson());
    } catch (e) {
      logger.e('Error deleting Data from firebase', e);
      data.syncStatus = SyncStatus.deleted; // temp status until device gets online and deletes
      await isarCreateOrUpdate(data);
      return;
    }
  }

  Stream<List<Password>> fetchAllPassKeys() => isarDb.passwords
      .where()
      .filter()
      .not()
      .syncStatusEqualTo(SyncStatus.deleted)
      .build()
      .watch(fireImmediately: true);

  Stream<List<Notes>> fetchAllNotes() => isarDb.notes
      .where()
      .filter()
      .not()
      .syncStatusEqualTo(SyncStatus.deleted)
      .build()
      .watch(fireImmediately: true);

  Stream<List<CardDetails>> fetchAllCardDetails() => isarDb.cardDetails
      .where()
      .filter()
      .not()
      .syncStatusEqualTo(SyncStatus.deleted)
      .build()
      .watch(fireImmediately: true);

  StreamSubscription<List<TypeBase>> _listenToChangesFromFireBase() {
    return firestore.fetchAllPassKeys().distinct().listen(
          (documents) async {
            logger.d('firebase listening', documents.length);
            // deletes local data that is not present in remote
            await deleteLocalNotInRemote(documents);
            // updates local data from remote
            await isarCreateOrUpdateAll(
                documents); // possible optimization update only changed data
          },
          cancelOnError: true,
          onError: (Object error, StackTrace stackTrace) async {
            await fireListener?.cancel();
            firestore.dispose();
            fireListener = null;
            logger.e('firebase offline', error, stackTrace);
          },
        );
  }

  FutureOr<void> _listenToConnectionState() async {
    connection.onConnectivityChanged.distinct().listen((status) async {
      connectionState.value = status;
      // if (unSyncPasskeysListener.isPaused) unSyncPasskeysListener.resume();
      logger.d('firelistener type', fireListener.runtimeType);
      if (status != ConnectivityResult.none) {
        fireListener ??= _listenToChangesFromFireBase();
        listenToDeSyncPasskeys();
        listenToDeSyncNotes();
        listenToDeSyncCardDetails();
        logger.d('Online starting firestore', status);
      } else {
        logger.d('Offline canceling firestore', status);
      }
    });
  }

  Future<void> deleteLocalNotInRemote(List<TypeBase> remoteData) async {
    final allPassKeys =
        await isarDb.passwords.filter().syncStatusEqualTo(SyncStatus.synced).findAll();
    final allCards =
        await isarDb.cardDetails.filter().syncStatusEqualTo(SyncStatus.synced).findAll();
    final allNotes = await isarDb.notes.filter().syncStatusEqualTo(SyncStatus.synced).findAll();

    for (final passkey in [...allPassKeys, ...allCards, ...allNotes]) {
      if (!remoteData.contains(passkey)) {
        await isarDelete(passkey.id, passkey.dataType);
      }
    }
  }

  void listenToDeSyncPasskeys() {
    isarDb.passwords
        .filter()
        .syncStatusEqualTo(SyncStatus.notSynced)
        .or()
        .syncStatusEqualTo(SyncStatus.deleted)
        .build()
        .findAll()
        .then((dataList) {
      logger.i('Passwords to sync', dataList.length);
      if (dataList.isNotEmpty) {
        _syncOfflineItems(dataList);
      }
    }).onError((error, stackTrace) {
      logger.e('Error fetching desync items', error, stackTrace);
    });
  }

  void listenToDeSyncCardDetails() {
    isarDb.cardDetails
        .filter()
        .syncStatusEqualTo(SyncStatus.notSynced)
        .or()
        .syncStatusEqualTo(SyncStatus.deleted)
        .build()
        .findAll()
        .then((dataList) {
      logger.i('Cards to sync', dataList.length);
      if (dataList.isNotEmpty) {
        _syncOfflineItems(dataList);
      }
    }).onError((error, stackTrace) {
      logger.e('Error fetching desync items', error, stackTrace);
    });
  }

  void listenToDeSyncNotes() {
    isarDb.notes
        .filter()
        .syncStatusEqualTo(SyncStatus.notSynced)
        .or()
        .syncStatusEqualTo(SyncStatus.deleted)
        .build()
        .findAll()
        .then((dataList) {
      logger.i('Notes to sync', dataList.length);
      if (dataList.isNotEmpty) {
        _syncOfflineItems(dataList);
      }
    }).onError((error, stackTrace) {
      logger.e('Error fetching desync items', error, stackTrace);
    });
  }

  void _syncOfflineItems(List<TypeBase> deSyncData) {
    if (deSyncData.isEmpty) return;
    logger.i('No of items to be synced', deSyncData);
    for (final passKey in deSyncData) {
      unawaited(
        connection.checkConnectivity().then((status) {
          logger.i('current connection for syncing', status);
          if (status != ConnectivityResult.none) {
            if (passKey.syncStatus == SyncStatus.deleted) {
              _deletePasskeyAsync(passKey);
            } else {
              _createPasskeyAsync(passKey);
            }
          }
        }),
      );
    }
  }

  void _createPasskeyAsync(TypeBase passkey) {
    logger.i('adding to remote', passkey.toJson());

    passkey.syncStatus = SyncStatus.synced;
    firestore.createData(passkey.toJson()).then((value) async {
      await isarCreateOrUpdate(passkey);
      logger.i('data added', passkey.toJson());
    }).onError((error, stackTrace) {
      logger
        ..e('Error adding offline Data to firebase', [error, stackTrace])
        ..d('data not updated', passkey.toJson());
    });
  }

  void _deletePasskeyAsync(TypeBase passKey) {
    logger.i('deleting from remote', passKey.toJson());

    firestore.deleteData(passKey.id).then((value) async {
      await isarDelete(passKey.id, passKey.dataType);
      logger.i('data removed', passKey.toJson());
    }).onError((error, stackTrace) {
      logger
        ..e('Error deleting from remote', [error, stackTrace])
        ..d('data not deleted', passKey.toJson());
    });
  }
}
