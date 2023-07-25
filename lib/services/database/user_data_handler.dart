import 'package:dumbkey/services/auth/isar_auth_store.dart';
import 'package:dumbkey/services/database/local/secure_storage_handler.dart';
import 'package:dumbkey/services/database/remote/remote_user_data.dart';
import 'package:dumbkey/utils/constants.dart';
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
    try {
      final data = await remote.getUserData(docId: getUuid());
      for (final entry in data.entries) {
        await local.writeData(key: entry.key, value: entry.value.toString());
      }
    } on Exception catch (e) {
      logger.e('Error retrieving user data from remote', e);
      rethrow;
    }
  }

  Future<void> syncUserData() async {
    final userDataKeys = [DumbData.salt];
    for (final key in userDataKeys) {
      final keyExists = await local.checkKey(key);
      if (keyExists == false) {
        logger.i('key $key not found locally, retrieving from remote');
        await retrieveDataFromRemote();
        break;
      }
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
