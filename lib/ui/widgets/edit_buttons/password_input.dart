import 'package:flutter/material.dart';

class PasskeyField extends StatefulWidget {
  const PasskeyField({
    required this.controller,
    required this.currFocusNode,
    required this.nextFocusNode,
    super.key,
  });

  final FocusNode currFocusNode;
  final FocusNode nextFocusNode;
  final TextEditingController controller;

  @override
  State<PasskeyField> createState() => _PasskeyFieldState();
}

class _PasskeyFieldState extends State<PasskeyField> {
  bool isHidden = true;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            focusNode: widget.currFocusNode,
            onFieldSubmitted: (_) {
              widget.currFocusNode.unfocus();
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
              return null;
            },
            obscureText: isHidden,
            decoration: const InputDecoration(
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
