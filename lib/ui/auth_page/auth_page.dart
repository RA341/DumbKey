// import 'package:dumbkey/database/auth.dart';
// import 'package:firedart/auth/exceptions.dart';
// import 'package:firedart/auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:get_it/get_it.dart';
// import 'package:logger/logger.dart';
//
// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});
//
//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }
//
// class _LoginScreenState extends State<LoginScreen> {
//   final DatabaseAuth _auth = DatabaseAuth();
//
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//
//   Future<void> _login() async {
//
//     try {
//       await _auth.signIn(_emailController.text, _passwordController.text);
//     } on AuthException catch (e) {
//       GetIt.I.get<Logger>().e('failed to sign in',e);
//     }
//   }
//
//   // coolpassword123
//   Future<void> _signUp() async {
//     try {
//       await _auth.signUp(_emailController.text, _passwordController.text);
//     } on AuthException catch (e) {
//       GetIt.I.get<Logger>().e('failed to sign in',e);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Login Screen'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             TextField(
//               controller: _emailController,
//               decoration: const InputDecoration(
//                 labelText: 'Email',
//               ),
//             ),
//             const SizedBox(height: 16),
//             TextField(
//               controller: _passwordController,
//               decoration: const InputDecoration(
//                 labelText: 'Password',
//               ),
//               obscureText: true,
//             ),
//             const SizedBox(height: 16),
//             ElevatedButton(
//               onPressed: _login,
//               child: const Text('Login'),
//             ),
//             const SizedBox(height: 8),
//             ElevatedButton(
//               onPressed: _signUp,
//               child: const Text('Sign Up'),
//             ),
//             const SizedBox(height: 8),
//             const Text(
//               'wow',
//               style: TextStyle(color: Colors.red),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
