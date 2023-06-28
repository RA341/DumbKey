import 'dart:math';

import 'package:flutter/material.dart';

int idGenerator({int length = 15}) {
  final rnd = Random();

  var randomNum = 0;
  var multiple = 1;
  for (var x = 1; x < length +1 ; x++) {
   randomNum += rnd.nextInt(9) * multiple;
   multiple *= 10;
  }

  return randomNum;
  //get a number from the list
}

PasswordStrength testPasswordStrength(String password) {
  if (password.length < 8) {
    return PasswordStrength.Weak;
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
    return PasswordStrength.Strong;
  } else if (hasUpperCase && hasLowerCase && hasDigit) {
    return PasswordStrength.Medium;
  } else if (hasUpperCase && hasLowerCase) {
    return PasswordStrength.WeakMedium;
  } else {
    return PasswordStrength.Weak;
  }
}

enum PasswordStrength {
  Weak,
  WeakMedium,
  Medium,
  Strong,
}
