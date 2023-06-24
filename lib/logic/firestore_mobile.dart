import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dumbkey/logic/abstract_firestore.dart';
import 'package:dumbkey/logic/encryptor.dart';
import 'package:dumbkey/utils/constants.dart';
import 'package:dumbkey/utils/firebase_options.dart';
import 'package:dumbkey/utils/passkey_model.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';

class MobileFireStore implements FireStoreBase {
  MobileFireStore._create() {
    database = FirebaseFirestore.instance;
    encryptor = AESEncryption();
  }

  /// used this way because async constructors are not allowed
  /// we initialize firebase here as it
  /// removes dependency from main helps in tree shaking
  static Future<MobileFireStore> init() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    return MobileFireStore._create();
  }

  late final FirebaseFirestore database;
  late final AESEncryption encryptor;

  @override
  Future<void> createPassKey(PassKey passkey) async {
    passkey.crypt(encryptor.encrypt);
    final doc = database.collection(Constants.mainCollection).doc();
    passkey.docId = doc.id;
    await doc.set(passkey.toJSON());
  }

  @override
  Future<void> deletePassKey(PassKey passkey) async {
    try {
      await database.collection(Constants.mainCollection).doc(passkey.docId).delete();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Future<void> updatePassKey(String docId,Map<String,dynamic> updateData) async {
    try {
      for (final key in updateData.keys) {
        updateData[key] = encryptor.encrypt(updateData[key] as String);
      }

      await database
          .collection(Constants.mainCollection)
          .doc(docId)
          .update(updateData);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Stream<List<PassKey>> fetchAllPassKeys() {
    return database.collection(Constants.mainCollection).snapshots().map(
          (snapshots) =>
          snapshots.docs
              .map((doc) =>
          PassKey.fromJson(doc.data())
            ..crypt(encryptor.decrypt),)
              .toList(),
    );
  }
}
