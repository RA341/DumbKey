import 'package:dumbkey/utils/passkey_model.dart';
import 'package:flutter/material.dart';

class DetailsScreen extends StatelessWidget {
  const DetailsScreen({
    required this.updateKeyFunc,
    required this.deleteKeyFunc,
    super.key,
  });

  final Future<void> Function(PassKey) updateKeyFunc;
  final Future<void> Function(PassKey) deleteKeyFunc;

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Details Screen'),
      ),
    );
  }
}
