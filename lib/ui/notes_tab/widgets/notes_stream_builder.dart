import 'package:dumbkey/logic/database_handler.dart';
import 'package:dumbkey/model/notes_model/notes_model.dart';
import 'package:dumbkey/ui/notes_tab/widgets/notes_list_view.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class NotesStreamBuilder extends StatefulWidget {
  const NotesStreamBuilder({super.key});

  @override
  State<NotesStreamBuilder> createState() => _NotesStreamBuilderState();
}

class _NotesStreamBuilderState extends State<NotesStreamBuilder> {
  late final Stream<List<Notes>> _notesStream;

  @override
  void initState() {
    _notesStream = GetIt.I.get<DatabaseHandler>().fetchAllNotes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _notesStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        } else if (snapshot.data == null) {
          return const Text('Stream returned is null');
        } else {
          final data = snapshot.data ?? [];
          return NotesView(notesList: data);
        }
      },
    );
  }
}
