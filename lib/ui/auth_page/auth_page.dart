import 'package:dumbkey/ui/auth_page/auth_controller.dart';
import 'package:dumbkey/ui/auth_page/signup_page.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();

    // TODO remove this when done testing
    _emailController.text = 'w@w.app';
    _passwordController.text = '12345678aB!';
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async => AuthController.inst.signIn(
        context,
        _emailController.text,
        _passwordController.text,
      );

  // stuff@stuff.com
  // coolpassword123

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Screen'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
              ),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            ValueListenableBuilder(
              valueListenable: AuthController.inst.isLoading,
              builder: (context, value, child) {
                return ElevatedButton(
                  onPressed: value ? null : _login,
                  child: value ? const CircularProgressIndicator() : const Text('Login'),
                );
              },
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: pushPage,
              child: const Text('Sign Up'),
            ),
          ],
        ),
      ),
    );
  }

  void pushPage() {
    Navigator.push(
      context,
      MaterialPageRoute<void>(builder: (_) => const SignUpPage()),
    );
  }
}
