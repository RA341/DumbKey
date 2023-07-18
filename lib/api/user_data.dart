import 'package:dumbkey/utils/constants.dart';
import 'package:firedart/firedart.dart';

abstract class IRemoteUserDb {
  Future<void> addUserData(UserData userData);

  Future<void> deleteUserData(UserData userData);

  Future<void> updateUserData(UserData userData);
}

// what data do we need to store for a user?
// user salt
// user document id as uuid

class UserData {
  UserData({required this.salt, required this.uuid});

  factory UserData.fromMap(Map<String, dynamic> map) {
    return UserData(
      salt: map[DumbData.salt] as String,
      uuid: map[DumbData.uuid] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      DumbData.salt: salt,
      DumbData.uuid: uuid,
    };
  }

  String uuid;
  String salt;
}

class FirebaseUser implements IRemoteUserDb {
  FirebaseUser() {
    userDb = Firestore.instance;
  }

  late final Firestore userDb;

  CollectionReference get userCollection => userDb.collection(DumbData.userCollection);

  @override
  Future<void> addUserData(UserData userData) async {
    await userCollection.document(userData.uuid).create(userData.toMap());
  }

  @override
  Future<void> deleteUserData(UserData userData) async {
    await userCollection.document(userData.uuid).delete();
  }

  @override
  Future<void> updateUserData(UserData userData) async {
    await userCollection.document(userData.uuid).update(userData.toMap());
  }
}
