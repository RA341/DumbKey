import 'package:dumbkey/logic/encryptor.dart';
import 'package:dumbkey/model/passkey_model.dart';
import 'package:dumbkey/utils/constants.dart';
import 'package:firedart/firedart.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class DartFireStore {
  DartFireStore() {
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

  Future<void> createPassKey(Map<String,dynamic> data) async {
    final encrypted = encryptor.encryptMap(data);

    await database
        .collection(Constants.mainCollection)
        .document((encrypted[Constants.docId] as int).toString()).set(encrypted);
  }

  Future<void> deletePassKey(int docId) async {
    await database
        .collection(Constants.mainCollection)
        .document(docId.toString())
        .delete();
  }

  Future<void> updatePassKey(Map<String, dynamic> updateData) async{
    final encrypted = encryptor.encryptMap(updateData);
    await database.collection(Constants.mainCollection).document((encrypted[Constants.docId] as int).toString()).update(encrypted);
  }

  Stream<List<PassKey>> fetchAllPassKeys() {
    return database.collection('main').stream.map(
          (docs) => docs.map((doc) => PassKey.fromJson(doc.map)..crypt(encryptor.decrypt)).toList(),
        );
  }
}
