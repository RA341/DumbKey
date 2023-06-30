import 'package:dumbkey/model/card_details_model/card_details_model.dart';
import 'package:flutter/material.dart';

class CardDetailsView extends StatelessWidget {
  const CardDetailsView({
    required this.cardsList,
    super.key,
  });

  final List<CardDetails> cardsList;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: cardsList.map((note) {
        return Card(
          color: Colors.transparent,
          child: ListTile(title: Text(note.title)),
        );
      }).toList(),
    );
  }
}
