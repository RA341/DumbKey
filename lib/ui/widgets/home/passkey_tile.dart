import 'package:dumbkey/ui/form_input.dart';
import 'package:dumbkey/utils/passkey_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PasskeyTitle extends StatelessWidget {
  const PasskeyTitle({
    required this.passkey,
    required this.updateKeyFunc,
    required this.deleteKeyFunc,
    super.key,
  });

  final Future<void> Function(PassKey) updateKeyFunc;
  final Future<void> Function(PassKey) deleteKeyFunc;

  final PassKey passkey;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: InkWell(
        onLongPress: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailsInputScreen(
              addOrUpdateKeyFunc: updateKeyFunc,
              savedKey: passkey,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            copyButton(context, isUserName: true),
            Padding(
              padding: const EdgeInsets.all(5),
              child: Text(passkey.username ?? passkey.email ?? passkey.org),
            ),
            copyButton(context, isUserName: false),
          ],
        ),
      ),
    );
  }

  Widget copyButton(BuildContext ctx, {required bool isUserName}) {
    return IconButton(
      tooltip: isUserName ? 'Copy username' : 'Copy password',
      icon: isUserName ? const Icon(Icons.person) : const Icon(Icons.password),
      onPressed: () {
        Clipboard.setData(
          ClipboardData(
            text: isUserName ? (passkey.username ?? passkey.email ?? '') : passkey.passKey,
          ),
        );
        ScaffoldMessenger.of(ctx).showSnackBar(
          SnackBar(
            content: Text(
              isUserName ? 'Username copied' : 'Password copied',
            ),
          ),
        );
      },
    );
  }
}
