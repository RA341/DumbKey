import 'package:dumbkey/database/database_handler.dart';
import 'package:dumbkey/model/password_model/password_model.dart';
import 'package:dumbkey/model/type_base_model.dart';
import 'package:dumbkey/ui/passwords_tab/form/fields/category_input.dart';
import 'package:dumbkey/ui/passwords_tab/form/fields/description_input.dart';
import 'package:dumbkey/ui/passwords_tab/form/fields/email_input.dart';
import 'package:dumbkey/ui/passwords_tab/form/fields/password_input.dart';
import 'package:dumbkey/ui/passwords_tab/form/fields/username_input.dart';
import 'package:dumbkey/utils/helper_func.dart';
import 'package:dumbkey/utils/key_name_constants.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class AddUpdatePassword extends StatefulWidget {
  const AddUpdatePassword({
    super.key,
    this.savedKey,
  });

  final Password? savedKey;

  @override
  State<AddUpdatePassword> createState() => _AddUpdatePasswordState();
}

class _AddUpdatePasswordState extends State<AddUpdatePassword> {
  final _formKey = GlobalKey<FormState>();
  final passkeyController = TextEditingController();
  final emailController = TextEditingController();
  final usernameController = TextEditingController();
  final descriptionController = TextEditingController();
  final categoryController = TextEditingController();

  final FocusNode _passkeyFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _usernameFocusNode = FocusNode();
  final FocusNode _descriptionFocusNode = FocusNode();
  final FocusNode _categoryFocusNode = FocusNode();

  bool isLoading = false;

  @override
  void initState() {
    if (widget.savedKey != null) {
      passkeyController.text = widget.savedKey!.password ?? '';
      emailController.text = widget.savedKey!.email ?? '';
      usernameController.text = widget.savedKey!.username ?? '';
      descriptionController.text = widget.savedKey!.description ?? '';
      categoryController.text = widget.savedKey!.category ?? '';
    }
    super.initState();
  }

  @override
  void dispose() {
    passkeyController.dispose();
    emailController.dispose();
    usernameController.dispose();
    descriptionController.dispose();
    categoryController.dispose();

    _passkeyFocusNode.dispose();
    _emailFocusNode.dispose();
    _usernameFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _categoryFocusNode.dispose();
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
                  nextFocusNode: _descriptionFocusNode,
                ),
                const SizedBox(height: 16),
                DescriptionField(
                  controller: descriptionController,
                  currFocusNode: _descriptionFocusNode,
                  nextFocusNode: _categoryFocusNode,
                ),
                const SizedBox(height: 16),
                CategoryField(
                  controller: categoryController,
                  currFocusNode: _categoryFocusNode,
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
    final email = emailController.text.isEmpty ? null : emailController.text;
    final username = usernameController.text.isEmpty ? null : usernameController.text;
    final passKey = passkeyController.text.isEmpty ? null : passkeyController.text;
    final description = descriptionController.text.isEmpty ? null : descriptionController.text;
    final category = categoryController.text.isEmpty ? null : categoryController.text;

    final data = <String, dynamic>{};

    if (widget.savedKey != null) {
      data[KeyNames.email] = email == widget.savedKey!.email ? null : email;
      data[KeyNames.username] = username == widget.savedKey!.username ? null : username;
      data[KeyNames.password] = passKey == widget.savedKey!.password ? null : passKey;
      data[KeyNames.description] = description == widget.savedKey!.description ? null : description;
      data[KeyNames.category] = category == widget.savedKey!.category ? null : category;
    } else {
      data[KeyNames.username] = username;
      data[KeyNames.email] = email;
      data[KeyNames.password] = passKey;
      data[KeyNames.description] = description;
      data[KeyNames.category] = category;
    }

    return data;
  }

  Future<void> createFunc(Map<String, dynamic> data) async {
    data[KeyNames.id] = idGenerator();
    data[KeyNames.dataType] = DataType.password.index.toString();
    data[KeyNames.syncStatus] = SyncStatus.synced.index.toString();
    data[KeyNames.dateAdded] = DateTime.now().toIso8601String();

    final newPasskey = Password.fromMap(data);

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
    updateData[KeyNames.id] = widget.savedKey?.id;
    updateData[KeyNames.syncStatus] = widget.savedKey!.syncStatus.index.toString();
    updateData[KeyNames.dataType] = null;

    final updatedPasskey = widget.savedKey!.copyWith(updateData);

    updateData.removeWhere((key, value) => value == null || value == '');

    try {
      await GetIt.I<DatabaseHandler>().updatePassKey(updateData, updatedPasskey);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not update $e'),
        ),
      );
    }
  }
}
