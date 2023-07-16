import 'package:dumbkey/model/type_base_model.dart';
import 'package:dumbkey/utils/constants.dart';
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
      id: map[DumbData.id] as int,
      dataType: TypeBase.getDataType(map[DumbData.dataType] as String),
      syncStatus: TypeBase.getSyncStatus(map[DumbData.syncStatus] as String),
      dateAdded: TypeBase.getDateTime(map[DumbData.dateAdded] as String),
      title: map[DumbData.title] as String,
      email: map[DumbData.email] as String?,
      username: map[DumbData.username] as String?,
      password: map[DumbData.password] as String?,
      description: map[DumbData.description] as String?,
      category: map[DumbData.category] as String?,
    );
  }

  Password copyWith(Map<String, dynamic> updatedData) {
    return Password(
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
      email: updatedData[DumbData.email] as String? ?? email,
      username: updatedData[DumbData.username] as String? ?? username,
      password: updatedData[DumbData.password] as String? ?? password,
      description: updatedData[DumbData.description] as String? ?? description,
      category: updatedData[DumbData.category] as String? ?? category,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final data = super.toJson();
    data[DumbData.email] = email;
    data[DumbData.username] = username;
    data[DumbData.password] = password;
    data[DumbData.description] = description;
    data[DumbData.category] = category;
    return data;
  }

  String? email;
  String? username;
  String? password;
  String? description;
  String? category;
}
