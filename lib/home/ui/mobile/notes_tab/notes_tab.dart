import 'package:dumbkey/home/logic/database/database_handler.dart';
import 'package:dumbkey/home/ui/mobile/notes_tab/widgets/notes_list_view.dart';
import 'package:dumbkey/home/ui/shared/data_stream_builder.dart';
import 'package:dumbkey/model/notes_model/notes_model.dart';
import 'package:dumbkey/utils/helper_func.dart';
import 'package:flutter/material.dart';

class NotesTab extends StatelessWidget {
  const NotesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return DataStreamBuilder<Notes>(
      dataNotifier: dep.get<DatabaseHandler>().notesCache,
      viewBuilder: (value) => NotesView(notesList: value),
    );
  }
}
