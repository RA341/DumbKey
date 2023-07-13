import 'dart:async';

import 'package:dumbkey/logic/database_auth.dart';
import 'package:dumbkey/model/card_details_model/card_details_model.dart';
import 'package:dumbkey/model/notes_model/notes_model.dart';
import 'package:dumbkey/model/password_model/password_model.dart';
import 'package:dumbkey/ui/auth_page/auth_page.dart';
import 'package:dumbkey/ui/home.dart';
import 'package:dumbkey/ui/shared/util.dart';
import 'package:firedart/auth/exceptions.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:isar/isar.dart';
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

      removeDatabaseHandlers();
      await deleteLocalCache();

      if (!context.mounted) return;

      Navigator.of(context).popUntil((route) => false);
      unawaited(Navigator.of(context).push(MaterialPageRoute(builder: (_) => const LoginScreen())));
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

  Future<void> deleteLocalCache() async {
    final isar = GetIt.I.get<Isar>();

    final passwordList = await isar.passwords.where().build().findAll();
    final cardsList = await isar.cardDetails.where().build().findAll();
    final notesList = await isar.notes.where().build().findAll();

    if (notesList.isNotEmpty) {
      await isar.writeTxn(() async {
        await isar.notes.deleteAll(notesList.map((e) => e.id).toList());
      });
    }

    if (passwordList.isNotEmpty) {
      await isar.writeTxn(() async {
        await isar.passwords.deleteAll(passwordList.map((e) => e.id).toList());
      });
    }

    if (cardsList.isNotEmpty) {
      await isar.writeTxn(() async {
        await isar.cardDetails.deleteAll(cardsList.map((e) => e.id).toList());
      });
    }
  }
}
