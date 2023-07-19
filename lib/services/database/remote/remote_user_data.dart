import 'package:dumbkey/utils/constants.dart';
import 'package:firedart/firedart.dart';

abstract class IRemoteUserDb {
  Future<void> addUserData({required String docId, required Map<String, dynamic> data});

  Future<void> deleteUserData({required String docId});
}

// what data do we need to store for a user?
// user salt
// user document id as uuid

class FirebaseUser implements IRemoteUserDb {
  FirebaseUser() {
    userDb = Firestore.instance;
  }

  late final Firestore userDb;

  CollectionReference get userCollection => userDb.collection(DumbData.userCollection);

  @override
  Future<void> addUserData({required String docId, required Map<String, dynamic> data}) async {
    await userCollection.document(docId).set(data);
  }

  @override
  Future<void> deleteUserData({required String docId}) async {
    await userCollection.document(docId).delete();
  }
}
