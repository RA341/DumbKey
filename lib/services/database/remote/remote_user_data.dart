import 'package:dumbkey/utils/constants.dart';
import 'package:firedart/firedart.dart';
import 'package:get_it/get_it.dart';

abstract class IRemoteUserDb {
  Future<void> addUserData({required String docId, required Map<String, dynamic> data});

  Future<void> deleteUserData({required String docId});

  Future<Map<String, dynamic>> getUserData({required String docId});
}

// what data do we need to store for a user?
// user salt
// user document id as uuid

class FirebaseUser implements IRemoteUserDb {
  FirebaseUser() {
    userDb = GetIt.I.get<Firestore>();
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

  @override
  Future<Map<String, dynamic>> getUserData({required String docId}) async {
    final data = await userCollection.document(docId).get();
    return data.map;
  }
}
