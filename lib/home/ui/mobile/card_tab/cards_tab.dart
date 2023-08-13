import 'package:dumbkey/home/logic/database/database_handler.dart';
import 'package:dumbkey/home/ui/mobile/card_tab/widgets/card_view.dart';
import 'package:dumbkey/utils/helper_func.dart';
import 'package:flutter/material.dart';

class CardsTab extends StatelessWidget {
  const CardsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: dep.get<DatabaseHandler>().cardDetailsCache,
      builder: (context, value, child) {
        print('rebuild');
        return CardDetailsView(cardsList: value);
      },
    );
  }
}
