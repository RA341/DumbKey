import 'package:dumbkey/home/logic/database/database_handler.dart';
import 'package:dumbkey/home/ui/mobile/card_tab/add_card.dart';
import 'package:dumbkey/home/ui/mobile/card_tab/card_details_page.dart';
import 'package:dumbkey/home/ui/mobile/notes_tab/add_notes.dart';
import 'package:dumbkey/home/ui/mobile/notes_tab/notes_details_page.dart';
import 'package:dumbkey/home/ui/mobile/passwords_tab/add_password.dart';
import 'package:dumbkey/home/ui/mobile/passwords_tab/password_details_screen.dart';
import 'package:dumbkey/model/card_details_model/card_details_model.dart';
import 'package:dumbkey/model/notes_model/notes_model.dart';
import 'package:dumbkey/model/password_model/password_model.dart';
import 'package:dumbkey/model/type_base_model.dart';
import 'package:dumbkey/utils/helper_func.dart';
import 'package:flutter/material.dart';

class SharedCardTile extends StatelessWidget {
  const SharedCardTile({
    required this.data,
    super.key,
  });

  final TypeBase data;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        goToDetailsPage(context, data);
      },
      child: Stack(
        alignment: Alignment.center,
        fit: StackFit.expand,
        children: [
          Card(
            color: Colors.transparent,
            child: ListTile(title: Text(data.title)),
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
                          await dep.get<DatabaseHandler>().deleteData(data);
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
          Padding(
            padding: const EdgeInsets.all(10),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  goToAddUpdatePage(context, data);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void goToDetailsPage(BuildContext context, TypeBase data) {
    final type = data.dataType;

    switch (type) {
      case DataType.notes:
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (context) => NotesDetailsPage(note: data as Notes),
          ),
        );
      case DataType.password:
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (context) => PasswordDetailsScreen(
              passkey: data as Password,
            ),
          ),
        );
      case DataType.card:
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (context) => CardDetailsPage(
              card: data as CardDetails,
            ),
          ),
        );
    }
  }

  void goToAddUpdatePage(BuildContext context, TypeBase data) {
    final type = data.dataType;

    switch (type) {
      case DataType.notes:
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (context) => AddNotes(savedNote: data as Notes),
          ),
        );
      case DataType.password:
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (context) => AddUpdatePassword(
              savedKey: data as Password,
            ),
          ),
        );
      case DataType.card:
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (context) => AddCard(
              savedCard: data as CardDetails,
            ),
          ),
        );
    }
  }
}
