import 'dart:async';

import 'package:dumbkey/logic/encryptor.dart';
import 'package:dumbkey/model/card_details_model/card_details_model.dart';
import 'package:dumbkey/model/notes_model/notes_model.dart';
import 'package:dumbkey/model/password_model/password_model.dart';
import 'package:dumbkey/model/type_base_model.dart';
import 'package:dumbkey/utils/constants.dart';
import 'package:dumbkey/utils/key_name_constants.dart';
import 'package:firedart/firedart.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';

class DartFireStore {
  DartFireStore() {
    initFireDart();
    encryptor = GetIt.I.get<DataEncryptor>();
  }

  void initFireDart() {
    final projId = dotenv.get(
      Constants.firebaseProjID,
      fallback: Constants.noKey,
    );

    if (projId == Constants.noKey) throw Exception('Firebase project ID not found in .env file');

    Firestore.initialize(projId);
    database = Firestore.instance;
  }

  late final Firestore database;
  late final DataEncryptor encryptor;

  Future<void> createData(Map<String, dynamic> data) async {
    try {
      final encrypted = encryptor.encryptMap(data);
      await database
          .collection(Constants.mainCollection)
          .document((encrypted[KeyNames.id] as int).toString())
          .set(encrypted);
    } catch (e) {
      throw Exception('Error creating passkey($data): $e');
    }
  }

  Future<void> updateData(Map<String, dynamic> updateData) async {
    try {
      final encrypted = encryptor.encryptMap(updateData);
      await database
          .collection(Constants.mainCollection)
          .document((encrypted[KeyNames.id] as int).toString())
          .update(encrypted);
    } catch (e) {
      throw Exception('Error updating passkey($updateData): $e');
    }
  }

  Future<void> deleteData(int docId) async {
    try {
      await database.collection(Constants.mainCollection).document(docId.toString()).delete();
    } catch (e) {
      throw Exception('Error deleting passkey(docid:$docId): $e');
    }
  }

  Stream<List<TypeBase>> fetchAllPassKeys() {
    return database.collection(Constants.mainCollection).stream.map(
          (docs) => docs.map((doc) {
            final decrypted = encryptor.decryptMap(doc.map);
            final type = TypeBase.getDataType(decrypted[KeyNames.dataType] as String);
            return typeSelector(type, decrypted);
          }).toList(),
        );
  }

  TypeBase typeSelector(DataType type, Map<String, dynamic> data) {
    switch (type) {
      case DataType.password:
        return Password.fromMap(data);
      case DataType.notes:
        return Notes.fromMap(data);
      case DataType.card:
        return CardDetails.fromMap(data);
    }
  }

  void dispose() {
    database.close();
  }
}
