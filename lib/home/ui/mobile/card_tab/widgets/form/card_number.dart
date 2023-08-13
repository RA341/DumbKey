import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CardNumberInput extends StatelessWidget {
  const CardNumberInput({required this.controller, super.key});

  final TextEditingController controller;
  static const int maxCardNumberLength = 16;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: const InputDecoration(
        labelText: 'Card Number',
        hintText: 'Enter your card number',
        border: OutlineInputBorder(),
      ),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(maxCardNumberLength),
      ],
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a card number';
        }
        return null;
      },
    );
  }
}