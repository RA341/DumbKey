import 'package:flutter/material.dart';

class OrganizationField extends StatelessWidget {

  const OrganizationField({required this.controller, super.key});
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      scrollPadding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom),
      controller: controller,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter the organization';
        }
        return null;
      },
      decoration: const InputDecoration(
        labelText: 'Organization',
      ),
    );
  }
}

class PasskeyField extends StatelessWidget {

  const PasskeyField({required this.controller, super.key});
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      scrollPadding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom),
      controller: controller,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter the passkey';
        }
        return null;
      },
      obscureText: true,
      decoration: const InputDecoration(
        labelText: 'Passkey',
      ),
    );
  }
}

class EmailField extends StatelessWidget {

  const EmailField({required this.controller, super.key});
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {

    return TextFormField(
      scrollPadding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom),
      controller: controller,
      decoration: const InputDecoration(
        labelText: 'Email (optional)',
      ),
    );
  }
}

class UsernameField extends StatelessWidget {

  const UsernameField({required this.controller, super.key});
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      scrollPadding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom),
      controller: controller,
      decoration: const InputDecoration(
        labelText: 'Username (optional)',
      ),
    );
  }
}

class DescriptionField extends StatelessWidget {

  const DescriptionField({required this.controller, super.key});
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      scrollPadding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom),
      controller: controller,
      decoration: const InputDecoration(
        labelText: 'Description (optional)',
      ),
    );
  }
}
