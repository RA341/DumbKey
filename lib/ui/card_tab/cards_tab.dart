import 'package:dumbkey/services/database/database_handler.dart';
import 'package:dumbkey/ui/card_tab/widgets/card_view.dart';
import 'package:flutter/material.dart';

import '../../utils/helper_func.dart';

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
