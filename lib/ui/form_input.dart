import 'package:dumbkey/key_model.dart';
import 'package:dumbkey/ui/widgets/form_input_widgets.dart';
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
                OrganizationField(controller: orgController),
                const SizedBox(height: 16),
                PasskeyField(controller: passkeyController),
                const SizedBox(height: 16),
                EmailField(controller: emailController),
                const SizedBox(height: 16),
                UsernameField(controller: usernameController),
                const SizedBox(height: 16),
                DescriptionField(controller: descriptionController),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () async {
                    if (isLoading) return;

                    if (_formKey.currentState!.validate()) {
                      // Form is valid, do something with the input values
                      final org = orgController.text;
                      final passKey = passkeyController.text;
                      final email = emailController.text;
                      final username = usernameController.text;
                      final description = descriptionController.text;

                      final data = PassKey(
                        org: org,
                        passKey: passKey,
                        email: email,
                        username: username,
                        description: description,
                        docId: DateTime.now().millisecondsSinceEpoch.toString(),
                      );
                      isLoading = true;
                      try {
                        await widget.addOrUpdateKeyFunc(data);
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Could not add $e'),
                          ),
                        );
                      }
                      isLoading = false;
                      if (!context.mounted) return;
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
