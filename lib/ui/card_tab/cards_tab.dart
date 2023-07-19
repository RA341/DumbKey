import 'package:dumbkey/model/card_details_model/card_details_model.dart';
import 'package:dumbkey/services/database/database_handler.dart';
import 'package:dumbkey/ui/card_tab/widgets/card_view.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class CardsTab extends StatefulWidget {
  const CardsTab({super.key});

  @override
  State<CardsTab> createState() => _CardsTabState();
}

class _CardsTabState extends State<CardsTab> {
  late final Stream<List<CardDetails>> _cardStream;

  @override
  void initState() {
    _cardStream = GetIt.I.get<DatabaseHandler>().fetchAllCardDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _cardStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        } else if (snapshot.data == null) {
          return const Text('Stream returned is null');
        } else {
          final data = snapshot.data ?? [];
          return CardDetailsView(cardsList: data);
        }
      },
    );
  }
}
