import 'dart:convert';

import 'package:dumbkey/services/database/user_data_handler.dart';
import 'package:dumbkey/utils/constants.dart';
import 'package:dumbkey/utils/logger.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:sodium_libs/sodium_libs.dart';

Map<String, dynamic> cryptMap(
  Map<String, dynamic> data,
  Map<String, dynamic> Function(Map<String, dynamic>, {List<String> blackListedKeys}) cryptor,
) {
  return cryptor(
    data,
    blackListedKeys: [...DumbData.blackListedKeys, ...DumbData.blackListedKeysLocal],
  );
}

Map<String, dynamic> cryptValue(
  Map<String, dynamic> data,
  String Function(String, Uint8List) cryptor,
) {
  assert(
    data.containsKey(DumbData.nonce),
    'nonce is missing,$data',
  );
  final remote = Map<String, dynamic>.from(data);

  final nonce = base64Decode(remote[DumbData.nonce] as String);
  // encrypt data that was not encrypted locally and reuse rest of the data
  for (final key in DumbData.blackListedKeysLocal) {
    if (remote.containsKey(key)) {
      remote[key] = cryptor(remote[key] as String, nonce);
    }
  }
  return remote;
}

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
    required this.encryptionKey,
  });

  late final SecureKey encryptionKey;
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

    // run in separate isolate as it is cpu intensive
    final key = await sodium.runIsolated<SecureKey>((sodium, secureKeys, keyPairs) {
      final password = encKey;
      final key = sodium.crypto.pwhash.call(
        outLen: 32,
        password: password.toCharArray(),
        salt: salt,
        opsLimit: sodium.crypto.pwhash.opsLimitSensitive,
        memLimit: sodium.crypto.pwhash.memLimitSensitive,
      );
      return key;
    });

    return SodiumEncryptor.init(sodium: sodium, encryptionKey: key);
  }

  /// convert data to bytes for sodium encryption
  /// reference https://stackoverflow.com/questions/28565242/convert-uint8list-to-string-with-dart
  Uint8List convertDataToBytes(String data) => Uint8List.fromList(data.codeUnits);

  String convertBytesToData(Uint8List messageBytes) => String.fromCharCodes(messageBytes);

  @override
  String encrypt(String data, Uint8List nonce) {
    try {
      final messageBytes = convertDataToBytes(data);

      final encryptedList = sodium.crypto.aead.encrypt(
        message: messageBytes,
        nonce: nonce,
        key: encryptionKey,
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
        key: encryptionKey,
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
