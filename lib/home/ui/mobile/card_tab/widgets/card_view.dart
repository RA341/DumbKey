import 'package:dumbkey/home/ui/shared/grid_tile.dart';
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
    return Padding(
      padding: const EdgeInsets.all(7),
      child: GridView(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
        children: cardsList.map((note) {
          return SharedCardTile(data: note);
        }).toList(),
      ),
    );
  }
}
