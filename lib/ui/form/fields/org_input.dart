import 'package:flutter/material.dart';

class OrganizationField extends StatelessWidget {
  const OrganizationField({
    required this.controller,
    required this.currFocusNode,
    required this.nextFocusNode,
    super.key,
  });

  final FocusNode currFocusNode;
  final FocusNode nextFocusNode;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: currFocusNode,
      onFieldSubmitted: (_) {
        currFocusNode.unfocus();
        FocusScope.of(context).requestFocus(nextFocusNode);
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
      scrollPadding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      controller: controller,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Organization',
      ),
    );
  }
}
