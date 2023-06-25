import 'package:dumbkey/database/dart_firestore.dart';
import 'package:dumbkey/database/isar_mixin.dart';
import 'package:dumbkey/model/passkey_model.dart';
import 'package:get_it/get_it.dart';
import 'package:isar/isar.dart';
import 'package:logger/logger.dart';

class DatabaseHandler with IsarDbMixin {
  DatabaseHandler() {
    firestore = GetIt.I.get<DartFireStore>();
    _listenToChangesFromFireBase();
  }

  late final DartFireStore firestore;

  
  Future<void> createPassKey(PassKey passkey) async {
    GetIt.I.get<Logger>().d('Creating Data',passkey.toJSON());
    await firestore.createPassKey(passkey);
    await isarCreateOrUpdate(passkey);
  }

  
  Future<void> deletePassKey(PassKey passkey) async {
    GetIt.I.get<Logger>().d('Deleting Data',passkey.toJSON());
    await firestore.deletePassKey(passkey);
    await isarDelete(passkey.docId); // let the fire store complete first
  }

  
  Future<void> updatePassKey(String docId, Map<String, dynamic> updateData) async {
    assert(
      !updateData.containsValue(null),
      'update data contains null,$updateData',
    );

    await firestore.updatePassKey(docId, updateData);

    // isar needs the docId inside pass key to update
    updateData.addAll({'docId': int.parse(docId)});
    assert(
      updateData.containsKey('docId'),
      'update data does not contain ID,$updateData',
    );
    GetIt.I.get<Logger>().d('Update Data',[updateData]);
    await isarCreateOrUpdate(PassKey.fromJson(updateData));
  }
  
  Stream<List<PassKey>> fetchAllPassKeys() {
    return isarDb.passKeys.where().build().watch(fireImmediately: true);
  }

  void _listenToChangesFromFireBase() {
    firestore.fetchAllPassKeys().listen((documents) async {
      final allPassKeys = await isarDb.passKeys.where().findAll();

      for (final passKey in allPassKeys) {
        // remove the passkey locally if not present in firebase
        // used here because other devices can delete the passkey
        if (documents.contains(passKey) == false) {
          await isarDelete(passKey.docId);
        }
      }

      await isarCreateOrUpdateAll(documents);
    });
  }
}
