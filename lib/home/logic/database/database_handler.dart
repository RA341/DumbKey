// ignore_for_file: cascade_invocations

import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dumbkey/home/logic/database/local/isar_mixin.dart';
import 'package:dumbkey/home/logic/database/remote/dart_firestore.dart';
import 'package:dumbkey/model/card_details_model/card_details_model.dart';
import 'package:dumbkey/model/notes_model/notes_model.dart';
import 'package:dumbkey/model/password_model/password_model.dart';
import 'package:dumbkey/model/type_base_model.dart';
import 'package:dumbkey/services/encryption_handler.dart';
import 'package:dumbkey/utils/helper_func.dart';
import 'package:dumbkey/utils/logger.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';

class DatabaseHandler with IsarDbMixin {
  DatabaseHandler() {
    firestore = DartFireStore();
    encryptor = dep.get<IDataEncryptor>();
    fireListener = _listenToChangesFromFireBase();
    connectivityListener = _listenToConnectionState();
    initCacheManager();
  }

  late final IDataEncryptor encryptor;
  late final DartFireStore firestore;
  late final StreamSubscription<Map<int, TypeBase>> fireListener;
  late final StreamSubscription<ConnectivityResult> connectivityListener;

  late final StreamSubscription<List<Password>> passwordStream;
  late final StreamSubscription<List<Notes>> notesStream;
  late final StreamSubscription<List<CardDetails>> cardDetailStream;

  // connection stuff
  ConnectivityResult connectionState = ConnectivityResult.none;

  bool get isOnline => connectionState != ConnectivityResult.none;

  // caching stuff
  final passwordCache = ValueNotifier<List<Password>>([]);
  final notesCache = ValueNotifier<List<Notes>>([]);
  final cardDetailsCache = ValueNotifier<List<CardDetails>>([]);

  Future<void> dispose() async {
    await fireListener.cancel();
    await connectivityListener.cancel();

    // disposing local db listeners
    await passwordStream.cancel();
    await notesStream.cancel();
    await cardDetailStream.cancel();
    // fix this in future
    // currently when logging out
    // if cache value notifier is disposed it will throw error
    // therefore we empty the cache so it doesn't take memory until GC takes care of it
    passwordCache.value = List.empty();
    notesCache.value = List.empty();
    cardDetailsCache.value = List.empty();
  }

  void initCacheManager() {
    passwordStream = fetchAllPassKeys().listen((event) {
      passwordCache.value = event;
    });

    notesStream = fetchAllNotes().listen((event) {
      notesCache.value = event;
    });

    cardDetailStream = fetchAllCardDetails().listen((event) {
      cardDetailsCache.value = event;
    });
  }

// crud functions
  Future<void> createData(TypeBase data) async {
    logger.w('Creating Data ${data.id}');

    final encryptedLocal = cryptMap(data.toJson(), encryptor.encryptMap);
    final enc = data.copyWithFromMap(encryptedLocal);

    if (isOnline == false) {
      enc.copyWith(syncStatus: SyncStatus.notSynced);
      await isarCreateOrUpdate(enc);
      logger.w('data created offline ${data.id}');
      return;
    }

    try {
      await firestore.createData(cryptValue(encryptedLocal, encryptor.encrypt));
    } catch (e) {
      logger
        ..e('Error adding Data to firebase', e)
        ..d('data to be locally stored ${data.id}');
      enc.copyWith(syncStatus: SyncStatus.notSynced);
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
    final encModel = updatedModel.copyWithFromMap(encryptedLocal);

    if (isOnline == false) {
      encModel.copyWith(syncStatus: SyncStatus.notSynced);
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
      encModel.copyWith(syncStatus: SyncStatus.notSynced);
    }

    await isarCreateOrUpdate(encModel);
  }

  Future<void> deleteData(TypeBase data) async {
    logger.w('Deleting Data ${data.id}');

    if (isOnline == false) {
      data.copyWith(
        syncStatus: SyncStatus.deleted,
      ); // temp status until device gets online and deletes
      await isarCreateOrUpdate(data);
      return;
    }

    try {
      await firestore.deleteData(data.id);
      logger.i('Deleted Data ${data.id}');
    } catch (e) {
      logger.e('Error deleting Data from firebase', e);
      data.copyWith(
          syncStatus: SyncStatus.deleted); // temp status until device gets online and deletes
      await isarCreateOrUpdate(data);
      return;
    }

    await isarDelete(data.id, data.dataType);
  }

// sync functions
  StreamSubscription<Map<Id, TypeBase>> _listenToChangesFromFireBase() {
    return firestore.fetchAllData().listen(
      (documents) async {
        logger.wtf('documents:${documents.length}');

        /// known bug here on initial listen as firebase needs to accumulate data
        /// it will delete and rewrite all local data
        /// after that it will work fine
        // deletes local data that is not present in remote
        unawaited(
          deleteLocalNotInRemote(documents).then((value) async {
            // updates local data from remote
            unawaited(
              isarCreateOrUpdateAll(documents.values.toList()).whenComplete(() => null),
            );
          }),
        );
      },
      onError: (Object error, StackTrace stackTrace) async {
        if (!isOnline) {
          // pause stream only if device is offline
          await fireListener.cancel();
          logger.e('firebase paused', error, stackTrace);
          return;
        }
      },
      onDone: () {
        logger.d('firebase done');
      },
    );
  }

  Future<void> _checkForId(Map<int, TypeBase> localData, Map<int, TypeBase> remoteIds) async {
    for (final id in localData.keys.toList()) {
      if (remoteIds.containsKey(id) == false) {
        await isarDelete(id, localData[id]!.dataType);
      }
    }
  }

  Future<Map<int, TypeBase>> deleteLocalNotInRemote(Map<int, TypeBase> remoteData) async {
    final localDataMap = <int, TypeBase>{};

    // add all passwords
    final allPassKeys =
        await isarDb.passwords.filter().syncStatusEqualTo(SyncStatus.synced).findAll();
    allPassKeys.fold(localDataMap, (curMap, element) => curMap..addAll({element.id: element}));

    // add all cards
    final allCards =
        await isarDb.cardDetails.filter().syncStatusEqualTo(SyncStatus.synced).findAll();
    allCards.fold(localDataMap, (curMap, element) => curMap..addAll({element.id: element}));

    // add all notes
    final allNotes = await isarDb.notes.filter().syncStatusEqualTo(SyncStatus.synced).findAll();
    allNotes.fold(localDataMap, (curMap, element) => curMap..addAll({element.id: element}));

    // remove files not in remote
    await _checkForId(localDataMap, remoteData);

    return localDataMap;
  }

// sync de-synchronized data functions

  StreamSubscription<ConnectivityResult> _listenToConnectionState() {
    return Connectivity().onConnectivityChanged.distinct().listen(
          (status) async {
            logger.wtf('starting connection listener');
            connectionState = status;
            if (isOnline) {
              fireListener.resume();
              _listenToDeSyncPasskeys();
              _listenToDeSyncNotes();
              _listenToDeSyncCardDetails();
              logger.d('Online listening', status);
            } else {
              fireListener.pause();
              logger.d('Offline pausing', status);
            }
          },
          cancelOnError: true,
          // ignore: inference_failure_on_untyped_parameter
          onError: (error, StackTrace stackTrace) {
            logger.e('Error listening to connection', error, stackTrace);
          },
        );
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
    logger.i('adding to remote ${data.id}');

    data.copyWith(syncStatus: SyncStatus.synced);
    final remote = cryptValue(data.toJson(), encryptor.encrypt);

    firestore.createData(remote).then((value) {
      unawaited(
        isarCreateOrUpdate(data).whenComplete(() => logger.i('data added ${data.id}')),
      );
    }).onError((error, stackTrace) {
      logger
        ..e('Error adding offline Data to firebase', [error, stackTrace])
        ..d('data not updated ${data.id}');
    });
  }

  void _deleteDataAsync(TypeBase data) {
    logger.i('deleting from remote ${data.id}');
    firestore.deleteData(data.id).then((value) {
      unawaited(
        isarDelete(data.id, data.dataType).whenComplete(() => logger.i('data removed ${data.id}')),
      );
    }).onError((error, stackTrace) {
      logger
        ..e('Error deleting from remote', [error, stackTrace])
        ..d('data not deleted ${data.id}');
    });
  }
}
