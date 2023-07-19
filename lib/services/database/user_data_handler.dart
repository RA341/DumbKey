import 'package:dumbkey/services/auth/isar_auth_store.dart';
import 'package:dumbkey/services/database/local/secure_storage_handler.dart';
import 'package:dumbkey/services/database/remote/remote_user_data.dart';
import 'package:get_it/get_it.dart';

class UserDataHandler {
  UserDataHandler() {
    remote = FirebaseUser();
    local = SecureStorageHandler();
  }

  late final IRemoteUserDb remote;
  late final ISecureStorage local;

  Future<String?> getUuid(String key, String value) async {
    String? uuid = value;
    if (key != AuthLocalStore.userIdKey) {
      uuid = await GetIt.I.get<SecureStorageHandler>().readData(key: AuthLocalStore.userIdKey);
      throwIf(uuid == null, 'uuid not found');
    }
    return uuid;
  }

  Future<void> addUserData(String key, String value) async {
    await local.writeData(key: key, value: value);

    final uuid = await getUuid(key, value);

    await remote.addUserData(
      data: {key: value},
      docId: uuid!,
    );
  }

  Future<void> deleteUserData(String key) async {
    await local.deleteData(key: key);

    final uuid = await GetIt.I.get<SecureStorageHandler>().readData(key: AuthLocalStore.userIdKey);
    throwIf(uuid == null, 'uuid not found');

    await remote.deleteUserData(docId: uuid!);
  }

  Future<String?> getUserData(String key) async {
    return GetIt.I.get<SecureStorageHandler>().readData(key: key);
  }
}
