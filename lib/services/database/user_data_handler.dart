import 'package:dumbkey/services/auth/isar_auth_store.dart';
import 'package:dumbkey/services/database/local/secure_storage_handler.dart';
import 'package:dumbkey/services/database/remote/remote_user_data.dart';
import 'package:dumbkey/utils/helper_func.dart';
import 'package:dumbkey/utils/logger.dart';
import 'package:get_it/get_it.dart';

class UserDataHandler {
  UserDataHandler() {
    remote = FirebaseUser();
    local = SecureStorageHandler();
  }

  late final IRemoteUserDb remote;
  late final ISecureStorage local;

  Future<void> retrieveDataFromRemote() async {
    final uuid = getUuid();
    final data = await remote.getUserData(docId: uuid);
    for (final entry in data.entries) {
      await local.writeData(key: entry.key, value: entry.value.toString());
    }
  }

  Future<void> addUserData({required String key, required String value}) async {
    await local.writeData(key: key, value: value);

    final uuid = getUuid();
    try {
      await remote.addUserData(
        data: {key: value},
        docId: uuid,
      );
    } on Exception catch (e) {
      logger.e('Error uploading user data', e);
      rethrow;
    }
  }

  Future<void> deleteUserData({required String key}) async {
    await local.deleteData(key: key);

    final uuid = await GetIt.I.get<SecureStorageHandler>().readData(key: AuthLocalStore.userIdKey);
    throwIf(uuid == null, 'uuid not found');

    await remote.deleteUserData(docId: uuid!);
  }

  Future<String?> getUserData({required String key}) async {
    return GetIt.I.get<SecureStorageHandler>().readData(key: key);
  }
}
