import 'dart:async';
import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dumbkey/model/card_details_model/card_details_model.dart';
import 'package:dumbkey/model/notes_model/notes_model.dart';
import 'package:dumbkey/model/password_model/password_model.dart';
import 'package:dumbkey/model/type_base_model.dart';
import 'package:dumbkey/services/database/local/isar_mixin.dart';
import 'package:dumbkey/services/database/remote/dart_firestore.dart';
import 'package:dumbkey/services/encryption_handler.dart';
import 'package:dumbkey/utils/constants.dart';
import 'package:dumbkey/utils/logger.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:isar/isar.dart';

Map<String, dynamic> cryptMap(
  Map<String, dynamic> data,
  Map<String, dynamic> Function(Map<String, dynamic>, {List<String> blackListedKeys}) cryptor,
) {
  return cryptor(
    data,
    blackListedKeys: [...DumbData.blackListedKeys, ...DumbData.blackListedKeysLocal],
  );
}

Map<String, dynamic> cryptValue(
  Map<String, dynamic> data,
  String Function(String, Uint8List) cryptor,
) {
  assert(
    data.containsKey(DumbData.nonce),
    'nonce is missing,$data',
  );
  final remote = Map<String, dynamic>.from(data);

  final nonce = base64Decode(remote[DumbData.nonce] as String);
  // encrypt data that was not encrypted locally and reuse rest of the data
  for (final key in DumbData.blackListedKeysLocal) {
    remote[key] = cryptor(remote[key] as String, nonce);
  }
  return remote;
}

class DatabaseHandler with IsarDbMixin {
  DatabaseHandler() {
    firestore = DartFireStore();
    encryptor = GetIt.I.get<IDataEncryptor>();
    try {
      fireListener ??= _listenToChangesFromFireBase();
    } catch (e) {
      fireListener?.pause();
      logger.e('No connection canceling listener', e);
    }
    _listenToConnectionState();
  }

  late final Stream<List<Notes>> notesStream;
  late final Stream<List<Password>> passwordStream;
  late final Stream<List<CardDetails>> cardDetailsStream;

  late final IDataEncryptor encryptor;
  late final DartFireStore firestore;
  final connection = Connectivity();
  StreamSubscription<List<TypeBase>>? fireListener;
  ValueNotifier<ConnectivityResult> connectionState = ValueNotifier(ConnectivityResult.none);

  bool get isOnline => connectionState.value != ConnectivityResult.none;

  Future<void> createData(TypeBase data) async {
    logger.w('Creating Data', data.toJson());

    final encryptedLocal = cryptMap(data.toJson(), encryptor.encryptMap);

    if (isOnline == false) {
      data
        ..copyWith(encryptedLocal)
        ..syncStatus = SyncStatus.notSynced;
      await isarCreateOrUpdate(data);
      logger.w('data created offline', data.id);
      return;
    }

    try {
      await firestore.createData(cryptValue(encryptedLocal, encryptor.encrypt));
    } catch (e) {
      logger
        ..e('Error adding Data to firebase', e)
        ..d('data to be locally stored', data.id);
      data.syncStatus = SyncStatus.notSynced;
    }
    await isarCreateOrUpdate(data.copyWith(encryptedLocal));
  }

  Future<void> updateData(Map<String, dynamic> updateData, TypeBase updatedModel) async {
    // here we use map instead of passkey
    // because we only want data that is changed to be updated
    assert(
      !updateData.containsValue(null),
      'update data contains null,$updateData',
    );

    final encryptedLocal = cryptMap(updatedModel.toJson(), encryptor.encryptMap);

    if (isOnline == false) {
      updatedModel
        ..copyWith(encryptedLocal)
        ..syncStatus = SyncStatus.notSynced;
      await isarCreateOrUpdate(updatedModel);
      logger.w('data updated offline', updatedModel.id);
      return;
    }

    try {
      final remote = cryptValue(updateData, encryptor.encrypt);
      await firestore.updateData(remote);
      logger.i('Updated Data', remote);
    } catch (e) {
      logger.e('Error updating Data to firebase', e);
      updatedModel.syncStatus = SyncStatus.notSynced;
    }

    final encModel = updatedModel.copyWith(encryptedLocal);
    logger.w('Update Data', encModel);
    await isarCreateOrUpdate(encModel);
  }

  Future<void> deleteData(TypeBase data) async {
    logger.w('Deleting Data', data.toJson());

    if (data.syncStatus == SyncStatus.notSynced) {
      await isarDelete(data.id, data.dataType);
      logger.i('Deleting local only data', data.id);
      return;
    }

    if (isOnline == false) {
      data.syncStatus = SyncStatus.deleted; // temp status until device gets online and deletes
      await isarCreateOrUpdate(data);
      return;
    }

    try {
      await firestore.deleteData(data.id);
      await isarDelete(data.id, data.dataType); // let the fire store complete first
      logger.i('Deleted Data', data.id);
    } catch (e) {
      logger.e('Error deleting Data from firebase', e);
      data.syncStatus = SyncStatus.deleted; // temp status until device gets online and deletes
      await isarCreateOrUpdate(data);
      return;
    }
  }

  T decryptLocalStream<T>(TypeBase e) {
    final decrypted = cryptMap(e.toJson(), encryptor.decryptMap);
    return e.copyWith(decrypted) as T;
  }

  Stream<List<Password>> fetchAllPassKeys() => isarDb.passwords
      .where()
      .filter()
      .not()
      .syncStatusEqualTo(SyncStatus.deleted)
      .build()
      .watch(fireImmediately: true)
      .distinct()
      .map((event) => event.map((e) => decryptLocalStream<Password>(e)).toList());

  Stream<List<Notes>> fetchAllNotes() => isarDb.notes
      .where()
      .filter()
      .not()
      .syncStatusEqualTo(SyncStatus.deleted)
      .build()
      .watch(fireImmediately: true)
      .distinct()
      .map((event) => event.map((e) => decryptLocalStream<Notes>(e)).toList());

  Stream<List<CardDetails>> fetchAllCardDetails() => isarDb.cardDetails
      .where()
      .filter()
      .not()
      .syncStatusEqualTo(SyncStatus.deleted)
      .build()
      .watch(fireImmediately: true)
      .distinct()
      .map((event) => event.map((e) => decryptLocalStream<CardDetails>(e)).toList());

  FutureOr<void> _listenToConnectionState() async {
    connection.onConnectivityChanged.distinct().listen((status) async {
      connectionState.value = status;
      if (status != ConnectivityResult.none) {
        fireListener?.resume();
        _listenToDeSyncPasskeys();
        _listenToDeSyncNotes();
        _listenToDeSyncCardDetails();
        logger.d('Online starting firestore', status);
      } else {
        fireListener?.pause();
        logger.d('Offline canceling firestore', status);
      }
    });
  }

  StreamSubscription<List<TypeBase>> _listenToChangesFromFireBase() {
    return firestore.fetchAllPassKeys().distinct().listen(
      (documents) async {
        logger.d('firebase listening', documents.length);
        // deletes local data that is not present in remote
        unawaited(
          deleteLocalNotInRemote(documents).then((value) async {
            unawaited(
              isarCreateOrUpdateAll(
                documents,
              ).whenComplete(() => null),
            ); // possible optimization update only changed data
          }),
        );
        // updates local data from remote
      },
      onError: (Object error, StackTrace stackTrace) async {
        fireListener?.pause();
        logger.e('firebase paused', error, stackTrace);
      },
    );
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
      logger.e('Error fetching desync items', error, stackTrace);
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
      logger.e('Error fetching desync items', error, stackTrace);
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
              _deleteDataAsync(passKey);
            } else {
              _createDataAsync(passKey);
            }
          }
        }),
      );
    }
  }

  void _createDataAsync(TypeBase data) {
    logger.i('adding to remote', data.id);

    data.syncStatus = SyncStatus.synced;
    firestore.createData(data.toJson()).then((value) {
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
