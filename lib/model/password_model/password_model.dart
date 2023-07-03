import 'package:dumbkey/model/type_base_model.dart';
import 'package:dumbkey/utils/key_name_constants.dart';
import 'package:isar/isar.dart';

part 'password_model.g.dart';

@collection
class Password extends TypeBase {
  Password({
    required super.id,
    required super.dataType,
    required super.title,
    required super.dateAdded,
    required super.syncStatus,
    this.email,
    this.username,
    this.password,
    this.description,
    this.category,
  });

  factory Password.fromMap(Map<String, dynamic> map) {
    return Password(
      id: map[KeyNames.id] as int,
      dataType: TypeBase.getDataType(map[KeyNames.dataType] as String),
      syncStatus: TypeBase.getSyncStatus(map[KeyNames.syncStatus] as String),
      dateAdded: TypeBase.getDateTime(map[KeyNames.dateAdded] as String),
      title: map[KeyNames.title] as String,
      email: map[KeyNames.email] as String?,
      username: map[KeyNames.username] as String?,
      password: map[KeyNames.password] as String?,
      description: map[KeyNames.description] as String?,
      category: map[KeyNames.category] as String?,
    );
  }

  Password copyWith(Map<String, dynamic> updatedData) {
    return Password(
      id: updatedData[KeyNames.id] as int? ?? id,
      dataType: updatedData[KeyNames.dataType] != null
          ? TypeBase.getDataType(updatedData[KeyNames.dataType] as String)
          : dataType,
      syncStatus: updatedData[KeyNames.syncStatus] != null
          ? TypeBase.getSyncStatus(updatedData[KeyNames.syncStatus] as String)
          : syncStatus,
      dateAdded: updatedData[KeyNames.dateAdded] != null
          ? TypeBase.getDateTime(updatedData[KeyNames.dateAdded] as String)
          : dateAdded,
      title: updatedData[KeyNames.title] as String? ?? title,
      email: updatedData[KeyNames.email] as String? ?? email,
      username: updatedData[KeyNames.username] as String? ?? username,
      password: updatedData[KeyNames.password] as String? ?? password,
      description: updatedData[KeyNames.description] as String? ?? description,
      category: updatedData[KeyNames.category] as String? ?? category,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final data = super.toJson();
    data[KeyNames.email] = email;
    data[KeyNames.username] = username;
    data[KeyNames.password] = password;
    data[KeyNames.description] = description;
    data[KeyNames.category] = category;
    return data;
  }

  String? email;
  String? username;
  String? password;
  String? description;
  String? category;
}
