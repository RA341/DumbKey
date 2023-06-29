import 'package:dumbkey/model/type_base_model.dart';
import 'package:dumbkey/utils/key_name_constants.dart';
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
      id: map[KeyNames.id] as int,
      dataType: TypeBase.getDataType(map[KeyNames.dataType] as String),
      syncStatus: TypeBase.getSyncStatus(map[KeyNames.syncStatus] as String),
      dateAdded: TypeBase.getDateTime(map[KeyNames.dateAdded] as String),
      title: map[KeyNames.title] as String,
      notes: map[KeyNames.notes] as String,
    );
  }

  String notes;
}
