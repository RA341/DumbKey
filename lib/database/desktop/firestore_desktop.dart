import 'package:dumbkey/logic/encryptor.dart';
import 'package:dumbkey/model/passkey_model.dart';
import 'package:dumbkey/utils/constants.dart';
import 'package:dumbkey/utils/helper_func.dart';
import 'package:firedart/firedart.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class DesktopFirestore {
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

  Future<void> createPassKey(PassKey passkey) async {
    final docId = idGenerator();
    passkey
      ..docId = docId
      ..crypt(encryptor.encrypt);

    await database
        .collection(Constants.mainCollection)
        .document(docId.toString()).set(passkey.toJSON());
  }

  Future<void> deletePassKey(PassKey passkey) async {
    await database
        .collection(Constants.mainCollection)
        .document(passkey.docId.toString())
        .delete();
  }

  Future<void> updatePassKey(String docId, Map<String, dynamic> updateData) async{
    for (final key in updateData.keys) {
      updateData[key] = encryptor.encrypt(updateData[key] as String);
    }
    await database.collection(Constants.mainCollection).document(docId).update(updateData);
  }

  Stream<List<PassKey>> fetchAllPassKeys() {
    return database.collection('main').stream.map(
          (docs) => docs.map((doc) => PassKey.fromJson(doc.map)..crypt(encryptor.decrypt)).toList(),
        );
  }
}
