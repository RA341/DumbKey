import 'dart:async';

import 'package:dumbkey/model/card_details_model/card_details_model.dart';
import 'package:dumbkey/model/notes_model/notes_model.dart';
import 'package:dumbkey/model/password_model/password_model.dart';
import 'package:dumbkey/model/type_base_model.dart';
import 'package:dumbkey/services/encryption_handler.dart';
import 'package:dumbkey/utils/constants.dart';
import 'package:dumbkey/utils/helper_func.dart';
import 'package:dumbkey/utils/logger.dart';
import 'package:firedart/firestore/firestore.dart';
import 'package:firedart/firestore/models.dart';

class DartFireStore {
  DartFireStore() {
    database = dep.get<Firestore>();
    uuid = getUuid();
  }

  final encryptor = dep.get<IDataEncryptor>();
  late final String uuid;
  late final Firestore database;

  CollectionReference get getDataCollection =>
      database.collection(DumbData.userCollection).document(uuid).collection(DumbData.userData);

  Future<void> createData(Map<String, dynamic> data) async {
    try {
      await getDataCollection.document((data[DumbData.id] as int).toString()).set(data);
      logger.i('added data to remote ${data[DumbData.id]}');
    } catch (e) {
      logger.e('failed to add data to remote ${data[DumbData.id]}');
      rethrow;
    }
  }

  Future<void> updateData(Map<String, dynamic> updateData) async {
    try {
      await getDataCollection
          .document((updateData[DumbData.id] as int).toString())
          .update(updateData);
      logger.i('updated data to remote ${updateData[DumbData.id]}');
    } catch (e) {
      logger.e('failed data to remote ${updateData[DumbData.id]}');
      rethrow;
    }
  }

  Future<void> deleteData(int docId) async {
    try {
      await getDataCollection.document(docId.toString()).delete();
      logger.i('deleted from remote $docId');
    } catch (e) {
      logger.e('error deleting from remote $docId');
      rethrow;
    }
  }

  /// this stream will got to local storage
  Stream<Map<int, TypeBase>> fetchAllData() => getDataCollection.stream.map(
        (docs) => docs.map(decryptForLocal).fold(
          {},
          (prevMap, element) {
            prevMap[element.id] = element;
            return prevMap;
          },
        ),
      );

  Future<Map<int, TypeBase>> getAllDocs() async {
    final docs = await getDataCollection.get();
    final data = docs.map(decryptForLocal).fold(
      <int, TypeBase>{},
      (prevMap, element) => prevMap..addAll({element.id: element}),
    );
    return data;
  }

  TypeBase decryptForLocal(Document doc) {
    try {
      final local = cryptValue(doc.map, encryptor.decrypt);
      final type = TypeBase.getDataType(local[DumbData.dataType] as String);
      return typeSelector(type, local);
    } catch (e) {
      logger.e('error decrypting data ${doc.map}');
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
