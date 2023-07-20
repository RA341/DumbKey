import 'package:dumbkey/model/settings_model/settings.dart';
import 'package:dumbkey/services/settings_handler.dart';
import 'package:firedart/auth/token_store.dart';
import 'package:firedart/firedart.dart';
import 'package:get_it/get_it.dart';

class AuthLocalStore extends TokenStore {
  Settings inst = GetIt.I.get<SettingsHandler>().settingsInst;

  static const String userIdKey = 'userId';
  static const String idTokenKey = 'idToken';
  static const String refreshTokenKey = 'refreshToken';
  static const String expiryKey = 'expiry';

  @override
  void delete() {
    inst
      ..userId = null
      ..idToken = null
      ..refreshToken = null
      ..expiry = null;

    GetIt.I.get<SettingsHandler>().refreshSettings();
  }

  @override
  Token? read() {
    if (inst.userId == null ||
        inst.idToken == null ||
        inst.refreshToken == null ||
        inst.expiry == null) return null;

    final userId = inst.userId;
    final idToken = inst.idToken;
    final refreshToken = inst.refreshToken;
    final expiry = DateTime.parse(inst.expiry!);

    return Token(userId, idToken!, refreshToken!, expiry);
  }

  @override
  Future<void> write(Token? token) async {
    if (token == null) return;
    final data = token.toMap();

    inst
      ..userId = data[userIdKey] as String
      ..idToken = data[idTokenKey] as String
      ..refreshToken = data[refreshTokenKey] as String
      ..expiry = data[expiryKey] as String;

    GetIt.I.get<SettingsHandler>().refreshSettings();
  }
}
