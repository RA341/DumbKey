import 'dart:async';

import 'package:dumbkey/auth/logic/database_auth.dart';
import 'package:dumbkey/auth/ui/mobile/auth_page.dart';
import 'package:dumbkey/home/logic/database/database_handler.dart';
import 'package:dumbkey/home/logic/database/local/secure_storage_handler.dart';
import 'package:dumbkey/home/logic/database/user_data_handler.dart';
import 'package:dumbkey/home/ui/home.dart';
import 'package:dumbkey/model/card_details_model/card_details_model.dart';
import 'package:dumbkey/model/notes_model/notes_model.dart';
import 'package:dumbkey/model/password_model/password_model.dart';
import 'package:dumbkey/services/encryption_handler.dart';
import 'package:dumbkey/services/firebase.dart';
import 'package:dumbkey/settings/logic/settings_handler.dart';
import 'package:dumbkey/utils/constants.dart';
import 'package:dumbkey/utils/helper_func.dart';
import 'package:dumbkey/utils/logger.dart';
import 'package:dumbkey/utils/widgets/util.dart';
import 'package:firedart/auth/exceptions.dart';
import 'package:firedart/firedart.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';

/// functions to handle cleanup on error or sign-out
Future<void> cleanUpOnSignOut() async {
  await dep.get<SecureStorageHandler>().deleteData(key: DumbData.salt);
  await dep.get<SecureStorageHandler>().deleteData(key: DumbData.encryptionKey);
  dep.get<SettingsHandler>().clearSettings();
  removeDatabaseHandlers();
  await deleteLocalCache();
}

Future<void> initDatabaseHandlers({required bool signup}) async {
  if (dep.isRegistered<Firestore>() == false) {
    initFireStore();
  }

  if (dep.isRegistered<UserDataHandler>() == false) {
    dep.registerSingleton(UserDataHandler());
  }
  if (signup == false) await dep.get<UserDataHandler>().syncUserData();

  if (dep.isRegistered<IDataEncryptor>() == false) {
    dep.registerSingleton<IDataEncryptor>(await SodiumEncryptor.create(signup: signup));
  }

  if (dep.isRegistered<DatabaseHandler>() == false) {
    dep.registerSingleton<DatabaseHandler>(DatabaseHandler());
  }
}

void removeDatabaseHandlers() {
  if (dep.isRegistered<UserDataHandler>()) dep.unregister<UserDataHandler>();
  if (dep.isRegistered<IDataEncryptor>()) dep.unregister<IDataEncryptor>();
  if (dep.isRegistered<DatabaseHandler>()) {
    dep.unregister<DatabaseHandler>(disposingFunction: (db) => db.dispose());
  }
  if (dep.isRegistered<Firestore>()) dep.unregister<Firestore>();
}

Future<void> deleteLocalCache() async {
  final isar = dep.get<Isar>();

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
  final auth = dep.get<DatabaseAuth>();

  static final AuthController inst = AuthController();

  ValueNotifier<bool> isLoading = ValueNotifier(false);

  Future<void> signIn(BuildContext context, String email, String password) async {
    if (isLoading.value) return;

    isLoading.value = true;
    try {
      dep.get<SettingsHandler>().clearSettings();
      await auth.signIn(email, password);
      await dep
          .get<SecureStorageHandler>()
          .writeData(key: DumbData.encryptionKey, value: password); // set encryption key

      await initDatabaseHandlers(signup: false);

      if (!context.mounted) return;
      // Navigator.of(context).popUntil((route) => false);
      unawaited(
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => const HomePage(),
          ),
        ),
      );

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
      await dep
          .get<SecureStorageHandler>()
          .writeData(key: DumbData.encryptionKey, value: password); // set encryption key
      await initDatabaseHandlers(signup: true);

      if (!context.mounted) return;

      unawaited(
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => const HomePage(),
          ),
        ),
      );

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
      unawaited(
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (_) => const LoginScreen(),
          ),
          (route) => false,
        ),
      );
    }
  }
}
