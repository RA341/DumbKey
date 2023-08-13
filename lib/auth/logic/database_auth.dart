import 'package:firedart/auth/user_gateway.dart';
import 'package:firedart/firedart.dart';

class DatabaseAuth {
  DatabaseAuth() {
    _auth = FirebaseAuth.instance;
  }

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
