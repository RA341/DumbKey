import 'package:dumbkey/model/passkey_model.dart';
import 'package:dumbkey/utils/constants.dart';
import 'package:get_it/get_it.dart';
import 'package:isar/isar.dart';

mixin IsarDbMixin {

  final Isar isarDb = GetIt.I.get<Isar>();

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

class OfflineQueueHandler {

  final Isar isarDb = GetIt.I.get<Isar>(instanceName: Constants.offQueue);

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
