import 'package:dumbkey/utils/helper_func.dart';
import 'package:flutter/material.dart';

class PasskeyField extends StatefulWidget {
  const PasskeyField({
    required this.controller,
    this.currFocusNode,
    this.nextFocusNode,
    super.key,
  });

  final FocusNode? currFocusNode;
  final FocusNode? nextFocusNode;
  final TextEditingController controller;

  @override
  State<PasskeyField> createState() => _PasskeyFieldState();
}

class _PasskeyFieldState extends State<PasskeyField> {
  bool isHidden = true;

  final passwordStrengthMap = <PasswordStrength, Color>{
    PasswordStrength.Weak: Colors.red,
    PasswordStrength.WeakMedium: Colors.orange,
    PasswordStrength.Medium: Colors.yellow,
    PasswordStrength.Strong: Colors.green,
  };

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            focusNode: widget.currFocusNode,
            onFieldSubmitted: (_) {
              widget.currFocusNode?.unfocus();
              FocusScope.of(context).requestFocus(widget.nextFocusNode);
            },
            autovalidateMode: AutovalidateMode.onUserInteraction,
            scrollPadding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            controller: widget.controller,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter the passkey';
              }
              final strength = testPasswordStrength(value);
              if (strength == PasswordStrength.Weak) {
                return 'Passkey is too small';
              } else if (strength == PasswordStrength.WeakMedium) {
                return 'Passkey does not contain numbers';
              } else if (strength == PasswordStrength.Medium) {
                return 'Passkey does not contain special characters';
              }
              return null;
            },
            obscureText: isHidden,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Passkey',
            ),
          ),
        ),
        IconButton(
          onPressed: () => setState(() => isHidden = !isHidden),
          icon: isHidden
              ? const Icon(Icons.remove_red_eye_outlined)
              : const Icon(Icons.remove_red_eye),
        )
      ],
    );
  }
}
