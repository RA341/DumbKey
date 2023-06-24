import 'package:dumbkey/database/firestore_stub.dart';
import 'package:dumbkey/model/passkey_model.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

Future<IsarFireStore> initDesktopFirestore() async {
  final dir = await getApplicationDocumentsDirectory();
  final isar = await Isar.open(
    [PassKeySchema],
    directory: dir.path,
  );

  return IsarFireStore(isar: isar);
}

class IsarFireStore implements FireStoreBase {

  IsarFireStore({required Isar isar}){
    database = isar;
  }

  late final Isar database;

  @override
  Future<void> createPassKey(PassKey passkey) {
    // TODO: implement createPassKey
    throw UnimplementedError();
  }

  @override
  Future<void> deletePassKey(PassKey passkey) {
    // TODO: implement deletePassKey
    throw UnimplementedError();
  }

  @override
  Stream<List<PassKey>> fetchAllPassKeys() {
    // TODO: implement fetchAllPassKeys
    throw UnimplementedError();
  }

  @override
  Future<void> updatePassKey(String docId, Map<String, dynamic> updateData) {
    // TODO: implement updatePassKey
    throw UnimplementedError();
  }

}