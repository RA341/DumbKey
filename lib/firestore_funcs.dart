import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dumbkey/encryptor.dart';
import 'package:dumbkey/key_model.dart';
import 'package:dumbkey/utils/constants.dart';
import 'package:flutter/cupertino.dart';

class FireStore {
  FireStore() {
    database = FirebaseFirestore.instance;
    encryptor = AESEncryption();
  }

  late final FirebaseFirestore database;
  late final AESEncryption encryptor;

  Future<void> createPassKey(PassKey passkey) async {
    passkey.crypt(encryptor.encrypt);
    final doc = database.collection(Constants.mainCollection).doc();
    passkey.docId = doc.id;
    await doc.set(passkey.toJSON());
  }

  Future<void> deletePassKey(PassKey passkey) async {
    try {
      await database.collection(Constants.mainCollection).doc(passkey.docId).delete();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> updatePassKey(PassKey passkey) async {
    try {
      passkey.crypt(encryptor.encrypt);
      await database
          .collection(Constants.mainCollection)
          .doc(passkey.docId)
          .update(passkey.toJSON());
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  // Future<void> displayKeys() async {
  //   final data = await database.collection(Constants.mainCollection).;
  //
  //   print(data.data());
  // }

  Stream<List<PassKey>> fetchAllPassKeys() {
    return database.collection(Constants.mainCollection).snapshots().map(
          (snapshots) =>
          snapshots.docs
              .map((doc) =>
          PassKey.fromJson(doc.data())
            ..crypt(encryptor.decrypt))
              .toList(),
    );
  }
}
