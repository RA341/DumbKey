import 'package:dumbkey/home/controllers/data_crud_controller.dart';
import 'package:dumbkey/home/ui/mobile/passwords_tab/widgets/form/category_input.dart';
import 'package:dumbkey/home/ui/mobile/passwords_tab/widgets/form/description_input.dart';
import 'package:dumbkey/home/ui/mobile/passwords_tab/widgets/form/email_input.dart';
import 'package:dumbkey/home/ui/mobile/passwords_tab/widgets/form/password_input.dart';
import 'package:dumbkey/home/ui/mobile/passwords_tab/widgets/form/username_input.dart';
import 'package:dumbkey/home/ui/shared/title_input.dart';
import 'package:dumbkey/model/password_model/password_model.dart';
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

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // text on page
    final isNew = widget.savedKey == null;

    final titleText = isNew ? 'New Password' : 'Update password';
    final submitText = isNew ? 'Submit' : 'Update';

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(title: Text(titleText)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TitleInput(controller: titleController),
                const SizedBox(height: 16),
                EmailField(controller: emailController),
                const SizedBox(height: 16),
                UsernameField(controller: usernameController),
                const SizedBox(height: 16),
                PasskeyField(controller: passkeyController),
                const SizedBox(height: 16),
                DescriptionField(controller: descriptionController),
                const SizedBox(height: 16),
                CategoryField(controller: categoryController),
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
                      child: value ? const CircularProgressIndicator() : Text(submitText),
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
