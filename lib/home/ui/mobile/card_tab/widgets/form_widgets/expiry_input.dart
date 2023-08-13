import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ExpiryInput extends StatelessWidget {
  const ExpiryInput({required this.controller, super.key});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: const InputDecoration(
        labelText: 'Expiration',
        hintText: 'MM/YY',
        border: OutlineInputBorder(),
      ),
      inputFormatters: [
        LengthLimitingTextInputFormatter(5),
        ExpiryInputFormatter(),
      ],
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter the expiration month';
        }
        if (value.length < 5 || value.contains(RegExp(r'[a-zA-Z]'))) {
          return 'Please enter a valid expiration date';
        }
        if (int.parse(value.substring(3, 5)) <
            int.parse(DateTime.now().year.toString().substring(2, 4))) {
          return 'Please enter a valid year';
        }
        return null;
      },
    );
  }
}

class ExpiryInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final newText = newValue.text;
    if (newText.isEmpty) {
      return newValue;
    }

    if (newText.contains(RegExp(r'[a-zA-Z]'))) {
      return newValue;
    }

    final oldText = oldValue.text;
    if (newText.length < oldText.length) {
      return newValue;
    }

    if (newText.length == 1 && int.parse(newText) > 1) {
      return TextEditingValue(
        text: '0$newText/',
        selection: const TextSelection.collapsed(offset: 3),
      );
    } else if (newText.length == 2) {
      if (int.parse(newText.substring(0, 2)) > 12) {
        return const TextEditingValue(
          text: '12/',
          selection: TextSelection.collapsed(offset: 3),
        );
      } else if (oldText.length == 1 && int.parse(newText) <= 1) {
        return TextEditingValue(
          text: newText.substring(0, 1),
          selection: const TextSelection.collapsed(offset: 1),
        );
      } else {
        return TextEditingValue(
          text: '$newText/',
          selection: const TextSelection.collapsed(offset: 3),
        );
      }
    } else if (newText.length == 3 && newText.substring(2, 3) != '/') {
      return TextEditingValue(
        text: '${newText.substring(0, 2)}/${newText.substring(3, 4)}',
        selection: const TextSelection.collapsed(offset: 3),
      );
    } else if (newText.length == 4 && newText.substring(3, 4) == '/') {
      return TextEditingValue(
        text: newText.substring(0, 3),
        selection: const TextSelection.collapsed(offset: 3),
      );
    }

    return newValue;
  }
}
