import 'package:dumbkey/services/auth/isar_auth_store.dart';
import 'package:dumbkey/utils/constants.dart';
import 'package:firedart/auth/user_gateway.dart';
import 'package:firedart/firedart.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class DatabaseAuth {
  DatabaseAuth() {
    final apiKey = dotenv.get(DumbData.firebaseApiKey, fallback: DumbData.noKey);

    if (apiKey == DumbData.noKey) throw Exception('No API key found');

    _tokenStore = AuthLocalStore();
    _auth = FirebaseAuth(apiKey, _tokenStore);
  }

  late final AuthLocalStore _tokenStore;
  late final FirebaseAuth _auth;

  Future<void> signIn(String email, String password) async {
    await _auth.signIn(email, password);
  }

  Future<void> signUp(String email, String password) async {
    await _auth.signUp(email, password);
  }

  Future<void> signOut() async {
    _auth.signOut();
  }

  Future<void> deleteAccount() async {
    await _auth.deleteAccount();
  }

  Future<User> getUser() async {
    final user = await _auth.getUser();
    return user;
  }

  bool get isSignedIn => _auth.isSignedIn;

  String get userId => _auth.userId;
}
