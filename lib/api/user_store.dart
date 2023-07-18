import 'package:firedart/firedart.dart';

abstract class IRemoteUserDb {
  Future<void> createUser(String username, String password);

  Future<void> deleteUser(String username);

  Future<void> updateUser(String username, String password);
}

class FirebaseUser implements IRemoteUserDb {

  FirebaseUser() {
    userDb = Firestore.instance;
  }

  late final Firestore userDb;
  

  @override
  Future<void> createUser(String username, String password) {
    // TODO: implement createUser
    throw UnimplementedError();
  }

  @override
  Future<void> deleteUser(String username) {
    // TODO: implement deleteUser
    throw UnimplementedError();
  }

  @override
  Future<void> updateUser(String username, String password) {
    // TODO: implement updateUser
    throw UnimplementedError();
  }

}
