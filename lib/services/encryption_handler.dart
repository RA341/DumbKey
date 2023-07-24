import 'dart:convert';

import 'package:dumbkey/services/database/user_data_handler.dart';
import 'package:dumbkey/utils/constants.dart';
import 'package:dumbkey/utils/logger.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:sodium_libs/sodium_libs.dart';

abstract class IDataEncryptor {
  String encrypt(String data, Uint8List nonce);

  String decrypt(String encryptedData, Uint8List nonce);

  Map<String, dynamic> encryptMap(
    Map<String, dynamic> data, {
    List<String> blackListedKeys = const [],
  });

  Map<String, dynamic> decryptMap(
    Map<String, dynamic> data, {
    List<String> blackListedKeys = const [],
  });
}

class SodiumEncryptor implements IDataEncryptor {
  SodiumEncryptor.init({
    required this.sodium,
    required String key,
    required Uint8List salt,
  }) {
    _encryptionKey = generateSecretKey(key, salt);
  }

  late final SecureKey _encryptionKey;
  late final Sodium sodium;

  static Future<SodiumEncryptor> create({required bool signup}) async {
    final encKey = await GetIt.I.get<UserDataHandler>().getUserData(key: DumbData.encryptionKey);
    if (encKey == null) throw Exception('No key found');

    final Uint8List salt;
    final sodium = await SodiumInit.init();
    if (signup) {
      // generate new salt and save it
      salt = sodium.randombytes.buf(16);
      await GetIt.I.get<UserDataHandler>().addUserData(
            key: DumbData.salt,
            value: base64Encode(String.fromCharCodes(salt).codeUnits),
          );
    } else {
      final g = await GetIt.I.get<UserDataHandler>().getUserData(key: DumbData.salt);
      if (g == null) throw Exception('salt not found');
      salt = Uint8List.fromList(base64Decode(g));
    }

    return SodiumEncryptor.init(sodium: sodium, key: encKey, salt: salt);
  }

  /// convert data to bytes for sodium encryption
  /// reference https://stackoverflow.com/questions/28565242/convert-uint8list-to-string-with-dart
  Uint8List convertDataToBytes(String data) => Uint8List.fromList(data.codeUnits);

  String convertBytesToData(Uint8List messageBytes) => String.fromCharCodes(messageBytes);

  /// On login and signup ui freezes here because of pwhash memlimit and opslimit
  SecureKey generateSecretKey(String password, Uint8List salt) {
    return sodium.crypto.pwhash.call(
      outLen: 32,
      password: password.toCharArray(),
      salt: salt,
      opsLimit: sodium.crypto.pwhash.opsLimitInteractive,
      memLimit: sodium.crypto.pwhash.memLimitInteractive,
    );
  }

  @override
  String encrypt(String data, Uint8List nonce) {
    try {
      final messageBytes = convertDataToBytes(data);

      final encryptedList = sodium.crypto.aead.encrypt(
        message: messageBytes,
        nonce: nonce,
        key: _encryptionKey,
      );

      // convert back to string and encode to base64
      final str = convertBytesToData(encryptedList);
      logger.d('encrypted data $data');
      return base64Encode(str.codeUnits);
    } catch (e) {
      logger.e('error encrypting data: $data');
      rethrow;
    }
  }

  @override
  String decrypt(String encryptedData, Uint8List nonce) {
    try {
      // data is stored as base64 encoded string
      final messageBytes = base64Decode(encryptedData);

      final decryptedList = sodium.crypto.aead.decrypt(
        cipherText: messageBytes,
        nonce: nonce,
        key: _encryptionKey,
      ); // convert back to string
      logger.d('decrypted data $encryptedData');
      return convertBytesToData(decryptedList);
    } catch (e) {
      logger.e('error decrypting data: $encryptedData');
      rethrow;
    }
  }

  @override
  Map<String, dynamic> decryptMap(
    Map<String, dynamic> data, {
    List<String> blackListedKeys = const [],
  }) {
    final nonce = base64Decode(data[DumbData.nonce] as String);

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
    final Uint8List nonce;
    final tmp = data[DumbData.nonce] as String;
    if (tmp.isNotEmpty) {
      nonce = base64Decode(tmp);
    } else {
      nonce = sodium.randombytes.buf(sodium.crypto.aead.nonceBytes);
    }

    for (final key in data.keys) {
      if (blackListedKeys.contains(key)) continue;

      data[key] = data[key] == null ? data[key] : encrypt(data[key] as String, nonce);
    }

    data[DumbData.nonce] = base64Encode(convertBytesToData(nonce).codeUnits);

    return data;
  }
}
