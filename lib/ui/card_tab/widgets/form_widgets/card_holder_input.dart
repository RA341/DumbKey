import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CardHolderInput extends StatelessWidget {
  const CardHolderInput({required this.controller, super.key});

  final TextEditingController controller;
  static const int maxCardNumberLength = 16;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: const InputDecoration(
        labelText: 'Card Holder',
        hintText: 'Enter the cardholder name',
        border: OutlineInputBorder(),
      ),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z ]')),
      ],
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter the cardholder name';
        }
        return null;
      },
    );
  }
}