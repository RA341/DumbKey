import 'package:dumbkey/utils/widgets/util.dart';
import 'package:flutter/material.dart';

class TitleInput extends StatelessWidget {
  const TitleInput({
    required this.controller,
    super.key,
  });

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: responsivePadding(context),
      child: TextFormField(
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
      ),
    );
  }
}
