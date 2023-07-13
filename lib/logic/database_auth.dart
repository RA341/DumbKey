import 'package:dumbkey/logic/isar_auth_store.dart';
import 'package:dumbkey/utils/constants.dart';
import 'package:firedart/auth/user_gateway.dart';
import 'package:firedart/firedart.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class DatabaseAuth {
  DatabaseAuth() {
    final apiKey = dotenv.get(Constants.firebaseApiKey, fallback: Constants.noKey);

    if (apiKey == Constants.noKey) throw Exception('No API key found');

    _tokenStore = IsarStore();
    _auth = FirebaseAuth(apiKey, _tokenStore);
  }

  late final IsarStore _tokenStore;
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
