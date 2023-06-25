import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dumbkey/database/firestore_stub.dart';
import 'package:dumbkey/database/mobile/firestore_native.dart';
import 'package:dumbkey/model/passkey_model.dart';
import 'package:dumbkey/utils/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:isar/isar.dart';

/// used this way because async constructors are not allowed
/// we initialize firebase here as it
/// removes dependency from main helps in tree shaking
Future<MobileFireStore> initMobileFirestore(Isar isar) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseFirestore.instance.settings = const Settings(persistenceEnabled: false);
  return MobileFireStore(isar);
}

class MobileFireStore extends FireStoreBase {
  MobileFireStore(super.isar) {
    firestore = FireStoreNative();
    _listenToFireBaseChanges();
  }

  late final FireStoreNative firestore;

  @override
  Future<void> createPassKey(PassKey passkey) async {
    await firestore.createPassKey(passkey);
    await isarCreateOrUpdate(passkey);
  }

  @override
  Future<void> deletePassKey(PassKey passkey) async {
    await firestore.deletePassKey(passkey);
    await isarDelete(passkey.docId); // let the fire store complete first
  }

  @override
  Future<void> updatePassKey(String docId, Map<String, dynamic> updateData) async {
    assert(
      updateData.containsKey('docId'),
      'update data does not contain ID,$updateData',
    );
    assert(
      updateData.containsValue(null),
      'update data contains null,$updateData',
    );

    await isarCreateOrUpdate(PassKey.fromJson(updateData));
    await firestore.updatePassKey(docId, updateData);
  }

  @override
  Stream<List<PassKey>> fetchAllPassKeys() {
    return isarDb.passKeys.where().build().watch(fireImmediately: true);
  }

  void _listenToFireBaseChanges() {
    firestore.fetchAllPassKeys().listen((passkeys) async {
      await isarCreateOrUpdateAll(passkeys);
    });
  }
}
