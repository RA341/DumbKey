import 'package:flutter/material.dart';

class AddCard extends StatelessWidget {
  const AddCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Card'),
      ),
      body: const Center(
        child: Text('add card'),
      ),
    );
  }
}
