import 'package:dumbkey/controllers/data_crud_controller.dart';
import 'package:dumbkey/model/password_model/password_model.dart';
import 'package:dumbkey/ui/passwords_tab/form/fields/category_input.dart';
import 'package:dumbkey/ui/passwords_tab/form/fields/description_input.dart';
import 'package:dumbkey/ui/passwords_tab/form/fields/email_input.dart';
import 'package:dumbkey/ui/passwords_tab/form/fields/password_input.dart';
import 'package:dumbkey/ui/passwords_tab/form/fields/username_input.dart';
import 'package:dumbkey/ui/shared/title_input.dart';
import 'package:dumbkey/utils/constants.dart';
import 'package:flutter/material.dart';

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
  final titleController = TextEditingController();

  final FocusNode _titleFocusNode = FocusNode();
  final FocusNode _passkeyFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _usernameFocusNode = FocusNode();
  final FocusNode _descriptionFocusNode = FocusNode();
  final FocusNode _categoryFocusNode = FocusNode();

  final controller = DataCrudController();

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
    titleController.dispose();
    passkeyController.dispose();
    emailController.dispose();
    usernameController.dispose();
    descriptionController.dispose();
    categoryController.dispose();

    _titleFocusNode.dispose();
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
                TitleInput(
                  controller: titleController,
                  currFocusNode: _titleFocusNode,
                  nextFocusNode: _passkeyFocusNode,
                ),
                const SizedBox(height: 16),
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
                ValueListenableBuilder(
                  valueListenable: controller.isLoading,
                  builder: (context, value, child) {
                    return ElevatedButton(
                      onPressed: value
                          ? () {}
                          : () async {
                              await controller.submitFunction<Password>(
                                context: context,
                                formKey: _formKey,
                                convertToMapFunc: convertInputToList,
                                savedKey: widget.savedKey,
                              );
                            },
                      child: value
                          ? const CircularProgressIndicator()
                          : widget.savedKey == null
                              ? const Text('Submit')
                              : const Text('Update'),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Map<String, dynamic> convertInputToList() {
    final title = titleController.text.isEmpty ? null : titleController.text;
    final email = emailController.text.isEmpty ? null : emailController.text;
    final username = usernameController.text.isEmpty ? null : usernameController.text;
    final passKey = passkeyController.text.isEmpty ? null : passkeyController.text;
    final description = descriptionController.text.isEmpty ? null : descriptionController.text;
    final category = categoryController.text.isEmpty ? null : categoryController.text;

    final data = <String, dynamic>{};

    if (widget.savedKey != null) {
      data[DumbData.title] = title == widget.savedKey!.title ? null : title;
      data[DumbData.email] = email == widget.savedKey!.email ? null : email;
      data[DumbData.username] = username == widget.savedKey!.username ? null : username;
      data[DumbData.password] = passKey == widget.savedKey!.password ? null : passKey;
      data[DumbData.description] = description == widget.savedKey!.description ? null : description;
      data[DumbData.category] = category == widget.savedKey!.category ? null : category;
    } else {
      data[DumbData.title] = title;
      data[DumbData.username] = username;
      data[DumbData.email] = email;
      data[DumbData.password] = passKey;
      data[DumbData.description] = description;
      data[DumbData.category] = category;
    }

    return data;
  }
}
