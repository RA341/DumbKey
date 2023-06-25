import 'package:isar/isar.dart';

part 'settings.g.dart';

@collection
class Settings {
  Id? id;

  // backup
  String? backupPath;
  String? backupFileName;
  DateTime? lastBackupDate;


  // offline_queue
  List<int>? offlineQueue; //store ids of passkeys
}
