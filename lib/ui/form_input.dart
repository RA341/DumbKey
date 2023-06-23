import 'package:dumbkey/ui/widgets/edit_buttons/description_input.dart';
import 'package:dumbkey/ui/widgets/edit_buttons/email_input.dart';
import 'package:dumbkey/ui/widgets/edit_buttons/org_input.dart';
import 'package:dumbkey/ui/widgets/edit_buttons/password_input.dart';
import 'package:dumbkey/ui/widgets/edit_buttons/username_input.dart';
import 'package:dumbkey/utils/constants.dart';
import 'package:dumbkey/utils/passkey_model.dart';
import 'package:flutter/material.dart';

class DetailsInputScreen extends StatefulWidget {
  const DetailsInputScreen({
    required this.addOrUpdateKeyFunc,
    super.key,
    this.savedKey,
  });

  final Future<void> Function(PassKey) addOrUpdateKeyFunc;
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
      orgController.text = widget.savedKey!.org;
      passkeyController.text = widget.savedKey!.passKey;
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

                    if (_formKey.currentState!.validate()) {
                      // Form is valid, do something with the input values
                      final passKey = passkeyController.text;
                      final org = orgController.text.isEmpty
                          ? Constants.defaultOrgName
                          : orgController.text;
                      final email = emailController.text.isEmpty ? null : emailController.text;
                      final username =
                          usernameController.text.isEmpty ? null : usernameController.text;
                      final description =
                          descriptionController.text.isEmpty ? null : descriptionController.text;

                      final data = PassKey(
                        org: org,
                        passKey: passKey,
                        email: email,
                        username: username,
                        description: description,
                        docId: '',
                      );

                      setState(() => isLoading = true);
                      try {
                        await widget.addOrUpdateKeyFunc(data);
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Could not add $e'),
                          ),
                        );
                      }
                      setState(() => isLoading = false);
                      if (!context.mounted) return;
                      Navigator.of(context).pop();
                    }
                  },
                  child: isLoading ?
                      const CircularProgressIndicator()
                      : const Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
