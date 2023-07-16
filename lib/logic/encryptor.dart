import 'dart:convert';

import 'package:dumbkey/logic/secure_storage.dart';
import 'package:dumbkey/utils/key_name_constants.dart';
import 'package:encrypt/encrypt.dart' as en;
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:sodium_libs/sodium_libs.dart';

abstract class IDataEncryptor {
  String encrypt(String data);

  String decrypt(String encryptedData);

  Map<String, dynamic> encryptMap(Map<String, dynamic> data);

  Map<String, dynamic> decryptMap(Map<String, dynamic> data);
}

class DataEncryptor implements IDataEncryptor {
  DataEncryptor.init(String encryptionKey) {
    final key = en.Key.fromUtf8(encryptionKey);
    _iv = en.IV.fromLength(16);
    _encryptionManager = en.Encrypter(en.AES(key));
  }

  static Future<DataEncryptor> create() async {
    final encKey = await GetIt.I.get<SecureStorageHandler>().readData();
    if (encKey == null) throw Exception('No key found');
    return DataEncryptor.init(encKey);
  }

  late final en.Encrypter _encryptionManager;
  late final en.IV _iv;

  String encrypt(String data) {
    final en = _encryptionManager.encrypt(data, iv: _iv);
    return en.base64;
  }

  String decrypt(String encryptedData) {
    final encrypted = en.Encrypted.fromBase64(encryptedData);
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

class SodiumEncryptor implements IDataEncryptor {
  SodiumEncryptor.init({required this.sodium, required String key}) {
    const key = 'a32bitlenghtpasskeyrewsfr';
    const salt = 'asljfnasdfasdfsd';

    nonce = sodium.randombytes.buf(sodium.crypto.secretBox.nonceBytes);

    encryptionKey = generateSecretKey(key, salt);
  }

  late final Uint8List nonce;
  late final SecureKey encryptionKey;
  late final Sodium sodium;

  static Future<SodiumEncryptor> create() async {
    final encKey = await GetIt.I.get<SecureStorageHandler>().readData();
    if (encKey == null) throw Exception('No key found');

    final sodium = await SodiumInit.init();

    return SodiumEncryptor.init(sodium: sodium, key: encKey);
  }

  /// convert data to bytes for sodium encryption
  /// reference https://stackoverflow.com/questions/28565242/convert-uint8list-to-string-with-dart
  Uint8List convertDataToBytes(String data) => Uint8List.fromList(data.codeUnits);

  String convertBytesToData(Uint8List messageBytes) => String.fromCharCodes(messageBytes);

  SecureKey generateSecretKey(String password, String salt) {
    return sodium.crypto.pwhash.call(
      outLen: 32,
      password: password.toCharArray(),
      salt: convertDataToBytes(salt),
      opsLimit: sodium.crypto.pwhash.opsLimitSensitive,
      memLimit: sodium.crypto.pwhash.memLimitSensitive,
    );
  }

  @override
  String encrypt(String data) {
    final messageBytes = convertDataToBytes(data);

    final encryptedList = sodium.crypto.aead.encrypt(
      message: messageBytes,
      nonce: nonce,
      key: encryptionKey,
    );

    // convert back to string and encode to base64
    final str = convertBytesToData(encryptedList);
    return base64.encode(str.codeUnits);
  }

  @override
  String decrypt(String encryptedData) {
    // data is stored as base64 encoded string
    final messageBytes = base64.decode(encryptedData);

    final decryptedList = sodium.crypto.aead.decrypt(
      cipherText: messageBytes,
      nonce: nonce,
      key: encryptionKey,
    ); // convert back to string

    return convertBytesToData(decryptedList);
  }

  @override
  Map<String, dynamic> decryptMap(Map<String, dynamic> data) {
    // TODO: implement decryptMap
    throw UnimplementedError();
  }

  @override
  Map<String, dynamic> encryptMap(Map<String, dynamic> data) {
    // TODO: implement encryptMap
    throw UnimplementedError();
  }
}
