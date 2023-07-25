import 'package:dumbkey/services/auth/isar_auth_store.dart';
import 'package:dumbkey/utils/constants.dart';
import 'package:firedart/firedart.dart';
import 'package:firedart/firestore/token_authenticator.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';

// reference:
// Firestore(
// projectId,
// databaseId: databaseId,
// authenticator: authenticator,
// emulator: emulator,
// );
// Firestore.initialize(projId);

void initFirebaseServices() {
  initFireAuth();
  initFireStore();
}

void initFireStore() {
  // we manually initialize firestore because we can log in or out
  // this causes the firestore instance to be re-initialized with the new user
  final projId = dotenv.get(
    DumbData.firebaseProjID,
    fallback: DumbData.noKey,
  );
  if (projId == DumbData.noKey) throw Exception('Firebase project ID not found in .env file');

  final authenticator = TokenAuthenticator.from(FirebaseAuth.instance)?.authenticate;
  final inst = Firestore(projId, authenticator: authenticator);

  GetIt.I.registerSingleton<Firestore>(inst);
}

void initFireAuth() {
  final apiKey = dotenv.get(
    DumbData.firebaseApiKey,
    fallback: DumbData.noKey,
  );
  if (apiKey == DumbData.noKey) throw Exception('No Firebase API key found');

  FirebaseAuth.initialize(apiKey, AuthLocalStore());
}
