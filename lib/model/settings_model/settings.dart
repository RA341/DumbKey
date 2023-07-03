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
    this.userId,
    this.idToken,
    this.refreshToken,
    this.expiry,
  });

  Id? id;

  // backup
  String? backupPath;
  String? backupFileName;
  DateTime? lastBackupDate;

  // auth
  String? userId;
  String? idToken;
  String? refreshToken;
  String? expiry;

  // offline_queue
  List<String>? categories; //store ids of passkeys
}
