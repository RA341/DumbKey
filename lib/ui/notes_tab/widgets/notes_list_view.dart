import 'package:dumbkey/model/notes_model/notes_model.dart';
import 'package:flutter/material.dart';

class NotesView extends StatelessWidget {
  const NotesView({
    required this.notesList,
    super.key,
  });

  final List<Notes> notesList;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: notesList.map((note) {
        return Card(
          child: ListTile(
            title: Text(note.title),
            subtitle: Text(note.notes),
          ),
        );
      }).toList(),
    );
  }
}
