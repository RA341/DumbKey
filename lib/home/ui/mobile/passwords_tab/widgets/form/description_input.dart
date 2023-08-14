import 'package:flutter/material.dart';

class DescriptionField extends StatelessWidget {
  const DescriptionField({
    required this.controller,
    super.key,
  });

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onFieldSubmitted: (_) {},
      autovalidateMode: AutovalidateMode.onUserInteraction,
      scrollPadding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      controller: controller,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Description (optional)',
      ),
    );
  }
}
