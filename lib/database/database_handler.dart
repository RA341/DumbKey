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
    _listenToDeSyncPasskey();
  }

  final connection = Connectivity();
  final logger = GetIt.I.get<Logger>();
  late final DartFireStore firestore;
  StreamSubscription<List<PassKey>>? fireListener;
  ValueNotifier<ConnectivityResult> connectionState = ValueNotifier(ConnectivityResult.none);

  Future<void> createPassKey(PassKey passkey) async {
    logger.d('Creating Data', passkey.toJSON());

    try {
      await firestore.createPassKey(passkey.toJSON());
    } catch (e) {
      logger
        ..e('Error adding Data to firebase', e)
        ..d('data to be locally stored', passkey.toJSON());
      passkey.syncStatus = false;
    }
    await isarCreateOrUpdate(passkey);
  }

  Future<void> updatePassKey(Map<String, dynamic> updateData) async {
    assert(
      !updateData.containsValue(null),
      'update data contains null,$updateData',
    );

    // used here because updateData gets somehow mutated(no idea why) by updatePassKey
    final data = Map<String, dynamic>.from(updateData);

    try {
      await firestore.updatePassKey(updateData);
    } catch (e) {
      logger.e('Error updating Data to firebase', e);
      data[Constants.syncStatus] = false;
    }

    assert(
      data.containsKey(Constants.docId) || data.containsKey(Constants.syncStatus),
      'update data does not contain ID,$data',
    );
    logger.d('Update Data', [data]);
    await isarCreateOrUpdate(PassKey.fromJson(data));
  }

  Future<void> deletePassKey(int docId) async {
    // TODO(deletepaskey): maybe rework this
    if (connectionState.value == ConnectivityResult.none ||
        connectionState.value == ConnectivityResult.other) {
      logger.d('No connection', connectionState.value);
      return;
    }
    logger.d('Deleting Data', docId);

    try {
      await firestore.deletePassKey(docId);
      await isarDelete(docId); // let the fire store complete first
    } catch (e) {
      logger.e('Error deleting Data from firebase', e);
      return;
    }
  }

  Stream<List<PassKey>> fetchAllPassKeys() =>
      isarDb.passKeys.where().build().watch(fireImmediately: true);

  StreamSubscription<List<PassKey>> _listenToChangesFromFireBase() {
    return firestore.fetchAllPassKeys().listen(
          (documents) async {
            logger.d('firebase listening');
            final allPassKeys = await isarDb.passKeys.filter().syncStatusEqualTo(true).findAll();
            logger.d('passkeys-to-sync', allPassKeys.length);
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
          onError: (Object error, StackTrace stackTrace) {
            fireListener = null;
            logger.e('firebase offline', error, stackTrace);
          },
        );
  }

  void _listenToDeSyncPasskey() {
    // ignore: cancel_subscriptions
    final unSyncPasskeys = isarDb.passKeys
        .filter()
        .syncStatusEqualTo(false)
        .build()
        .watch(fireImmediately: true)
        .listen(
          (event) async {
            await _syncOfflineItems(event);
          },
          cancelOnError: true,
          onError: (Object err, StackTrace st) {
            logger.e('Desync listener error', err, st);
          },
        );

    connection.onConnectivityChanged.listen((status) async {
      connectionState.value = status;
      if (unSyncPasskeys.isPaused) unSyncPasskeys.resume();
      logger.d('firelistener type', fireListener.runtimeType);
      if (status != ConnectivityResult.none) {
        fireListener ??= _listenToChangesFromFireBase();
        logger.d('Online starting firestore', status);
      } else {
        logger.d('Offline canceling firestore', status);
        unSyncPasskeys.pause();
      }
    });
  }

  Future<void> _syncOfflineItems(List<PassKey> deSyncKeys) async {
    if (deSyncKeys.isEmpty) return;
    logger.d('No of passkeys to be synced', deSyncKeys);
    for (final passKey in deSyncKeys) {
      unawaited(
        connection.checkConnectivity().then((status) {
          logger.d('current connection for syncing', status);
          if (status != ConnectivityResult.none) {
            passKey.syncStatus = true;
            _createPasskeyAsync(passKey);
          }
        }),
      );
    }
  }

  void _createPasskeyAsync(PassKey passkey) {
    logger.d('Adding data from offline listeners', passkey.toJSON());
    firestore.createPassKey(passkey.toJSON()).then((value) async {
      await isarCreateOrUpdate(passkey);
    }).onError((error, stackTrace) {
      logger
        ..e('Error adding Data to firebase', [error, stackTrace])
        ..d('data to be locally stored', passkey.toJSON());
      passkey.syncStatus = false;
    });
  }
}
