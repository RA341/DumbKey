// ignore_for_file: cascade_invocations

import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dumbkey/model/card_details_model/card_details_model.dart';
import 'package:dumbkey/model/notes_model/notes_model.dart';
import 'package:dumbkey/model/password_model/password_model.dart';
import 'package:dumbkey/model/type_base_model.dart';
import 'package:dumbkey/services/database/local/isar_mixin.dart';
import 'package:dumbkey/services/database/remote/dart_firestore.dart';
import 'package:dumbkey/services/encryption_handler.dart';
import 'package:dumbkey/utils/logger.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:isar/isar.dart';

class DatabaseHandler with IsarDbMixin {
  DatabaseHandler() {
    firestore = DartFireStore();
    encryptor = GetIt.I.get<IDataEncryptor>();
    fireListener = _listenToChangesFromFireBase();
    _listenToConnectionState();
  }

  late final IDataEncryptor encryptor;
  late final DartFireStore firestore;
  late final StreamSubscription<List<TypeBase>> fireListener;

  // conncection stuff
  final connection = Connectivity();
  ValueNotifier<ConnectivityResult> connectionState = ValueNotifier(ConnectivityResult.none);

  bool get isOnline => connectionState.value != ConnectivityResult.none;

  // crud functions
  Future<void> createData(TypeBase data) async {
    logger.w('Creating Data', data.toJson());

    final encryptedLocal = cryptMap(data.toJson(), encryptor.encryptMap);
    final enc = data.copyWith(encryptedLocal);

    if (isOnline == false) {
      enc.syncStatus = SyncStatus.notSynced;
      await isarCreateOrUpdate(enc);
      logger.w('data created offline', data.id);
      return;
    }

    try {
      await firestore.createData(cryptValue(encryptedLocal, encryptor.encrypt));
    } catch (e) {
      logger
        ..e('Error adding Data to firebase', e)
        ..d('data to be locally stored', data.id);
      enc.syncStatus = SyncStatus.notSynced;
    }
    await isarCreateOrUpdate(enc);
  }

  Future<void> updateData(Map<String, dynamic> updateData, TypeBase updatedModel) async {
    // here we use map instead of passkey
    // because we only want data that is changed to be updated
    assert(
      !updateData.containsValue(null),
      'update data contains null,$updateData',
    );

    final encryptedLocal = cryptMap(updatedModel.toJson(), encryptor.encryptMap);
    final encModel = updatedModel.copyWith(encryptedLocal);

    if (isOnline == false) {
      encModel.syncStatus = SyncStatus.notSynced;
      await isarCreateOrUpdate(encModel);
      logger.w('data updated offline', updatedModel.id);
      return;
    }

    try {
      // update only changed data
      for (final key in updateData.keys) {
        updateData[key] = encryptedLocal[key];
      }
      final remote = cryptValue(updateData, encryptor.encrypt);
      await firestore.updateData(remote);
      logger.i('Updated Data', remote);
    } catch (e) {
      logger.e('Error updating Data to firebase', e);
      encModel.syncStatus = SyncStatus.notSynced;
    }

    logger.w('Update Data', encModel.toJson());
    await isarCreateOrUpdate(encModel);
  }

  Future<void> deleteData(TypeBase data) async {
    logger.w('Deleting Data', data.toJson());

    if (isOnline == false) {
      data.syncStatus = SyncStatus.deleted; // temp status until device gets online and deletes
      await isarCreateOrUpdate(data);
      return;
    }

    try {
      await firestore.deleteData(data.id);
      logger.i('Deleted Data', data.id);
    } catch (e) {
      logger.e('Error deleting Data from firebase', e);
      data.syncStatus = SyncStatus.deleted; // temp status until device gets online and deletes
      await isarCreateOrUpdate(data);
      return;
    }

    await isarDelete(data.id, data.dataType);
  }

  // sync functions
  StreamSubscription<List<TypeBase>> _listenToChangesFromFireBase() {
    return firestore.fetchAllData().listen(
      (documents) async {
        logger.i('firebase listening', documents.length);
        // deletes local data that is not present in remote
        /// known bug here on initial listen as firebase needs to accumulate data
        /// it will delete and rewrite all local data
        /// after that it will work fine
        unawaited(
          deleteLocalNotInRemote(documents).then((value) async {
            unawaited(
              isarCreateOrUpdateAll(documents).whenComplete(() => null),
            );
          }),
        ); // updates local data from remote
      },
      onError: (Object error, StackTrace stackTrace) async {
        if (!isOnline) {
          // pause stream only if device is offline
          await fireListener.cancel();
          logger.e('firebase paused', error, stackTrace);
          return;
        }
        logger.e('error reading firebase stream', error, stackTrace);
      },
      onDone: () {
        logger.v('firebase done');
      },
    );
  }

  Future<void> _checkForId(List<int> ids, List<int> remoteIds, DataType type) async {
    for (final id in ids) {
      if (remoteIds.contains(id) == false) {
        await isarDelete(id, type);
      }
    }
  }

  Future<void> deleteLocalNotInRemote(List<TypeBase> remoteData) async {
    final remoteId = remoteData.map((e) => e.id).toList();

    final allPassKeys =
        await isarDb.passwords.filter().syncStatusEqualTo(SyncStatus.synced).idProperty().findAll();
    await _checkForId(allPassKeys, remoteId, DataType.password);

    final allCards = await isarDb.cardDetails
        .filter()
        .syncStatusEqualTo(SyncStatus.synced)
        .idProperty()
        .findAll();
    await _checkForId(allCards, remoteId, DataType.card);

    final allNotes =
        await isarDb.notes.filter().syncStatusEqualTo(SyncStatus.synced).idProperty().findAll();
    await _checkForId(allNotes, remoteId, DataType.notes);
  }

  // sync de-synchronized data functions

  FutureOr<void> _listenToConnectionState() async {
    connection.onConnectivityChanged.distinct().listen((status) async {
      connectionState.value = status;
      if (isOnline) {
        fireListener.resume();
        logger.wtf(fireListener.isPaused);
        _listenToDeSyncPasskeys();
        _listenToDeSyncNotes();
        _listenToDeSyncCardDetails();
        logger.d('Online starting firestore', status);
      } else {
        fireListener.pause();
        logger.d('Offline canceling firestore', status);
      }
    });
  }

  void _listenToDeSyncPasskeys() {
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
      logger.e('Error fetching desync passkeys', error, stackTrace);
    });
  }

  void _listenToDeSyncCardDetails() {
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
      logger.e('Error fetching desync card dets', error, stackTrace);
    });
  }

  void _listenToDeSyncNotes() {
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
      logger.e('Error fetching desync notes', error, stackTrace);
    });
  }

  void _syncOfflineItems(List<TypeBase> deSyncData) {
    if (deSyncData.isEmpty) return;
    logger.i('No of items to be synced', deSyncData);
    for (final passKey in deSyncData) {
      if (isOnline) {
        if (passKey.syncStatus == SyncStatus.deleted) {
          _deleteDataAsync(passKey);
        } else {
          _createDataAsync(passKey);
        }
      }
    }
  }

  void _createDataAsync(TypeBase data) {
    logger.i('adding to remote', data.id);

    data.syncStatus = SyncStatus.synced;
    final remote = cryptValue(data.toJson(), encryptor.encrypt);

    firestore.createData(remote).then((value) {
      unawaited(
        isarCreateOrUpdate(data).whenComplete(() => logger.i('data added', data.id)),
      );
    }).onError((error, stackTrace) {
      logger
        ..e('Error adding offline Data to firebase', [error, stackTrace])
        ..d('data not updated', data.id);
    });
  }

  void _deleteDataAsync(TypeBase data) {
    logger.i('deleting from remote', data.id);
    firestore.deleteData(data.id).then((value) {
      unawaited(
        isarDelete(data.id, data.dataType).whenComplete(() => logger.i('data removed', data.id)),
      );
    }).onError((error, stackTrace) {
      logger
        ..e('Error deleting from remote', [error, stackTrace])
        ..d('data not deleted', data.id);
    });
  }
}
