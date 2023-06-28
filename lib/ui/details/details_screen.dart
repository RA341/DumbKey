import 'package:dumbkey/model/passkey_model.dart';
import 'package:flutter/material.dart';

class DetailsScreen extends StatelessWidget {
  const DetailsScreen({super.key, required this.passkey});
  final PassKey passkey;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Details'),
      ),
      body: const Center(
        child: Text('Details Screen'),
      ),
    );
  }
}
