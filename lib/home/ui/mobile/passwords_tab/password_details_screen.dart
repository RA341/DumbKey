// ignore_for_file: use_build_context_synchronously

import 'package:dumbkey/home/logic/database/database_handler.dart';
import 'package:dumbkey/home/ui/mobile/passwords_tab/add_password.dart';
import 'package:dumbkey/model/password_model/password_model.dart';
import 'package:dumbkey/utils/helper_func.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:isar/isar.dart';

class PasswordDetailsScreen extends StatefulWidget {
  const PasswordDetailsScreen({required this.passkey, super.key});

  final Password passkey;

  @override
  State<PasswordDetailsScreen> createState() => _PasswordDetailsScreenState();
}

class _PasswordDetailsScreenState extends State<PasswordDetailsScreen> {
  late Password _passkey;

  @override
  void initState() {
    _passkey = widget.passkey;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Details'),
          leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            tooltip: 'Back',
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 1),
              child: IconButton(
                onPressed: () async {
                  await Navigator.of(context).push(
                    // ignore: inference_failure_on_instance_creation
                    MaterialPageRoute(
                      builder: (context) => AddUpdatePassword(savedKey: _passkey),
                    ),
                  );
                  _passkey = (await dep.get<Isar>().passwords.get(_passkey.id))!;
                  setState(() {});
                },
                icon: const Icon(
                  Icons.edit,
                  color: Colors.white,
                ),
                tooltip: 'Edit',
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: IconButton(
                // ignore: inference_failure_on_function_invocation
                onPressed: () => showDialog(
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
                        onPressed: () async {
                          await dep.get<DatabaseHandler>().deleteData(_passkey);
                          Navigator.of(context).pop(true); // for the dialog
                          Navigator.of(context).pop(); // for the screen
                        },
                        child: const Text('Yes'),
                      ),
                    ],
                  ),
                ),
                icon: const Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
                tooltip: 'Delete',
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: buildHeader(),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: buildFields(),
            ),
          ],
        ),
        bottomNavigationBar: bottomCopyButtons());
  }

  Row bottomCopyButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: () => Clipboard.setData(
            ClipboardData(text: _passkey.username ?? ''),
          ),
          child: const Text('Username'),
        ),
        ElevatedButton(
          onPressed: () => Clipboard.setData(
            ClipboardData(text: _passkey.email ?? ''),
          ),
          child: const Text('Email'),
        ),
        ElevatedButton(
          onPressed: () => Clipboard.setData(
            ClipboardData(text: _passkey.password ?? ''),
          ),
          child: const Text('Password'),
        ),
      ],
    );
  }

  Widget buildHeader() {
    return _passkey.category != null ? Text(_passkey.category!) : const SizedBox();
  }

  Widget buildFields() {
    return Column(
      children: [
        buildRowDetail('Email', _passkey.email ?? ''),
        buildRowDetail('Username', _passkey.username ?? ''),
        buildRowDetail('Password', _passkey.password ?? ''),
        buildRowDetail('Description', _passkey.description ?? ''),
      ],
    );
  }

  Widget buildRowDetail(String rowTitle, String data) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          rowTitle,
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          data,
          overflow: TextOverflow.ellipsis,
        ),
        IconButton(
          icon: const Icon(Icons.copy),
          onPressed: () => Clipboard.setData(ClipboardData(text: data)),
        ),
      ],
    );
  }
}
