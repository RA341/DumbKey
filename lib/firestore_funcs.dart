import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dumbkey/key_model.dart';

class FireStore {
  FireStore() {
    database = FirebaseFirestore.instance;
  }

  late final FirebaseFirestore database;

  Future<void> addPassKey(PassKey passkey) async {
    await database.collection(passkey.org).add(passkey.toJSON());
  }

  Future<void> updatePassKey(PassKey passkey) async {
    await database.collection(passkey.org)
        .doc(passkey.passKey)
        .update(passkey.toJSON());
  }

  Future<void> deletePassKey(PassKey passkey) async {
    await database.collection(passkey.org)
        .doc(passkey.passKey)
        .delete();
  }
}
