import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dumbkey/logic/encryptor.dart';
import 'package:dumbkey/model/passkey_model.dart';
import 'package:dumbkey/utils/constants.dart';
import 'package:dumbkey/utils/helper_func.dart';
import 'package:flutter/foundation.dart';

class FireStoreNative { // rename this and the file to something else
  FireStoreNative() {
    database = FirebaseFirestore.instance;
    encryptor = AESEncryption();
  }

  late final FirebaseFirestore database;
  late final AESEncryption encryptor;

  Future<void> createPassKey(PassKey passkey) async {
    passkey
      ..crypt(encryptor.encrypt)
      ..docId = idGenerator();
    final doc = database.collection(Constants.mainCollection).doc(passkey.docId.toString());
    await doc.set(passkey.toJSON());
  }

  Future<void> deletePassKey(PassKey passkey) async {
    try {
      await database.collection(Constants.mainCollection).doc(passkey.docId.toString()).delete();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

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

  Stream<List<PassKey>> fetchAllPassKeys() {
    return database.collection(Constants.mainCollection).snapshots().map(
          (snapshots) => snapshots.docs
          .map((doc) => PassKey.fromJson(doc.data())..crypt(encryptor.decrypt))
          .toList(),
    );
  }
}
