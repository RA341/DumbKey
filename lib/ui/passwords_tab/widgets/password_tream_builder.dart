import 'package:dumbkey/services/database/database_handler.dart';
import 'package:dumbkey/ui/passwords_tab/widgets/passkey_view.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class PasswordStreamBuilder extends StatelessWidget {
  const PasswordStreamBuilder({
    required this.valueListenable,
    super.key,
  });

  final ValueNotifier<String> valueListenable;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: GetIt.I.get<DatabaseHandler>().passwordCache,
      builder: (context, value, child) => PasskeyView(
        passkeyList: value,
        query: valueListenable,
      ),
    );
  }
}
