import 'package:dumbkey/home/ui/shared/grid_tile.dart';
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
    return GridView(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1.5,
      ),
      children: notesList.map((note) => SharedCardTile(data: note)).toList(),
    );
  }
}
