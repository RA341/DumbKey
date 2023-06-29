import 'package:dumbkey/utils/constants.dart';
import 'package:dumbkey/utils/key_name_constants.dart';
import 'package:encrypt/encrypt.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AESEncryption {
  AESEncryption() {
    final envKey = dotenv.get(
      Constants.key,
      fallback: Constants.noKey,
    );
    if (envKey == Constants.noKey) throw Exception('No key found');
    final key = Key.fromUtf8(envKey);
    _iv = IV.fromLength(16);
    _encryptionManager = Encrypter(AES(key));
  }

  late final Encrypter _encryptionManager;
  late final IV _iv;

  String encrypt(String data) {
    final en = _encryptionManager.encrypt(data, iv: _iv);
    return en.base64;
  }

  String decrypt(String encryptedData) {
    final encrypted = Encrypted.fromBase64(encryptedData);
    final data = _encryptionManager.decrypt(encrypted, iv: _iv);
    return data;
  }

  Map<String, dynamic> encryptMap(Map<String, dynamic> data) {
    try {
      for (final key in data.keys) {
        if (key == KeyNames.id) continue;
        data[key] = data[key] == null ? data[key] : encrypt(data[key] as String);
      }
      return data;
    } catch (e) {
      throw Exception('Error encrypting map($data}): $e');
    }
  }

  Map<String, dynamic> decryptMap(Map<String, dynamic> data) {
    try {
      for (final key in data.keys) {
        if (key == KeyNames.id) continue;
        data[key] = data[key] == null ? data[key] : decrypt(data[key] as String);
      }
      return data;
    } catch (e) {
      throw Exception('Error decrypting map($data}): $e');
    }
  }
}
