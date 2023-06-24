import 'package:dumbkey/database/desktop/firestore_desktop.dart';
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
    firestore = DesktopFirestore();
    _listenToChangesFromFireBase();
  }

  late final DesktopFirestore firestore;
  late final Isar database;

  @override
  Future<void> createPassKey(PassKey passkey) async {
    await firestore.createPassKey(passkey);
  }

  @override
  Future<void> deletePassKey(PassKey passkey) async {
    await firestore.deletePassKey(passkey);
    await isarDelete(passkey.docId); // let the fire store complete first
  }

  @override
  Future<void> updatePassKey(String docId, Map<String, dynamic> updateData) async {
    await firestore.updatePassKey(docId, updateData);
  }

  @override
  Stream<List<PassKey>> fetchAllPassKeys() {
    return database.passKeys.where().build().watch(fireImmediately: true);
  }

  void _listenToChangesFromFireBase() {
    firestore.fetchAllPassKeys().listen((documents) async {
      await isarCreateOrUpdate(documents);
    });
  }

  Future<void> isarDelete(int id) async {
    await database.writeTxn(() async {
      await database.passKeys.delete(id);
    });
  }

  Future<void> isarCreateOrUpdate(List<PassKey> passkey) async {
    await database.writeTxn(() async {
      await database.passKeys.putAll(passkey);
    });
  }
}
