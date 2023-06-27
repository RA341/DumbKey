// ignore_for_file: inference_failure_on_instance_creation

import 'package:dumbkey/database/database_handler.dart';
import 'package:dumbkey/model/passkey_model.dart';
import 'package:dumbkey/ui/details/details_screen.dart';
import 'package:dumbkey/ui/form/form_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';

class PasskeyTitle extends StatelessWidget {
  const PasskeyTitle({
    required this.passkey,
    super.key,
  });

  final PassKey passkey;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Dismissible(
        key: ValueKey(passkey.docId),
        background: const ColoredBox(
          color: Colors.red,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 16),
              child: Icon(
                Icons.delete,
                color: Colors.white,
              ),
            ),
          ),
        ),
        secondaryBackground: const ColoredBox(
          color: Colors.blue,
          child: Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: EdgeInsets.only(right: 16),
              child: Icon(
                Icons.archive,
                color: Colors.white,
              ),
            ),
          ),
        ),
        onDismissed: (direction) async =>
            await GetIt.I.get<DatabaseHandler>().deletePassKey(passkey),
        confirmDismiss: (direction) => showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Are you sure?'),
            content: const Text(
              'This will permanently delete the passkey.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () async => Navigator.of(context).pop(true),
                child: const Text('Yes'),
              ),
            ],
          ),
        ),
        child: InkWell(
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const DetailsScreen(),
            ),
          ),
          onLongPress: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => DetailsInputScreen(
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
                child: Text(passkey.username ?? passkey.email ?? passkey.org ?? 'No username',style: TextStyle(
                  overflow: TextOverflow.ellipsis,
                  color: passkey.syncStatus == SyncStatus.synced ? Colors.white : Colors.red,
                )),
              ),
              copyButton(context, isUserName: false),
            ],
          ),
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
            text: isUserName ? (passkey.username ?? passkey.email ?? '') : passkey.passKey ?? '',
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
