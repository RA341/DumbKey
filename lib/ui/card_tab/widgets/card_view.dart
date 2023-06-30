// ignore_for_file: inference_failure_on_instance_creation

import 'package:dumbkey/database/database_handler.dart';
import 'package:dumbkey/model/card_details_model/card_details_model.dart';
import 'package:dumbkey/ui/card_tab/add_card.dart';
import 'package:dumbkey/ui/card_tab/card_details_page.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class CardDetailsView extends StatelessWidget {
  const CardDetailsView({
    required this.cardsList,
    super.key,
  });

  final List<CardDetails> cardsList;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(7),
      child: GridView(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
        children: cardsList.map((note) {
          return CardDetailTile(card: note);
        }).toList(),
      ),
    );
  }
}

class CardDetailTile extends StatelessWidget {
  const CardDetailTile({
    required this.card,
    super.key,
  });

  final CardDetails card;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => CardDetailsPage(card: card)));
      },
      onLongPress: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => AddCard(savedCard: card)));
      },
      child: Stack(
        alignment: Alignment.center,
        fit: StackFit.expand,
        children: [
          Card(
            color: Colors.transparent,
            child: ListTile(title: Text(card.title)),
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
                      'This will permanently delete the Card.',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: const Text('No'),
                      ),
                      TextButton(
                        onPressed: () async {
                          await GetIt.I.get<DatabaseHandler>().deleteData(card);
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
