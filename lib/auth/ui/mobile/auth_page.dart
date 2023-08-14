import 'package:dumbkey/auth/controllers/auth_controller.dart';
import 'package:dumbkey/auth/ui/mobile/signup_page.dart';
import 'package:dumbkey/utils/widgets/util.dart';
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

    if (isDebug) {
      _emailController.text = 'w@w.app';
      _passwordController.text = '12345678aB!';
    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.all(20),
          child: Center(
            child: Text('Login', style: TextStyle(fontSize: 40)),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: responsivePadding(context, horizontalFactor: 0.2, verticalFactor: 0.05),
              child: TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Email',
                ),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: responsivePadding(context, horizontalFactor: 0.2, verticalFactor: 0),
              child: TextField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                ),
                obscureText: true,
              ),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: responsivePadding(context, horizontalFactor: 0.4, verticalFactor: 0.015),
              child: ValueListenableBuilder(
                valueListenable: AuthController.inst.isLoading,
                builder: (context, value, child) {
                  return ElevatedButton(
                    onPressed: value ? null : _login,
                    child: value ? const CircularProgressIndicator() : const Text('Login'),
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: responsivePadding(context, horizontalFactor: 0.4, verticalFactor: 0.015),
              child: ElevatedButton(
                onPressed: pushPage,
                child: const Text('Sign Up'),
              ),
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
