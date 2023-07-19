import 'dart:math';

import 'package:dumbkey/services/database/database_handler.dart';
import 'package:dumbkey/services/database/user_data_handler.dart';
import 'package:dumbkey/services/encryption_handler.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

int idGenerator({int length = 15}) {
  final rnd = Random();

  var randomNum = 0;
  var multiple = 1;
  for (var x = 1; x < length + 1; x++) {
    randomNum += rnd.nextInt(9) * multiple;
    multiple *= 10;
  }

  return randomNum;
  //get a number from the list
}

PasswordStrength testPasswordStrength(String password) {
  if (password.length < 8) {
    return PasswordStrength.weak;
  }

  var hasUpperCase = false;
  var hasLowerCase = false;
  var hasDigit = false;
  var hasSpecialChar = false;

  for (final char in password.characters) {
    if (char.contains(RegExp(r'[A-Z]'))) {
      hasUpperCase = true;
    } else if (char.contains(RegExp(r'[a-z]'))) {
      hasLowerCase = true;
    } else if (char.contains(RegExp(r'[0-9]'))) {
      hasDigit = true;
    } else if (char.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      hasSpecialChar = true;
    }
  }

  if (hasUpperCase && hasLowerCase && hasDigit && hasSpecialChar) {
    return PasswordStrength.strong;
  } else if (hasUpperCase && hasLowerCase && hasDigit) {
    return PasswordStrength.medium;
  } else if (hasUpperCase && hasLowerCase) {
    return PasswordStrength.weakMedium;
  } else {
    return PasswordStrength.weak;
  }
}

enum PasswordStrength {
  weak,
  weakMedium,
  medium,
  strong,
}

Future<void> initDatabaseHandlers({required bool signup}) async {
  GetIt.I
    ..registerSingleton<IDataEncryptor>(await SodiumEncryptor.create(signup: signup))
    ..registerSingleton<DatabaseHandler>(DatabaseHandler())
    ..registerSingleton(UserDataHandler());
}

void removeDatabaseHandlers() {
  GetIt.I
    ..unregister<UserDataHandler>()
    ..unregister<DatabaseHandler>()
    ..unregister<IDataEncryptor>();
}
