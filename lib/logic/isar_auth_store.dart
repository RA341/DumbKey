import 'package:dumbkey/logic/encryptor.dart';
import 'package:dumbkey/logic/settings_handler.dart';
import 'package:dumbkey/model/settings_model/settings.dart';
import 'package:firedart/auth/token_store.dart';
import 'package:get_it/get_it.dart';

class IsarStore extends TokenStore {
  IsarStore() {
    // TODO(IsarStore): get from Dependency Injection
  }

  Settings inst = GetIt.I.get<SettingsHandler>().settingsInst;
  AESEncryption encryptor = AESEncryption();

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

    final userId = encryptor.decrypt(inst.userId!);
    final idToken = encryptor.decrypt(inst.idToken!);
    final refreshToken = encryptor.decrypt(inst.refreshToken!);
    final expiry = DateTime.parse(encryptor.decrypt(inst.expiry!));

    return Token(userId, idToken, refreshToken, expiry);
  }

  @override
  void write(Token? token) {
    if (token == null) return;
    var data = token.toMap();
    data = encryptor.encryptMap(data);

    inst
      ..userId = data['userId'] as String
      ..idToken = data['idToken'] as String
      ..refreshToken = data['refreshToken'] as String
      ..expiry = data['expiry'] as String;

    GetIt.I.get<SettingsHandler>().refreshSettings();
  }
}
