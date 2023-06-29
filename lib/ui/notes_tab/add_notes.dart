import 'package:flutter/material.dart';

class AddNotes extends StatelessWidget {
  const AddNotes({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Notes'),
      ),
      body: const Center(
        child: Text('add notes'),
      ),
    );
  }
}
