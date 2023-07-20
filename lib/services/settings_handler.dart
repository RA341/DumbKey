import 'package:dumbkey/model/settings_model/settings.dart';
import 'package:dumbkey/utils/logger.dart';
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
      config = Settings(id: 0);
      await isar.writeTxn(() async => await isar.settings.put(config!));
    }

    return SettingsHandler._create(isar: isar, setInst: config);
  }

  Future<void> refreshSettings() async {
    await isarInst.writeTxn(() async {
      await isarInst.settings.put(settingsInst);
    });

    settingsInst = (await isarInst.settings.get(0))!;

    // settingsInst = tmp!;
    logger.i('New settings', settingsInst.idToken.toString());
  }

  Future<void> addCategory(String category) async {
    settingsInst.categories ??= [];
    if (settingsInst.categories!.contains(category.toLowerCase())) return;

    settingsInst.categories!.add(category);
    await refreshSettings();
  }
}
