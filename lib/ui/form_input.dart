import 'package:dumbkey/database/database_handler.dart';
import 'package:dumbkey/model/passkey_model.dart';
import 'package:dumbkey/ui/widgets/edit_buttons/description_input.dart';
import 'package:dumbkey/ui/widgets/edit_buttons/email_input.dart';
import 'package:dumbkey/ui/widgets/edit_buttons/org_input.dart';
import 'package:dumbkey/ui/widgets/edit_buttons/password_input.dart';
import 'package:dumbkey/ui/widgets/edit_buttons/username_input.dart';
import 'package:dumbkey/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class DetailsInputScreen extends StatefulWidget {
  const DetailsInputScreen({
    super.key,
    this.savedKey,
  });

  final PassKey? savedKey;

  @override
  State<DetailsInputScreen> createState() => _DetailsInputScreenState();
}

class _DetailsInputScreenState extends State<DetailsInputScreen> {
  final _formKey = GlobalKey<FormState>();
  final orgController = TextEditingController();
  final passkeyController = TextEditingController();
  final emailController = TextEditingController();
  final usernameController = TextEditingController();
  final descriptionController = TextEditingController();

  final FocusNode _orgFocusNode = FocusNode();
  final FocusNode _passkeyFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _usernameFocusNode = FocusNode();
  final FocusNode _descriptionFocusNode = FocusNode();

  bool isLoading = false;

  @override
  void initState() {
    if (widget.savedKey != null) {
      orgController.text = widget.savedKey!.org ?? '';
      passkeyController.text = widget.savedKey!.passKey ?? '';
      emailController.text = widget.savedKey!.email ?? '';
      usernameController.text = widget.savedKey!.username ?? '';
      descriptionController.text = widget.savedKey!.description ?? '';
    }
    super.initState();
  }

  @override
  void dispose() {
    orgController.dispose();
    passkeyController.dispose();
    emailController.dispose();
    usernameController.dispose();
    descriptionController.dispose();
    _orgFocusNode.dispose();
    _passkeyFocusNode.dispose();
    _emailFocusNode.dispose();
    _usernameFocusNode.dispose();
    _descriptionFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('Input Screen'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                EmailField(
                  controller: emailController,
                  currFocusNode: _emailFocusNode,
                  nextFocusNode: _usernameFocusNode,
                ),
                const SizedBox(height: 16),
                UsernameField(
                  controller: usernameController,
                  currFocusNode: _usernameFocusNode,
                  nextFocusNode: _passkeyFocusNode,
                ),
                const SizedBox(height: 16),
                PasskeyField(
                  controller: passkeyController,
                  currFocusNode: _passkeyFocusNode,
                  nextFocusNode: _orgFocusNode,
                ),
                const SizedBox(height: 16),
                OrganizationField(
                  controller: orgController,
                  currFocusNode: _orgFocusNode,
                  nextFocusNode: _descriptionFocusNode,
                ),
                const SizedBox(height: 16),
                DescriptionField(
                  controller: descriptionController,
                  currFocusNode: _descriptionFocusNode,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () async {
                    if (isLoading) return;
                    setState(() => isLoading = true);

                    if (_formKey.currentState!.validate()) {
                      final data = convertInputToList();
                      if (widget.savedKey != null) {
                        await updateKeyFunc(data);
                      } else {
                        await createFunc(data);
                      }
                    }

                    setState(() => isLoading = false);
                    if (!context.mounted) return;
                    Navigator.of(context).pop();
                  },
                  child: isLoading ? const CircularProgressIndicator() : const Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Map<String, dynamic> convertInputToList() {
    final passKey = passkeyController.text.isEmpty ? null : passkeyController.text;
    final org = orgController.text.isEmpty ? Constants.defaultOrgName : orgController.text;
    final email = emailController.text.isEmpty ? null : emailController.text;
    final username = usernameController.text.isEmpty ? null : usernameController.text;
    final description = descriptionController.text.isEmpty ? null : descriptionController.text;

    return {
      Constants.passKey: passKey,
      Constants.org: org,
      Constants.email: email,
      Constants.username: username,
      Constants.description: description,
      Constants.docId: widget.savedKey?.docId ?? 0, // possible bug originating
    };
  }

  Future<void> createFunc(Map<String, dynamic> data) async {
    final newPasskey = PassKey(
      org: data[Constants.org] as String?,
      passKey: data[Constants.passKey] as String?,
      docId: data[Constants.docId] as int,
      email: data[Constants.email] as String?,
      username: data[Constants.username] as String?,
      description: data[Constants.description] as String?,
    );

    try {
      await GetIt.I<DatabaseHandler>().createPassKey(newPasskey);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not add $e'),
        ),
      );
    }
  }

  Future<void> updateKeyFunc(Map<String, dynamic> updateData) async {
    assert(updateData[Constants.docId] != null, 'docId cannot be null');
    final docId = updateData[Constants.docId] as int;
    updateData.removeWhere((key, value) => value == null || value == '' || key == Constants.docId);

    await GetIt.I<DatabaseHandler>().updatePassKey(docId.toString(), updateData);
    try {} catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not update $e'),
        ),
      );
    }
  }
}
