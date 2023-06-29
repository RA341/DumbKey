import 'package:isar/isar.dart';

part 'settings.g.dart';

@collection
class Settings {

  Settings({
    this.id,
    this.backupPath,
    this.backupFileName,
    this.lastBackupDate,
    this.categories,
  });

  Id? id;

  // backup
  String? backupPath;
  String? backupFileName;
  DateTime? lastBackupDate;


  // offline_queue
  List<String>? categories; //store ids of passkeys
}
