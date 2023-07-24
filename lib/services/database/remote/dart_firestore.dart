import 'dart:async';

import 'package:dumbkey/model/card_details_model/card_details_model.dart';
import 'package:dumbkey/model/notes_model/notes_model.dart';
import 'package:dumbkey/model/password_model/password_model.dart';
import 'package:dumbkey/model/type_base_model.dart';
import 'package:dumbkey/services/database/database_handler.dart';
import 'package:dumbkey/services/encryption_handler.dart';
import 'package:dumbkey/utils/constants.dart';
import 'package:dumbkey/utils/helper_func.dart';
import 'package:dumbkey/utils/logger.dart';
import 'package:firedart/firestore/firestore.dart';
import 'package:firedart/firestore/models.dart';
import 'package:get_it/get_it.dart';

class DartFireStore {
  DartFireStore() {
    database = Firestore.instance;
    uuid = getUuid();
  }

  final encryptor = GetIt.I.get<IDataEncryptor>();
  late final String uuid;
  late final Firestore database;

  Future<void> createData(Map<String, dynamic> data) async {
    try {
      await database.collection(uuid).document((data[DumbData.id] as int).toString()).set(data);
      logger.d('added data to remote', [data]);
    } catch (e) {
      logger.e('failed to add data to remote', [data]);
      throw Exception('Error creating passkey($data): $e');
    }
  }

  Future<void> updateData(Map<String, dynamic> updateData) async {
    try {
      await database
          .collection(uuid)
          .document((updateData[DumbData.id] as int).toString())
          .update(updateData);
      logger.d('updated data to remote', [updateData]);
    } on Exception catch (e) {
      logger.e('failed data to remote', [updateData]);
      throw Exception('Error updating data: $e');
    }
  }

  Future<void> deleteData(int docId) async {
    try {
      await database.collection(uuid).document(docId.toString()).delete();
      logger.i('deleted from remote', [docId]);
    } catch (e) {
      logger.e('error deleting from remote', [docId]);
      throw Exception('Error deleting data: $e');
    }
  }

  /// this stream will got to local storage
  Stream<List<TypeBase>> fetchAllData() {
    return database.collection(uuid).stream.map((docs) => docs.map(decryptForLocal).toList());
  }

  TypeBase decryptForLocal(Document doc) {
    try {
      final local = cryptValue(doc.map, encryptor.decrypt);
      final type = TypeBase.getDataType(local[DumbData.dataType] as String);
      return typeSelector(type, local);
    } catch (e) {
      logger.e('error decrypting data', [doc.map]);
      throw Exception('Error decrypting remote: $e');
    }
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
