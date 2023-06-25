import 'package:dumbkey/model/settings.dart';
import 'package:isar/isar.dart';

class SettingsHandler {

  SettingsHandler._create({required Isar settings, required Settings settingsInst,}){
    settingsDb = settings;
    settingsInst = settingsInst;
  }

  late final Settings settingsInst;
  late final Isar settingsDb;

  static Future<SettingsHandler> initSettings(Isar isar) async {
    var config = await isar.settings.get(0);

    if (config == null) {
      config = Settings(id: 0);
      await isar.writeTxn(() async => await isar.settings.put(config!));
    }
    return SettingsHandler._create(settings: isar,settingsInst: config);
  }


  void addToOffline(int id) {

  }
}