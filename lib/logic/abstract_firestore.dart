import 'package:dumbkey/utils/passkey_model.dart';

abstract class FireStoreBase {
  Future<void> createPassKey(PassKey passkey);
  Future<void> deletePassKey(PassKey passkey);
  Future<void> updatePassKey(String docId,Map<String,dynamic> updateData);
  Stream<List<PassKey>> fetchAllPassKeys();
}