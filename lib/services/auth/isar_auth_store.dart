import 'package:dumbkey/services/settings_handler.dart';
import 'package:dumbkey/utils/helper_func.dart';
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
    dep.get<SettingsHandler>().settingsInst
      ..userId = null
      ..idToken = null
      ..refreshToken = null
      ..expiry = null;

    dep.get<SettingsHandler>().refreshSettings();
  }

  @override
  Token? read() {
    if (dep.get<SettingsHandler>().settingsInst.userId == null ||
        dep.get<SettingsHandler>().settingsInst.idToken == null ||
        dep.get<SettingsHandler>().settingsInst.refreshToken == null ||
        dep.get<SettingsHandler>().settingsInst.expiry == null) return null;

    final userId = dep.get<SettingsHandler>().settingsInst.userId;
    final idToken = dep.get<SettingsHandler>().settingsInst.idToken;
    final refreshToken = dep.get<SettingsHandler>().settingsInst.refreshToken;
    final expiry = DateTime.parse(dep.get<SettingsHandler>().settingsInst.expiry!);

    return Token(userId, idToken!, refreshToken!, expiry);
  }

  @override
  Future<void> write(Token? token) async {
    if (token == null) return;
    final data = token.toMap();

    dep.get<SettingsHandler>().settingsInst
      ..userId = data[userIdKey] as String
      ..idToken = data[idTokenKey] as String
      ..refreshToken = data[refreshTokenKey] as String
      ..expiry = data[expiryKey] as String;

    dep.get<SettingsHandler>().refreshSettings();
  }
}
