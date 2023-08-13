import 'package:flutter/material.dart';

class TitleInput extends StatelessWidget {
  const TitleInput({
    required this.controller,
    this.currFocusNode,
    this.nextFocusNode,
    super.key,
  });

  final FocusNode? currFocusNode;
  final FocusNode? nextFocusNode;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: currFocusNode,
      controller: controller,
      decoration: const InputDecoration(
        labelText: 'Title',
        hintText: 'Enter an identifying title',
        border: OutlineInputBorder(),
      ),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a title';
        }
        return null;
      },
      onFieldSubmitted: (_) {
        if (nextFocusNode == null || currFocusNode == null) return;
        currFocusNode!.unfocus();
        FocusScope.of(context).requestFocus(nextFocusNode);
      },
    );
  }
}
