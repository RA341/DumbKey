import 'package:dumbkey/database/dart_firestore.dart';
import 'package:dumbkey/database/firestore_stub.dart';
import 'package:dumbkey/model/passkey_model.dart';
import 'package:isar/isar.dart';

class DesktopFireStore extends FireStoreBase {
  DesktopFireStore(super.isar) {
    firestore = DartFireStore();
    _listenToChangesFromFireBase();
  }

  late final DartFireStore firestore;

  @override
  Future<void> createPassKey(PassKey passkey) async {
    await firestore.createPassKey(passkey);
    await isarCreateOrUpdate(passkey);
  }

  @override
  Future<void> deletePassKey(PassKey passkey) async {
    await firestore.deletePassKey(passkey);
    await isarDelete(passkey.docId); // let the fire store complete first
  }

  @override
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

    await isarCreateOrUpdate(PassKey.fromJson(updateData));
  }

  @override
  Stream<List<PassKey>> fetchAllPassKeys() {
    return isarDb.passKeys.where().build().watch(fireImmediately: true);
  }

  void _listenToChangesFromFireBase() {
    firestore.fetchAllPassKeys().listen((documents) async {
      await isarCreateOrUpdateAll(documents);
    });
  }
}
