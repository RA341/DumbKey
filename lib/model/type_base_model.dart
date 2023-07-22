import 'package:dumbkey/utils/constants.dart';
import 'package:dumbkey/utils/helper_func.dart';
import 'package:isar/isar.dart';

///flutter pub run build_runner build -d
///run this command to generate the files

class TypeBase {
  TypeBase({
    required this.id,
    required this.dataType,
    required this.title,
    required this.dateAdded,
    required this.syncStatus,
    this.nonce = '',
  });

  factory TypeBase.fromMap(Map<String, dynamic> map) {
    return TypeBase(
      nonce: map[DumbData.nonce] as String,
      id: map[DumbData.id] as int,
      dataType: getDataType(map[DumbData.dataType] as String),
      syncStatus: getSyncStatus(map[DumbData.syncStatus] as String),
      title: map[DumbData.title] as String,
      dateAdded: getDateTime(map[DumbData.dateAdded] as String),
    );
  }

  static DateTime getDateTime(String isoString) => DateTime.parse(isoString);

  static DataType getDataType(String dataIndex) => DataType.values[int.parse(dataIndex)];

  static SyncStatus getSyncStatus(String dataIndex) => SyncStatus.values[int.parse(dataIndex)];

  Map<String, dynamic> toJson() => {
        DumbData.id: id,
        DumbData.dataType: dataType.index.toString(),
        DumbData.syncStatus: syncStatus.index.toString(),
        DumbData.title: title,
        DumbData.nonce: nonce,
        DumbData.dateAdded: dateAdded.toIso8601String(),
      };

  TypeBase copyWith(Map<String, dynamic> update) {
    return TypeBase(
      id: (update[DumbData.id] as int?) ?? id,
      dataType: update[DumbData.dataType] == null
          ? getDataType(update[DumbData.dataType]! as String)
          : dataType,
      syncStatus: update[DumbData.syncStatus] == null
          ? getSyncStatus(update[DumbData.syncStatus]! as String)
          : syncStatus,
      dateAdded: update[DumbData.dateAdded] == null
          ? getDateTime(update[DumbData.dateAdded]! as String)
          : dateAdded,
      nonce: update[DumbData.nonce] as String? ?? nonce,
      title: (update[DumbData.title] as String?) ?? title,
    );
  }

  static Map<String, dynamic> defaultMap(DataType type) {
    final data = <String, dynamic>{};
    data[DumbData.id] = idGenerator();
    data[DumbData.dataType] = type.index.toString();
    data[DumbData.syncStatus] = SyncStatus.synced.index.toString();
    data[DumbData.dateAdded] = DateTime.now().toIso8601String();
    data[DumbData.nonce] = '';
    return data;
  }

  Map<String, dynamic> defaultUpdateMap() {
    final data = <String, dynamic>{};
    data[DumbData.id] = id;
    data[DumbData.nonce] = nonce;
    data[DumbData.dataType] = dataType.index.toString();
    data[DumbData.syncStatus] = null;
    data[DumbData.dateAdded] = null;
    return data;
  }

  Id id;
  @enumerated
  DataType dataType;
  @enumerated
  SyncStatus syncStatus;
  String title;
  DateTime dateAdded;
  String nonce;
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
