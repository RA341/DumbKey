import 'package:dumbkey/database/database_handler.dart';
import 'package:dumbkey/model/notes_model/notes_model.dart';
import 'package:dumbkey/ui/notes_tab/add_notes.dart';
import 'package:dumbkey/ui/notes_tab/notes_details_page.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

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
      children: notesList.map((note) => NoteDetailTile(note: note)).toList(),
    );
  }
}

class NoteDetailTile extends StatelessWidget {
  const NoteDetailTile({
    required this.note,
    super.key,
  });

  final Notes note;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => NotesDetailsPage(note: note)));
      },
      onLongPress: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => AddNotes(savedNote: note)));
      },
      child: Stack(
        alignment: Alignment.center,
        fit: StackFit.expand,
        children: [
          Card(
            color: Colors.transparent,
            child: ListTile(title: Text(note.title)),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Align(
              alignment: Alignment.bottomRight,
              child: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Are you sure?'),
                    content: const Text(
                      'This will permanently delete the Note.',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: const Text('No'),
                      ),
                      TextButton(
                        onPressed: () async {
                          await GetIt.I.get<DatabaseHandler>().deleteData(note);
                          Navigator.of(context).pop(true);
                        },
                        child: const Text('Yes'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
