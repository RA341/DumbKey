import 'package:dumbkey/home/logic/database/database_handler.dart';
import 'package:dumbkey/home/ui/mobile/passwords_tab/widgets/passkey_view.dart';
import 'package:dumbkey/home/ui/shared/data_stream_builder.dart';
import 'package:dumbkey/model/password_model/password_model.dart';
import 'package:dumbkey/utils/helper_func.dart';
import 'package:flutter/material.dart';

class PasswordTab extends StatelessWidget {
  const PasswordTab({super.key});

  @override
  Widget build(BuildContext context) {
    return DataStreamBuilder<Password>(
      dataNotifier: dep.get<DatabaseHandler>().passwordCache,
      viewBuilder: (value) => PasskeyView(
        passkeyList: value,
        query: ValueNotifier(''),
      ),
    );
  }
}
