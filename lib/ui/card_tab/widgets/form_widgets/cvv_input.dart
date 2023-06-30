import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CVVInput extends StatelessWidget {
  const CVVInput({required this.controller, super.key});

  final TextEditingController controller;
  static const int maxCVVLength = 4;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: const InputDecoration(
        labelText: 'CVV',
        hintText: 'Enter your CVV',
        border: OutlineInputBorder(),
      ),
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(maxCVVLength),
      ],
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a CVV';
        }
        if (value.length > 4) {
          return 'Please enter a valid CVV';
        }

        return null;
      },
    );
  }
}