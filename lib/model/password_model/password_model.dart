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
    required super.nonce,
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
      nonce: map[DumbData.nonce] as String,
      title: map[DumbData.title] as String,
      email: map[DumbData.email] as String?,
      username: map[DumbData.username] as String?,
      password: map[DumbData.password] as String?,
      description: map[DumbData.description] as String?,
      category: map[DumbData.category] as String?,
    );
  }

  factory Password.empty() {
    return Password(
      id: 0,
      dataType: DataType.password,
      nonce: '',
      title: '',
      dateAdded: DateTime.now(),
      syncStatus: SyncStatus.synced,
    );
  }

  @override
  Password copyWith(Map<String, dynamic> update) {
    return Password(
      id: update[DumbData.id] as int? ?? id,
      dataType: update[DumbData.dataType] != null
          ? TypeBase.getDataType(update[DumbData.dataType] as String)
          : dataType,
      syncStatus: update[DumbData.syncStatus] != null
          ? TypeBase.getSyncStatus(update[DumbData.syncStatus] as String)
          : syncStatus,
      dateAdded: update[DumbData.dateAdded] != null
          ? TypeBase.getDateTime(update[DumbData.dateAdded] as String)
          : dateAdded,
      nonce: update[DumbData.nonce] as String? ?? nonce,
      title: update[DumbData.title] as String? ?? title,
      email: update[DumbData.email] as String? ?? email,
      username: update[DumbData.username] as String? ?? username,
      password: update[DumbData.password] as String? ?? password,
      description: update[DumbData.description] as String? ?? description,
      category: update[DumbData.category] as String? ?? category,
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
