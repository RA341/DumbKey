import 'dart:async';

import 'package:dumbkey/model/card_details_model/card_details_model.dart';
import 'package:dumbkey/model/notes_model/notes_model.dart';
import 'package:dumbkey/model/password_model/password_model.dart';
import 'package:dumbkey/model/type_base_model.dart';
import 'package:dumbkey/services/database/database_handler.dart';
import 'package:dumbkey/services/encryption_handler.dart';
import 'package:dumbkey/utils/constants.dart';
import 'package:dumbkey/utils/helper_func.dart';
import 'package:firedart/firestore/firestore.dart';
import 'package:get_it/get_it.dart';

class DartFireStore {
  DartFireStore() {
    database = Firestore.instance;
    uuid = getUuid();
  }

  late final String uuid;
  late final Firestore database;

  Future<void> createData(Map<String, dynamic> data) async {
    try {
      await database.collection(uuid).document((data[DumbData.id] as int).toString()).set(data);
    } catch (e) {
      throw Exception('Error creating passkey($data): $e');
    }
  }

  Future<void> updateData(Map<String, dynamic> updateData) async {
    try {
      await database
          .collection(uuid)
          .document((updateData[DumbData.id] as int).toString())
          .update(updateData);
    } catch (e) {
      throw Exception('Error updating passkey($updateData): $e');
    }
  }

  Future<void> deleteData(int docId) async {
    try {
      await database.collection(uuid).document(docId.toString()).delete();
    } catch (e) {
      throw Exception('Error deleting passkey(docid:$docId): $e');
    }
  }

  /// this stream will got to local storage
  Stream<List<TypeBase>> fetchAllPassKeys() {
    final encryptor = GetIt.I.get<IDataEncryptor>();
    return database.collection(uuid).stream.map(
          (docs) => docs.map((doc) {
            final local = cryptValue(doc.map, encryptor.decrypt);
            final type = TypeBase.getDataType(local[DumbData.dataType] as String);
            return typeSelector(type, local);
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
