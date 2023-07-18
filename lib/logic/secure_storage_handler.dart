import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageHandler {
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

  static const String encryptionKey = 'encrypt';

  Future<void> writeData(String? value, {String key = encryptionKey}) async {
    await _secureDb.write(key: key, value: value);
  }

  Future<void> deleteData({String key = encryptionKey}) async {
    await _secureDb.delete(key: key);
  }

  Future<String?> readData({String key = encryptionKey}) async => _secureDb.read(key: key);
}
