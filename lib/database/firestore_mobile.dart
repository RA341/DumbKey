import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dumbkey/database/firestore_stub.dart';
import 'package:dumbkey/logic/encryptor.dart';
import 'package:dumbkey/model/passkey_model.dart';
import 'package:dumbkey/utils/constants.dart';
import 'package:dumbkey/utils/firebase_options.dart';
import 'package:dumbkey/utils/helper_func.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:isar/isar.dart';

/// used this way because async constructors are not allowed
/// we initialize firebase here as it
/// removes dependency from main helps in tree shaking
Future<MobileFireStore> initMobileFirestore(Isar isar) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  return MobileFireStore(isar);
}

class MobileFireStore extends FireStoreBase {
  MobileFireStore(super.isar) {
    database = FirebaseFirestore.instance;
    encryptor = AESEncryption();
  }

  late final FirebaseFirestore database;
  late final AESEncryption encryptor;

  @override
  Future<void> createPassKey(PassKey passkey) async {
    passkey..crypt(encryptor.encrypt)
    ..docId = idGenerator();
    final doc = database.collection(Constants.mainCollection).doc(passkey.docId.toString());
    await doc.set(passkey.toJSON());
  }

  @override
  Future<void> deletePassKey(PassKey passkey) async {
    try {
      await database.collection(Constants.mainCollection).doc(passkey.docId.toString()).delete();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Future<void> updatePassKey(String docId, Map<String, dynamic> updateData) async {
    try {
      for (final key in updateData.keys) {
        updateData[key] = encryptor.encrypt(updateData[key] as String);
      }

      await database.collection(Constants.mainCollection).doc(docId).update(updateData);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Stream<List<PassKey>> fetchAllPassKeys() {
    return database.collection(Constants.mainCollection).snapshots().map(
          (snapshots) => snapshots.docs
              .map(
                (doc) => PassKey.fromJson(doc.data())..crypt(encryptor.decrypt),
              )
              .toList(),
        );
  }
}
