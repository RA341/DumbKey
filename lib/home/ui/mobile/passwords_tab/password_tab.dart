import 'package:dumbkey/home/ui/mobile/passwords_tab/widgets/password_tream_builder.dart';
import 'package:flutter/material.dart';

class PasswordTab extends StatelessWidget {
  const PasswordTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: PasswordStreamBuilder(
            valueListenable: ValueNotifier<String>(''),
          ),
        )
      ],
    );
  }
}
