import 'dart:math';

import 'package:dumbkey/logic/firestore_stub.dart';
import 'package:dumbkey/logic/encryptor.dart';
import 'package:dumbkey/utils/constants.dart';
import 'package:dumbkey/utils/passkey_model.dart';
import 'package:firedart/firedart.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class DesktopFirestore implements FireStoreBase {
  DesktopFirestore() {
    initFireDart();
    encryptor = AESEncryption();
  }

  void initFireDart() {
    final projId = dotenv.get(
      Constants.firebaseProjID,
      fallback: Constants.noKey,
    );

    if (projId == Constants.noKey) {
      throw Exception('Firebase project ID not found in .env file');
    }
    Firestore.initialize(projId);
    database = Firestore.instance;
  }

  late final Firestore database;
  late final AESEncryption encryptor;

  @override
  Future<void> createPassKey(PassKey passkey) async {
    const chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    final docId = String.fromCharCodes(
      Iterable.generate(
        20,
        (_) => chars.codeUnitAt(Random().nextInt(chars.length)),
      ),
    );
    passkey
      ..docId = docId
      ..crypt(encryptor.encrypt);

    await database.collection(Constants.mainCollection).document(docId).set(passkey.toJSON());
  }

  @override
  Future<void> deletePassKey(PassKey passkey) async {
    return database.collection(Constants.mainCollection).document(passkey.docId).delete();
  }

  @override
  Future<void> updatePassKey(String docId, Map<String, dynamic> updateData) async {
    for (final key in updateData.keys) {
      updateData[key] = encryptor.encrypt(updateData[key] as String);
    }
    await database.collection(Constants.mainCollection).document(docId).update(updateData);
  }

  @override
  Stream<List<PassKey>> fetchAllPassKeys() {
    return database.collection('main').stream.map(
          (docs) => docs.map((doc) => PassKey.fromJson(doc.map)..crypt(encryptor.decrypt)).toList(),
        );
  }
}
