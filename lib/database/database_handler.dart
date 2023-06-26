import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dumbkey/database/dart_firestore.dart';
import 'package:dumbkey/database/isar_mixin.dart';
import 'package:dumbkey/model/passkey_model.dart';
import 'package:dumbkey/utils/constants.dart';
import 'package:dumbkey/utils/helper_func.dart';
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
      GetIt.I.get<Logger>().e('No internet connection canceling listener', e);
    }

    _listenToDeSyncPasskey();
  }

  final connection = Connectivity();
  late final DartFireStore firestore;
  StreamSubscription<List<PassKey>>? fireListener;
  ValueNotifier<ConnectivityResult> connectionState = ValueNotifier(ConnectivityResult.none);

  Future<void> createPassKey(PassKey passkey) async {
    GetIt.I.get<Logger>().d('Creating Data', passkey.toJSON());

    // if passkey is coming form create screen then it will have a docId = 0
    if (passkey.docId == 0) {
      passkey.docId = idGenerator();
    }

    try {
      await firestore.createPassKey(passkey.toJSON());
    } catch (e) {
      GetIt.I.get<Logger>().e('Error adding Data to firebase', e);
      GetIt.I.get<Logger>().d('data to be locally stored', passkey.toJSON());
      passkey.syncStatus = false;
    }
    await isarCreateOrUpdate(passkey);
  }

  Future<void> deletePassKey(int docId) async {
    if (connectionState.value == ConnectivityResult.none ||
        connectionState.value == ConnectivityResult.other) {
      GetIt.I.get<Logger>().d('No connection', connectionState.value);
      return;
    }
    GetIt.I.get<Logger>().d('Deleting Data', docId);

    try {
      await firestore.deletePassKey(docId);
      await isarDelete(docId); // let the fire store complete first
    } catch (e) {
      GetIt.I.get<Logger>().e('Error deleting Data from firebase', e);
      return; // TODO(deletepaskey): rethrow this to the next catch block
    }
  }

  Future<void> updatePassKey(Map<String, dynamic> updateData) async {
    assert(
      !updateData.containsValue(null),
      'update data contains null,$updateData',
    );

    // used here because updateData gets mutated by updatePassKey
    final data = Map<String, dynamic>.from(updateData);

    try {
      await firestore.updatePassKey(updateData);
    } catch (e) {
      GetIt.I.get<Logger>().e('Error updating Data to firebase', e);
      data[Constants.syncStatus] = false;
    }
    // isar needs the docId inside pass key to update
    assert(
      data.containsKey(Constants.docId) || data.containsKey(Constants.syncStatus),
      'update data does not contain ID,$data',
    );
    GetIt.I.get<Logger>().d('Update Data', [data]);
    await isarCreateOrUpdate(PassKey.fromJson(data));
  }

  Stream<List<PassKey>> fetchAllPassKeys() {
    return isarDb.passKeys.where().build().watch(fireImmediately: true);
  }

  StreamSubscription<List<PassKey>> _listenToChangesFromFireBase() {
    return firestore.fetchAllPassKeys().listen(
        (documents) async {
          GetIt.I.get<Logger>().d('firebase is listening to changes');
          final allPassKeys = await isarDb.passKeys.filter().syncStatusEqualTo(true).findAll();
          GetIt.I.get<Logger>().d('All passkeys with sync true', allPassKeys.length);
          for (final passKey in allPassKeys) {
            // remove the passkey locally if not present in firebase
            // used here because other devices can delete the passkey
            if (documents.contains(passKey) == false) {
              if (passKey.syncStatus == false) {
                // handle non sync data only available locally
                await createPassKey(passKey);
                continue;
              }
              await isarDelete(passKey.docId);
            }
          }
          await isarCreateOrUpdateAll(documents);
        },
        cancelOnError: true,
        onError: (Object error, StackTrace stackTrace) {
          fireListener = null;
          GetIt.I.get<Logger>().e('Error listening to changes from firebase firelistenr is ${fireListener.runtimeType}', error, stackTrace);
        });
  }

  void _listenToDeSyncPasskey() {
    connection.onConnectivityChanged.listen((status) async {
      connectionState.value = status;
      final deSyncBooks = isarDb.passKeys
          .filter()
          .syncStatusEqualTo(false)
          .build()
          .watch(fireImmediately: true)
          .listen((event) async {
        await _syncOfflineItems(event);
      });

      GetIt.I.get<Logger>().d('firelistener status', fireListener.runtimeType);

      if (status != ConnectivityResult.none) {
        fireListener ??= _listenToChangesFromFireBase();
        GetIt.I.get<Logger>().d('connection online starting firestore', status);
      } else {
        GetIt.I.get<Logger>().d('connection offline canceling firestore', status);
        await fireListener?.cancel();
        fireListener ??= null;
        await deSyncBooks.cancel();
      }
    });
  }

  Future<void> _syncOfflineItems(List<PassKey> deSyncBooks) async {
    if (deSyncBooks.isEmpty) return;
    GetIt.I.get<Logger>().d('deSyncBooks books not empty', deSyncBooks);
    for (final passKey in deSyncBooks) {
      unawaited(
        connection.checkConnectivity().then((status) {
          GetIt.I.get<Logger>().d('connection state for offline sync', status);
          if (status == ConnectivityResult.wifi || status == ConnectivityResult.mobile) {
            passKey.syncStatus = true;
            _createPasskeyAsync(passKey);
          }
        }),
      );
    }
  }

  void _createPasskeyAsync(PassKey passkey) {
    GetIt.I.get<Logger>().d('Adding data from offline listeners', passkey.toJSON());

    firestore.createPassKey(passkey.toJSON()).then((value) async {
      await isarCreateOrUpdate(passkey);
    }).onError((error, stackTrace) {
      GetIt.I.get<Logger>().e('Error adding Data to firebase', [error, stackTrace]);
      GetIt.I.get<Logger>().d('data to be locally stored', passkey.toJSON());
      passkey.syncStatus = false;
    });
  }
}
