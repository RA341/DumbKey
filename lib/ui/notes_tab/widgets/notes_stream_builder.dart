import 'package:dumbkey/services/database/database_handler.dart';
import 'package:dumbkey/ui/notes_tab/widgets/notes_list_view.dart';
import 'package:flutter/material.dart';

import '../../../utils/helper_func.dart';

class NotesStreamBuilder extends StatelessWidget {
  const NotesStreamBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: dep.get<DatabaseHandler>().notesCache,
      builder: (context, value, child) {
        print('rebuild');
        return NotesView(notesList: value);
      },
    );
  }
}
