import 'package:flutter/material.dart';

class OrganizationField extends StatelessWidget {
  const OrganizationField({
    required this.controller,
    super.key,
  });

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
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
