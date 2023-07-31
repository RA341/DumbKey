import 'package:dumbkey/model/type_base_model.dart';
import 'package:dumbkey/utils/constants.dart';
import 'package:isar/isar.dart';

part 'notes_model.g.dart';

@collection
class Notes extends TypeBase {
  const Notes({
    required super.id,
    required super.dataType,
    required super.title,
    required super.dateAdded,
    required super.syncStatus,
    required super.nonce,
    required this.notes,
  });

  factory Notes.fromMap(Map<String, dynamic> map) {
    return Notes(
      id: map[DumbData.id] as int,
      dataType: TypeBase.getDataType(map[DumbData.dataType] as String),
      syncStatus: TypeBase.getSyncStatus(map[DumbData.syncStatus] as String),
      dateAdded: TypeBase.getDateTime(map[DumbData.dateAdded] as String),
      nonce: map[DumbData.nonce] as String,
      title: map[DumbData.title] as String,
      notes: map[DumbData.notes] as String,
    );
  }

  factory Notes.empty() {
    return Notes(
      id: 0,
      dataType: DataType.notes,
      nonce: '',
      title: '',
      dateAdded: DateTime.now(),
      syncStatus: SyncStatus.synced,
      notes: '',
    );
  }

  @override
  Notes copyWith({
    int? id,
    DataType? dataType,
    String? title,
    DateTime? dateAdded,
    SyncStatus? syncStatus,
    String? nonce,
    String? notes,
  }) {
    return Notes(
      id: id ?? this.id,
      dataType: dataType ?? this.dataType,
      title: title ?? this.title,
      dateAdded: dateAdded ?? this.dateAdded,
      syncStatus: syncStatus ?? this.syncStatus,
      nonce: nonce ?? this.nonce,
      notes: notes ?? this.notes,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Notes &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          dataType == other.dataType &&
          title == other.title &&
          dateAdded == other.dateAdded &&
          syncStatus == other.syncStatus &&
          nonce == other.nonce &&
          notes == other.notes;

  @override
  int get hashCode =>
      id.hashCode ^
      dataType.hashCode ^
      title.hashCode ^
      dateAdded.hashCode ^
      syncStatus.hashCode ^
      nonce.hashCode ^
      notes.hashCode;

  @override
  Notes copyWithFromMap(Map<String, dynamic> update) {
    return Notes(
      id: update[DumbData.id] as int? ?? id,
      dataType: update[DumbData.dataType] != null
          ? TypeBase.getDataType(update[DumbData.dataType] as String)
          : dataType,
      nonce: update[DumbData.nonce] as String? ?? nonce,
      syncStatus: update[DumbData.syncStatus] != null
          ? TypeBase.getSyncStatus(update[DumbData.syncStatus] as String)
          : syncStatus,
      dateAdded: update[DumbData.dateAdded] != null
          ? TypeBase.getDateTime(update[DumbData.dateAdded] as String)
          : dateAdded,
      title: update[DumbData.title] as String? ?? title,
      notes: update[DumbData.notes] as String? ?? notes,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final data = super.toJson();
    data[DumbData.notes] = notes;
    return data;
  }

  final String notes;
}
