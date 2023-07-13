import 'dart:async';

import 'package:dumbkey/logic/database_auth.dart';
import 'package:dumbkey/ui/auth_page/auth_page.dart';
import 'package:dumbkey/ui/home.dart';
import 'package:dumbkey/ui/shared/util.dart';
import 'package:firedart/auth/exceptions.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';

class AuthController {
  final auth = GetIt.I.get<DatabaseAuth>();

  static final AuthController inst = AuthController();

  ValueNotifier<bool> isLoading = ValueNotifier(false);

  Future<void> signIn(BuildContext context, String email, String password) async {
    if (isLoading.value) return;

    isLoading.value = true;
    try {
      await auth.signIn(email, password);

      if (!context.mounted) return;
      Navigator.of(context).popUntil((route) => false);
      unawaited(Navigator.of(context).push(MaterialPageRoute(builder: (_) => const HomePage())));

      initDatabaseHandlers();

      displaySnackBar(context, 'Successfully signed up');
    } catch (e) {
      // TODO(signIn): handle different exceptions
      GetIt.I.get<Logger>().e('failed to login $e');
      displaySnackBar(context, 'Failed to login\n$e');
    }
    isLoading.value = false;
  }

  Future<void> signUp(BuildContext context, String email, String password) async {
    if (isLoading.value) return;

    isLoading.value = true;
    try {
      await auth.signUp(email, password);

      if (!context.mounted) return;

      Navigator.of(context).popUntil((route) => false);
      unawaited(Navigator.of(context).push(MaterialPageRoute(builder: (_) => const HomePage())));
      initDatabaseHandlers();

      displaySnackBar(context, 'Successfully signed up');
    } on AuthException catch (e) {
      if (e.message == 'EMAIL_EXISTS') {
        displaySnackBar(context, 'Email already exists try logging in');
      }
      GetIt.I.get<Logger>().e('failed to sign in', e);
    } catch (e) {
      displaySnackBar(context, 'Failed to sign up\n$e');
      GetIt.I.get<Logger>().e('failed to sign in', e);
    }
    isLoading.value = false;
  }

  Future<void> signOut(BuildContext context) async {
    if (isLoading.value) return;

    isLoading.value = true;
    try {
      await auth.signOut();

      if (!context.mounted) return;

      Navigator.of(context).popUntil((route) => false);
      unawaited(Navigator.of(context).push(MaterialPageRoute(builder: (_) => const LoginScreen())));

      removeDatabaseHandlers();

      displaySnackBar(context, 'Successfully signed out');

      isLoading.value = false;
    } catch (e) {
      GetIt.I.get<Logger>().e('failed to sign out', e);
      Navigator.of(context).popUntil((route) => false);
      unawaited(Navigator.of(context).push(MaterialPageRoute(builder: (_) => const LoginScreen())));

      displaySnackBar(context, 'Failed to sign out\n$e');
    }
  }

  void initDatabaseHandlers() {
    GetIt.I.registerSingleton(DatabaseAuth());
  }

  void removeDatabaseHandlers() {
    GetIt.I.unregister<DatabaseAuth>();
  }
}
