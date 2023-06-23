/// Used to store/retrieve passkey data from firebase
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
        passKey: json['passKey']! as String,
        org: json['org']! as String,
        description: json['description'] as String?,
        email: json['email'] as String?,
        username: json['username'] as String?,
        docId: json['docId'] as String,
      );

  Map<String, dynamic> toJSON() {
    final m = <String, dynamic>{};
    m['email'] = email;
    m['org'] = org;
    m['username'] = username;
    m['passKey'] = passKey;
    m['description'] = description;
    m['docId'] = docId;
    return m;
  }

  String docId;
  String org;
  String? email;
  String? username;
  String passKey;
  String? description;
}
