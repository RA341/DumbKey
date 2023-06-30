import 'package:dumbkey/ui/card_tab/add_card.dart';
import 'package:dumbkey/ui/card_tab/cards_tab.dart';
import 'package:dumbkey/ui/notes_tab/add_notes.dart';
import 'package:dumbkey/ui/notes_tab/notes_tab.dart';
import 'package:dumbkey/ui/passwords_tab/form/password_input.dart';
import 'package:dumbkey/ui/passwords_tab/password_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

const appTabs = [
  Tab(text: 'Passwords'),
  Tab(text: 'Cards'),
  Tab(text: 'Notes'),
];

const tabScreens = [
  PasswordTab(),
  CardsTab(),
  NotesTab(),
];

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final queryListener = ValueNotifier<String>('');

    return DefaultTabController(
      length: appTabs.length,
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              title: const Center(child: Text('DumbKey')),
            ),
            body: const Column(
              children: [
                TabBar(tabs: appTabs),
                Expanded(child: TabBarView(children: tabScreens)),
              ],
            ),
            floatingActionButton: SpeedDial(
              animatedIcon: AnimatedIcons.add_event,
              children: [
                SpeedDialChild(
                  child: const Icon(Icons.add_card_outlined),
                  label: 'Add Card',
                  onTap: () => pushPage(context, const AddCard()),
                ),
                SpeedDialChild(
                  child: const Icon(Icons.add_moderator_outlined),
                  label: 'Add Password',
                  onTap: () => pushPage(context, const AddUpdatePassword()),
                ),
                SpeedDialChild(
                  child: const Icon(Icons.add),
                  label: 'Add Notes',
                  onTap: () => pushPage(context, const AddNotes()),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  void pushPage(BuildContext context, Widget page) =>
      // ignore: inference_failure_on_instance_creation
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => page));
}
