import 'package:dumbkey/home/logic/database/database_handler.dart';
import 'package:dumbkey/home/ui/mobile/card_tab/widgets/card_view.dart';
import 'package:dumbkey/home/ui/shared/data_stream_builder.dart';
import 'package:dumbkey/model/card_details_model/card_details_model.dart';
import 'package:dumbkey/utils/helper_func.dart';
import 'package:flutter/material.dart';

class CardsTab extends StatelessWidget {
  const CardsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return DataStreamBuilder<CardDetails>(
      dataNotifier: dep.get<DatabaseHandler>().cardDetailsCache,
      viewBuilder: (value) => CardDetailsView(cardsList: value),
    );
  }
}
