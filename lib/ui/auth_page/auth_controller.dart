import 'dart:async';

import 'package:dumbkey/api/auth/database_auth.dart';
import 'package:dumbkey/logic/database_handler.dart';
import 'package:dumbkey/logic/encryption_handler.dart';
import 'package:dumbkey/logic/secure_storage_handler.dart';
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
      await GetIt.I.get<SecureStorageHandler>().writeData(password); // set encryption key
      await initDatabaseHandlers(false);

      if (!context.mounted) return;
      Navigator.of(context).popUntil((route) => false);
      unawaited(Navigator.of(context).push(MaterialPageRoute(builder: (_) => const HomePage())));

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
      await GetIt.I.get<SecureStorageHandler>().writeData(password); // set encryption key
      await initDatabaseHandlers(true);

      if (!context.mounted) return;

      Navigator.of(context).popUntil((route) => false);
      unawaited(Navigator.of(context).push(MaterialPageRoute(builder: (_) => const HomePage())));

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
      await GetIt.I.get<SecureStorageHandler>().writeData(''); // clear ut encryption key
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

  Future<void> initDatabaseHandlers(bool signup) async {
    GetIt.I.registerSingleton<IDataEncryptor>(await SodiumEncryptor.create(signup: signup));
    GetIt.I.registerSingleton<DatabaseHandler>(DatabaseHandler());
  }

  void removeDatabaseHandlers() {
    GetIt.I.unregister<DatabaseHandler>();
    GetIt.I.unregister<IDataEncryptor>();
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
