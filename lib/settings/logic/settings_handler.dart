import 'package:dumbkey/model/settings_model/settings.dart';
import 'package:isar/isar.dart';

class SettingsHandler {
  SettingsHandler._create({
    required Isar isar,
    required Settings setInst,
  }) {
    isarInst = isar;
    settingsInst = setInst;
  }

  late Settings settingsInst;
  late final Isar isarInst;

  static Future<SettingsHandler> initSettings(Isar isar) async {
    var config = await isar.settings.get(0);

    if (config == null) {
      config = Settings();
      await isar.writeTxn(() async => await isar.settings.put(config!));
    }

    return SettingsHandler._create(isar: isar, setInst: config);
  }

  void clearSettings() {
    isarInst.writeTxnSync(() {
      settingsInst = Settings();
    });
    refreshSettings();
  }

  void refreshSettings() {
    // logger.d('Old settings', settingsInst.idToken.toString());
    isarInst.writeTxnSync(() {
      isarInst.settings.putSync(settingsInst);
    });

    settingsInst = isarInst.settings.getSync(0)!;

    // settingsInst = tmp!;
    // logger.d('New settings', settingsInst.idToken.toString());
  }

  void addCategory(String category) {
    settingsInst.categories ??= [];
    if (settingsInst.categories!.contains(category.toLowerCase())) return;

    settingsInst.categories!.add(category);
    refreshSettings();
  }
}
