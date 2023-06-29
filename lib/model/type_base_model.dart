import 'package:dumbkey/utils/key_name_constants.dart';
import 'package:isar/isar.dart';

class TypeBase {
  TypeBase({
    required this.id,
    required this.dataType,
    required this.title,
    required this.dataAdded,
    required this.syncStatus,
  });

  factory TypeBase.fromMap(Map<String, dynamic> map) {
    return TypeBase(
      id: map[KeyNames.id] as int,
      dataType: DataType.values[map[KeyNames.dataType] as int],
      syncStatus: SyncStatus.values[map[KeyNames.syncStatus] as int],
      title: map[KeyNames.title] as String,
      dataAdded: DateTime.parse(map[KeyNames.dataAdded] as String),
    );
  }

  Map<String, dynamic> toJson() => {
        KeyNames.id: id,
        KeyNames.dataType: dataType.index,
        KeyNames.syncStatus: syncStatus.index,
        KeyNames.title: title,
        KeyNames.dataAdded: dataAdded.toIso8601String(),
      };

  Id id;
  @enumerated
  DataType dataType;
  @enumerated
  SyncStatus syncStatus;
  String title;
  DateTime dataAdded;
}

enum DataType {
  card,
  password,
  notes,
}

enum SyncStatus {
  notSynced,
  synced,
  deleted,
}
