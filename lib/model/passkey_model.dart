import 'package:dumbkey/utils/constants.dart';
import 'package:isar/isar.dart';

/// Used to store/retrieve passkey data from firebase
@collection
class PassKey {
  /// constructor
  PassKey({
    required this.docId,
    required this.passKey,
    this.org = 'any',
    this.email,
    this.username,
    this.description,
  });

  factory PassKey.fromJson(Map<String, dynamic> json) => PassKey(
        passKey: json[Constants.passKey] as String,
        org: json[Constants.org] as String,
        description: json[Constants.description] as String?,
        email: json[Constants.email] as String?,
        username: json[Constants.username] as String?,
        docId: json[Constants.docId] as String,
      );

  Map<String, dynamic> toJSON() {
    final m = <String, dynamic>{};
    m[Constants.email] = email;
    m[Constants.org] = org;
    m[Constants.username] = username;
    m[Constants.passKey] = passKey;
    m[Constants.description] = description;
    m[Constants.docId] = docId;
    return m;
  }

  void crypt(String Function(String data) cryptFunc) {
    this
      ..passKey = cryptFunc(passKey)
      ..org = cryptFunc(org)
      ..email = email != null ? cryptFunc(email!) : null
      ..username = username != null ? cryptFunc(username!) : null
      ..description = description != null ? cryptFunc(description!) : null;
  }

  // Id? id = docId;
  String docId;
  String org;
  String passKey;
  String? email;
  String? username;
  String? description;
}
