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
    required super.dataAdded,
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
      dataType: DataType.values[map[KeyNames.dataType] as int],
      syncStatus: SyncStatus.values[map[KeyNames.syncStatus] as int],
      title: map[KeyNames.title] as String,
      dataAdded: DateTime.parse(map[KeyNames.dataAdded] as String),
      email: map[KeyNames.email] as String?,
      username: map[KeyNames.username] as String?,
      password: map[KeyNames.password] as String?,
      description: map[KeyNames.description] as String?,
      category: map[KeyNames.category] as String?,
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
