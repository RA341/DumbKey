import 'package:dumbkey/model/settings.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class SettingsHandler{

  SettingsHandler._create({required Isar settings}){
    settingsDb = settings;
  }

  late final Isar settingsDb;

  static Future<SettingsHandler> initSettings() async {
    final dir = await getApplicationDocumentsDirectory();
    final isar = await Isar.open(
      [SettingsSchema],
      directory: dir.path,
    );
    return SettingsHandler._create(settings: isar);
  }


  void addToOffline(int id){
    
  }
}