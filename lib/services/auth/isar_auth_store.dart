import 'package:dumbkey/services/settings_handler.dart';
import 'package:firedart/auth/token_store.dart';
import 'package:firedart/firedart.dart';
import 'package:get_it/get_it.dart';

class AuthLocalStore extends TokenStore {
  static const String userIdKey = 'userId';
  static const String idTokenKey = 'idToken';
  static const String refreshTokenKey = 'refreshToken';
  static const String expiryKey = 'expiry';

  @override
  void delete() {
    GetIt.I.get<SettingsHandler>().settingsInst
      ..userId = null
      ..idToken = null
      ..refreshToken = null
      ..expiry = null;

    GetIt.I.get<SettingsHandler>().refreshSettings();
  }

  @override
  Token? read() {
    if (GetIt.I.get<SettingsHandler>().settingsInst.userId == null ||
        GetIt.I.get<SettingsHandler>().settingsInst.idToken == null ||
        GetIt.I.get<SettingsHandler>().settingsInst.refreshToken == null ||
        GetIt.I.get<SettingsHandler>().settingsInst.expiry == null) return null;

    final userId = GetIt.I.get<SettingsHandler>().settingsInst.userId;
    final idToken = GetIt.I.get<SettingsHandler>().settingsInst.idToken;
    final refreshToken = GetIt.I.get<SettingsHandler>().settingsInst.refreshToken;
    final expiry = DateTime.parse(GetIt.I.get<SettingsHandler>().settingsInst.expiry!);

    return Token(userId, idToken!, refreshToken!, expiry);
  }

  @override
  Future<void> write(Token? token) async {
    if (token == null) return;
    final data = token.toMap();

    GetIt.I.get<SettingsHandler>().settingsInst
      ..userId = data[userIdKey] as String
      ..idToken = data[idTokenKey] as String
      ..refreshToken = data[refreshTokenKey] as String
      ..expiry = data[expiryKey] as String;

    GetIt.I.get<SettingsHandler>().refreshSettings();
  }
}
