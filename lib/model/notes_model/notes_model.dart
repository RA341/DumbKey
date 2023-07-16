import 'package:dumbkey/model/type_base_model.dart';
import 'package:dumbkey/utils/constants.dart';
import 'package:isar/isar.dart';

part 'notes_model.g.dart';

@collection
class Notes extends TypeBase {
  Notes({
    required super.id,
    required super.dataType,
    required super.title,
    required super.dateAdded,
    required super.syncStatus,
    required this.notes,
  });

  factory Notes.fromMap(Map<String, dynamic> map) {
    return Notes(
      id: map[DumbData.id] as int,
      dataType: TypeBase.getDataType(map[DumbData.dataType] as String),
      syncStatus: TypeBase.getSyncStatus(map[DumbData.syncStatus] as String),
      dateAdded: TypeBase.getDateTime(map[DumbData.dateAdded] as String),
      title: map[DumbData.title] as String,
      notes: map[DumbData.notes] as String,
    );
  }

  Notes copyWith(Map<String, dynamic> updatedData) {
    return Notes(
      id: updatedData[DumbData.id] as int? ?? id,
      dataType: updatedData[DumbData.dataType] != null
          ? TypeBase.getDataType(updatedData[DumbData.dataType] as String)
          : dataType,
      syncStatus: updatedData[DumbData.syncStatus] != null
          ? TypeBase.getSyncStatus(updatedData[DumbData.syncStatus] as String)
          : syncStatus,
      dateAdded: updatedData[DumbData.dateAdded] != null
          ? TypeBase.getDateTime(updatedData[DumbData.dateAdded] as String)
          : dateAdded,
      title: updatedData[DumbData.title] as String? ?? title,
      notes: updatedData[DumbData.notes] as String? ?? notes,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final data = super.toJson();
    data[DumbData.notes] = notes;
    return data;
  }

  String notes;
}
