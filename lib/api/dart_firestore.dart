import 'dart:async';

import 'package:dumbkey/logic/encryption_handler.dart';
import 'package:dumbkey/model/card_details_model/card_details_model.dart';
import 'package:dumbkey/model/notes_model/notes_model.dart';
import 'package:dumbkey/model/password_model/password_model.dart';
import 'package:dumbkey/model/type_base_model.dart';
import 'package:dumbkey/utils/constants.dart';
import 'package:firedart/firedart.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';

class DartFireStore {
  DartFireStore() {
    initFireDart();
    encryptor = GetIt.I.get<IDataEncryptor>();
  }

  void initFireDart() {
    final projId = dotenv.get(
      DumbData.firebaseProjID,
      fallback: DumbData.noKey,
    );

    if (projId == DumbData.noKey) throw Exception('Firebase project ID not found in .env file');

    Firestore.initialize(projId);
    database = Firestore.instance;
  }

  late final Firestore database;
  late final IDataEncryptor encryptor;

  Future<void> createData(Map<String, dynamic> data) async {
    try {
      final encrypted = encryptor.encryptMap(data);
      await database
          .collection(DumbData.mainCollection)
          .document((encrypted[DumbData.id] as int).toString())
          .set(encrypted);
    } catch (e) {
      throw Exception('Error creating passkey($data): $e');
    }
  }

  Future<void> updateData(Map<String, dynamic> updateData) async {
    try {
      final encrypted = encryptor.encryptMap(updateData);
      await database
          .collection(DumbData.mainCollection)
          .document((encrypted[DumbData.id] as int).toString())
          .update(encrypted);
    } catch (e) {
      throw Exception('Error updating passkey($updateData): $e');
    }
  }

  Future<void> deleteData(int docId) async {
    try {
      await database.collection(DumbData.mainCollection).document(docId.toString()).delete();
    } catch (e) {
      throw Exception('Error deleting passkey(docid:$docId): $e');
    }
  }

  Stream<List<TypeBase>> fetchAllPassKeys() {
    return database.collection(DumbData.mainCollection).stream.map(
          (docs) => docs.map((doc) {
            final decrypted = encryptor.decryptMap(doc.map);
            final type = TypeBase.getDataType(decrypted[DumbData.dataType] as String);
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
