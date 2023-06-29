import 'package:dumbkey/utils/key_name_constants.dart';
import 'package:isar/isar.dart';

class TypeBase {
  TypeBase({
    required this.id,
    required this.dataType,
    required this.title,
    required this.dateAdded,
    required this.syncStatus,
  });

  factory TypeBase.fromMap(Map<String, dynamic> map) {
    return TypeBase(
      id: map[KeyNames.id] as int,
      dataType: getDataType(map[KeyNames.dataType] as String),
      syncStatus: getSyncStatus(map[KeyNames.syncStatus] as String),
      title: map[KeyNames.title] as String,
      dateAdded: getDateTime(map[KeyNames.dateAdded] as String),
    );
  }

  static DateTime getDateTime(String isoString) => DateTime.parse(isoString);

  static DataType getDataType(String dataIndex) => DataType.values[int.parse(dataIndex)];

  static SyncStatus getSyncStatus(String dataIndex) => SyncStatus.values[int.parse(dataIndex)];

  Map<String, dynamic> toJson() => {
        KeyNames.id: id,
        KeyNames.dataType: dataType.index.toString(),
        KeyNames.syncStatus: syncStatus.index.toString(),
        KeyNames.title: title,
        KeyNames.dateAdded: dateAdded.toIso8601String(),
      };

  Id id;
  @enumerated
  DataType dataType;
  @enumerated
  SyncStatus syncStatus;
  String title;
  DateTime dateAdded;
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
