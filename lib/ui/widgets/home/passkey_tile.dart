import 'package:dumbkey/utils/passkey_model.dart';
import 'package:flutter/material.dart';

class PasskeyTitle extends StatelessWidget {
  const PasskeyTitle({required this.passkey, super.key});

  final PassKey passkey;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(passkey.passKey),
    );
  }
}