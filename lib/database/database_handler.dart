import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dumbkey/database/dart_firestore.dart';
import 'package:dumbkey/database/isar_mixin.dart';
import 'package:dumbkey/model/passkey_model.dart';
import 'package:dumbkey/utils/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:isar/isar.dart';
import 'package:logger/logger.dart';

class DatabaseHandler with IsarDbMixin {
  DatabaseHandler() {
    firestore = DartFireStore();
    try {
      fireListener ??= _listenToChangesFromFireBase();
    } on SocketException catch (e) {
      fireListener?.cancel();
      logger.e('No internet connection canceling listener', e);
    }
    syncing.addListener(() {
      logger.w('Syncing status:', syncing.value);
    });
    _listenToConnectionState();
  }

  final connection = Connectivity();
  final logger = GetIt.I.get<Logger>();
  late final DartFireStore firestore;
  StreamSubscription<List<PassKey>>? fireListener;
  ValueNotifier<ConnectivityResult> connectionState = ValueNotifier(ConnectivityResult.none);
  ValueNotifier<bool> syncing = ValueNotifier(false);

  Future<void> createPassKey(PassKey passkey) async {
    logger.w('Creating Data', passkey.toJSON());

    try {
      await firestore.createPassKey(passkey.toJSON());
    } catch (e) {
      logger
        ..e('Error adding Data to firebase', e)
        ..d('data to be locally stored', passkey.toJSON());
      passkey.syncStatus = SyncStatus.notSynced;
    }
    await isarCreateOrUpdate(passkey);
  }

  Future<void> updatePassKey(Map<String, dynamic> updateData) async {
    // here we use map instead of passkey
    // because we only want  data that is changed to be updated
    assert(
      !updateData.containsValue(null),
      'update data contains null,$updateData',
    );

    // used here because updateData gets somehow mutated(no idea why) by updatePassKey
    final data = Map<String, dynamic>.from(updateData);

    try {
      await firestore.updatePassKey(updateData);
      logger.i('Updated Data', updateData);
    } catch (e) {
      logger.e('Error updating Data to firebase', e);
      data[Constants.syncStatus] = SyncStatus.notSynced.index;
    }

    assert(
      data.containsKey(Constants.docId) || data.containsKey(Constants.syncStatus),
      'update data does not contain ID,$data',
    );
    logger.w('Update Data', data);
    await isarCreateOrUpdate(PassKey.fromJson(data));
  }

  Future<void> deletePassKey(PassKey passkey) async {
    logger.w('Deleting Data', passkey.toJSON());

    if (passkey.syncStatus == SyncStatus.notSynced) {
      await isarDelete(passkey.docId);
      logger.i('Deleting local only data', passkey.toJSON());
      return;
    }

    try {
      await firestore.deletePassKey(passkey.docId);
      await isarDelete(passkey.docId); // let the fire store complete first
      logger.i('Deleted Data', passkey.toJSON());
    } catch (e) {
      logger.e('Error deleting Data from firebase', e);
      passkey.syncStatus = SyncStatus.deleted; // temp status until device gets online and deletes
      await isarCreateOrUpdate(passkey);
      return;
    }
  }

  Stream<List<PassKey>> fetchAllPassKeys() => isarDb.passKeys
      .where()
      .filter()
      .not()
      .syncStatusEqualTo(SyncStatus.deleted)
      .build()
      .watch(fireImmediately: true);

  StreamSubscription<List<PassKey>> _listenToChangesFromFireBase() {
    return firestore.fetchAllPassKeys().listen(
          (documents) async {
            logger.d('firebase listening');
            final allPassKeys =
                await isarDb.passKeys.filter().syncStatusEqualTo(SyncStatus.synced).findAll();
            logger.d('synced passkeys', allPassKeys.length);
            for (final passKey in allPassKeys) {
              // remove the passkey locally if not present in firebase
              // used here because other devices can delete the passkey
              if (documents.contains(passKey) == false) {
                await isarDelete(passKey.docId);
              }
            }
            await isarCreateOrUpdateAll(documents);
          },
          cancelOnError: true,
          onError: (Object error, StackTrace stackTrace) async {
            await fireListener?.cancel();
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
        logger.d('Online starting firestore', status);
      } else {
        logger.d('Offline canceling firestore', status);
        // if (unSyncPasskeysListener.isPaused != true) unSyncPasskeysListener.pause();
      }
    });
  }

  void listenToDeSyncPasskeys() {
    isarDb.passKeys
        .filter()
        .syncStatusEqualTo(SyncStatus.notSynced)
        .or()
        .syncStatusEqualTo(SyncStatus.deleted)
        .build()
        .findAll()
        .then((value) {
      logger.i('Items to sync', value.length);
      if (value.isNotEmpty) {
        _syncOfflineItems(value);
      }
    }).onError((error, stackTrace) {
      logger.e('Error fetching desync items', error, stackTrace);
    });
  }

  void _syncOfflineItems(List<PassKey> deSyncKeys) {
    if (deSyncKeys.isEmpty) return;
    logger.i('No of passkeys to be synced', deSyncKeys);
    for (final passKey in deSyncKeys) {
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

  void _createPasskeyAsync(PassKey passkey) {
    logger.i('adding to remote', passkey.toJSON());

    passkey.syncStatus = SyncStatus.synced;
    firestore.createPassKey(passkey.toJSON()).then((value) async {
      await isarCreateOrUpdate(passkey);
      logger.i('data added', passkey.toJSON());
    }).onError((error, stackTrace) {
      logger
        ..e('Error adding Data to firebase', [error, stackTrace])
        ..d('data not updated', passkey.toJSON());
    });
  }

  void _deletePasskeyAsync(PassKey passKey) {
    logger.i('deleting from remote', passKey.toJSON());

    firestore.deletePassKey(passKey.docId).then((value) async {
      await isarDelete(passKey.docId);
      logger.i('data removed', passKey.toJSON());
    }).onError((error, stackTrace) {
      logger
        ..e('Error deleting from remote', [error, stackTrace])
        ..d('data not deleted', passKey.toJSON());
    });
  }
}
