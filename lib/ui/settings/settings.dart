import 'package:dumbkey/ui/auth_page/auth_controller.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Column(
        children: [
          ValueListenableBuilder(
            valueListenable: AuthController.inst.isLoading,
            builder: (context, value, child) {
              return ElevatedButton(
                onPressed: value ? null : () async => AuthController.inst.signOut(context),
                child: value ? const CircularProgressIndicator() : const Text('Log out'),
              );
            },
          ),
        ],
      ),
    );
  }
}
