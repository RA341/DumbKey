import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class ISecureStorage {
  Future<void> writeData({required String key, required String? value});

  Future<void> deleteData({required String key});

  Future<String?> readData({required String key});
}

class SecureStorageHandler implements ISecureStorage {
  SecureStorageHandler() {
    const iosOptions = IOSOptions(accessibility: KeychainAccessibility.first_unlock);
    _secureDb = FlutterSecureStorage(
      aOptions: _getAndroidOptions(),
      iOptions: iosOptions,
    );
  }

  /// important refer https://pub.dev/packages/flutter_secure_storage for platform specific dependency when building
  late final FlutterSecureStorage _secureDb;

  AndroidOptions _getAndroidOptions() => const AndroidOptions(
        encryptedSharedPreferences: true,
      );

  @override
  Future<void> deleteData({required String key}) async {
    await _secureDb.delete(key: key);
  }

  @override
  Future<String?> readData({required String key}) => _secureDb.read(key: key);

  @override
  Future<void> writeData({required String key, required String? value}) async {
    await _secureDb.write(key: key, value: value);
  }
}
