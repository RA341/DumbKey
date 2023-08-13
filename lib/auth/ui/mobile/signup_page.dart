import 'package:dumbkey/auth/controllers/auth_controller.dart';
import 'package:dumbkey/home/ui/mobile/passwords_tab/widgets/form/email_input.dart';
import 'package:dumbkey/home/ui/mobile/passwords_tab/widgets/form/password_input.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  late final TextEditingController emailController;
  late final TextEditingController passwordController;

  @override
  void initState() {
    emailController = TextEditingController();
    passwordController = TextEditingController();

    // TODO remove this when done testing
    emailController.text = 'w@w.app';
    passwordController.text = '12345678aB!';

    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _signUp() async => AuthController.inst.signUp(
        context,
        emailController.text,
        passwordController.text,
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Sign Up')),
        body: Column(
          children: [
            EmailField(controller: emailController),
            PasskeyField(controller: passwordController),
            ValueListenableBuilder(
              valueListenable: AuthController.inst.isLoading,
              builder: (context, value, child) {
                return ElevatedButton(
                  onPressed: value ? null : _signUp,
                  child: value ? const CircularProgressIndicator() : const Text('Sign up'),
                );
              },
            ),
          ],
        ));
  }
}
