import 'dart:async';

import 'package:dumbkey/model/card_details_model/card_details_model.dart';
import 'package:dumbkey/model/notes_model/notes_model.dart';
import 'package:dumbkey/model/password_model/password_model.dart';
import 'package:dumbkey/services/auth/database_auth.dart';
import 'package:dumbkey/services/database/database_handler.dart';
import 'package:dumbkey/services/database/local/secure_storage_handler.dart';
import 'package:dumbkey/services/database/user_data_handler.dart';
import 'package:dumbkey/services/encryption_handler.dart';
import 'package:dumbkey/services/settings_handler.dart';
import 'package:dumbkey/ui/auth_page/auth_page.dart';
import 'package:dumbkey/ui/home.dart';
import 'package:dumbkey/ui/shared/util.dart';
import 'package:dumbkey/utils/constants.dart';
import 'package:dumbkey/utils/logger.dart';
import 'package:firedart/auth/exceptions.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:isar/isar.dart';

/// functions to handle cleanup on error or sign-out
Future<void> cleanUpOnSignOut() async {
  await GetIt.I.get<SecureStorageHandler>().deleteData(key: DumbData.salt);
  await GetIt.I.get<SecureStorageHandler>().deleteData(key: DumbData.encryptionKey);
  GetIt.I.get<SettingsHandler>().clearSettings();
  removeDatabaseHandlers();
  await deleteLocalCache();
}

Future<void> initDatabaseHandlers({required bool signup}) async {
  if (GetIt.I.isRegistered<UserDataHandler>() == false) {
    GetIt.I.registerSingleton(UserDataHandler());
  }
  if (signup == false) await GetIt.I.get<UserDataHandler>().retrieveDataFromRemote();

  if (GetIt.I.isRegistered<IDataEncryptor>() == false) {
    GetIt.I.registerSingleton<IDataEncryptor>(await SodiumEncryptor.create(signup: signup));
  }

  if (GetIt.I.isRegistered<DatabaseHandler>() == false) {
    GetIt.I.registerSingleton<DatabaseHandler>(DatabaseHandler());
  }
}

void removeDatabaseHandlers() {
  if (GetIt.I.isRegistered<UserDataHandler>()) GetIt.I.unregister<UserDataHandler>();
  if (GetIt.I.isRegistered<IDataEncryptor>()) GetIt.I.unregister<IDataEncryptor>();
  if (GetIt.I.isRegistered<DatabaseHandler>()) GetIt.I.unregister<DatabaseHandler>();
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

class AuthController {
  final auth = GetIt.I.get<DatabaseAuth>();

  static final AuthController inst = AuthController();

  ValueNotifier<bool> isLoading = ValueNotifier(false);

  Future<void> signIn(BuildContext context, String email, String password) async {
    if (isLoading.value) return;

    isLoading.value = true;
    try {
      GetIt.I.get<SettingsHandler>().clearSettings();
      await auth.signIn(email, password);
      await GetIt.I
          .get<SecureStorageHandler>()
          .writeData(key: DumbData.encryptionKey, value: password); // set encryption key

      await initDatabaseHandlers(signup: false);

      if (!context.mounted) return;
      Navigator.of(context).popUntil((route) => false);
      unawaited(Navigator.of(context).push(MaterialPageRoute(builder: (_) => const HomePage())));

      displaySnackBar(context, 'Successfully signed in');
    } catch (e) {
      // TODO(signIn): handle different exceptions
      logger.e('failed to login $e');
      displaySnackBar(context, 'Failed to login\n$e');
      await cleanUpOnSignOut();
      await auth.signOut();
    }
    isLoading.value = false;
  }

  Future<void> signUp(BuildContext context, String email, String password) async {
    if (isLoading.value) return;

    isLoading.value = true;
    try {
      await auth.signUp(email, password);
      await GetIt.I
          .get<SecureStorageHandler>()
          .writeData(key: DumbData.encryptionKey, value: password); // set encryption key
      await initDatabaseHandlers(signup: true);

      if (!context.mounted) return;

      Navigator.of(context).popUntil((route) => false);
      unawaited(Navigator.of(context).push(MaterialPageRoute(builder: (_) => const HomePage())));

      displaySnackBar(context, 'Successfully signed up');
    } on AuthException catch (e) {
      if (e.message == 'EMAIL_EXISTS') {
        displaySnackBar(context, 'Email already exists try logging in');
      }
      logger.e('failed to sign in', e);
    } catch (e) {
      displaySnackBar(context, 'Failed to sign up\n$e');
      logger.e('failed to sign in', e);
      await auth.signOut();
      await cleanUpOnSignOut();
    }
    isLoading.value = false;
  }

  Future<void> signOut(BuildContext context) async {
    if (isLoading.value) return;

    isLoading.value = true;
    try {
      await auth.signOut();
      await cleanUpOnSignOut();
      if (!context.mounted) return;

      displaySnackBar(context, 'Successfully signed out');
    } catch (e) {
      logger.e('failed to sign out', e);
      displaySnackBar(context, 'Failed to sign out\n$e');
    } finally {
      isLoading.value = false;
      Navigator.of(context).popUntil((route) => false);
      unawaited(Navigator.of(context).push(MaterialPageRoute(builder: (_) => const LoginScreen())));
    }
  }
}
