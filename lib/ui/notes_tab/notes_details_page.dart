import 'package:dumbkey/model/notes_model/notes_model.dart';
import 'package:flutter/material.dart';

class NotesDetailsPage extends StatelessWidget {
  const NotesDetailsPage({super.key, required this.note});

  final Notes note;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(note.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Text(note.notes),
      ),
    );
  }
}
