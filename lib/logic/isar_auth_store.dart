import 'package:dumbkey/logic/secure_storage.dart';
import 'package:firedart/auth/token_store.dart';
import 'package:get_it/get_it.dart';

class IsarStore extends TokenStore {
  IsarStore() {
    // TODO(IsarStore): get from Dependency Injection
  }

  String? userIdS;

  String? idTokenS;

  String? refreshTokenS;

  String? expiryTokenS;

  static const String userIdKey = 'userId';
  static const String idTokenKey = 'idToken';
  static const String refreshTokenKey = 'refreshToken';
  static const String expiryKey = 'expiry';

  Future<void> getValues() async {
    userIdS = await secDb.readData(key: userIdKey);
    idTokenS = await secDb.readData(key: idTokenKey);
    refreshTokenS = await secDb.readData(key: refreshTokenKey);
    expiryTokenS = await secDb.readData(key: expiryKey);
  }

  Future<void> setValues() async {
    await secDb.writeData(userIdS, key: userIdKey);
    await secDb.writeData(idTokenS, key: idTokenKey);
    await secDb.writeData(refreshTokenS, key: refreshTokenKey);
    await secDb.writeData(expiryTokenS, key: expiryKey);
  }

  SecureStorageHandler secDb = GetIt.I.get<SecureStorageHandler>();

  @override
  Future<void> delete() async {
    userIdS = null;
    idTokenS = null;
    refreshTokenS = null;
    expiryTokenS = null;

    await setValues();
  }

  @override
  Token? read() {
    if (userIdS == null || idTokenS == null || refreshTokenS == null || expiryTokenS == null) {
      return null;
    }

    return Token(
      userIdS,
      idTokenS!,
      refreshTokenS!,
      DateTime.parse(expiryTokenS!),
    );
  }

  @override
  Future<void> write(Token? token) async {
    if (token == null) return;
    final data = token.toMap();

    userIdS = data[userIdKey] as String;
    idTokenS = data[idTokenKey] as String;
    refreshTokenS = data[refreshTokenKey] as String;
    expiryTokenS = data[expiryKey] as String;

    await setValues();
  }
}
