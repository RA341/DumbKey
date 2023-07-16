import 'dart:convert';

import 'package:dumbkey/logic/secure_storage.dart';
import 'package:dumbkey/utils/key_name_constants.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:sodium_libs/sodium_libs.dart';

abstract class IDataEncryptor {
  String encrypt(String data, Uint8List nonce);

  String decrypt(String encryptedData, Uint8List nonce);

  Map<String, dynamic> encryptMap(Map<String, dynamic> data);

  Map<String, dynamic> decryptMap(Map<String, dynamic> data);
}

class SodiumEncryptor implements IDataEncryptor {
  SodiumEncryptor.init({
    required this.sodium,
    required String key,
    required String salt,
  }) {
    _encryptionKey = generateSecretKey(key, salt);
  }

  late final SecureKey _encryptionKey;
  late final Sodium sodium;

  static Future<SodiumEncryptor> create() async {
    final encKey = await GetIt.I.get<SecureStorageHandler>().readData();
    if (encKey == null) throw Exception('No key found');

    final sodium = await SodiumInit.init();

    return SodiumEncryptor.init(sodium: sodium, key: encKey, salt: '');
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
  String encrypt(String data, Uint8List nonce) {
    final messageBytes = convertDataToBytes(data);

    final encryptedList = sodium.crypto.aead.encrypt(
      message: messageBytes,
      nonce: nonce,
      key: _encryptionKey,
    );

    // convert back to string and encode to base64
    final str = convertBytesToData(encryptedList);
    return base64Encode(str.codeUnits);
  }

  @override
  String decrypt(String encryptedData, Uint8List nonce) {
    // data is stored as base64 encoded string
    final messageBytes = base64Decode(encryptedData);

    final decryptedList = sodium.crypto.aead.decrypt(
      cipherText: messageBytes,
      nonce: nonce,
      key: _encryptionKey,
    ); // convert back to string

    return convertBytesToData(decryptedList);
  }

  @override
  Map<String, dynamic> decryptMap(
    Map<String, dynamic> data, {
    List<String> blackListedKeys = const [],
  }) {
    final nonce = base64Decode(data[KeyNames.nonce] as String);

    for (final key in data.keys) {
      if (blackListedKeys.contains(key)) continue;
      data[key] = data[key] == null ? data[key] : decrypt(data[key] as String, nonce);
    }

    return data;
  }

  @override
  Map<String, dynamic> encryptMap(
    Map<String, dynamic> data, {
    List<String> blackListedKeys = const [],
  }) {
    final nonce = sodium.randombytes.buf(sodium.crypto.aead.nonceBytes);
    for (final key in data.keys) {
      if (blackListedKeys.contains(key)) continue;

      data[key] = data[key] == null ? data[key] : decrypt(data[key] as String, nonce);
    }

    data[KeyNames.nonce] = base64Encode(convertBytesToData(nonce).codeUnits);

    return data;
  }
}
