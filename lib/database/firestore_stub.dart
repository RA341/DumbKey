import 'package:dumbkey/model/passkey_model.dart';
import 'package:isar/isar.dart';

abstract class FireStoreBase {
  FireStoreBase(Isar isar) {
    isarDb = isar;
  }

  late final Isar isarDb;

  Future<void> createPassKey(PassKey passkey);

  Future<void> deletePassKey(PassKey passkey);

  Future<void> updatePassKey(String docId, Map<String, dynamic> updateData);

  Stream<List<PassKey>> fetchAllPassKeys();

  Future<void> isarDelete(int id) async {
    await isarDb.writeTxn(() async {
      await isarDb.passKeys.delete(id);
    });
  }

  Future<void> isarCreateOrUpdateAll(List<PassKey> passkey) async {
    await isarDb.writeTxn(() async {
      await isarDb.passKeys.putAll(passkey);
    });
  }

  Future<void> isarCreateOrUpdate(PassKey passkey) async {
    await isarDb.writeTxn(() async {
      await isarDb.passKeys.put(passkey);
    });
  }

}
