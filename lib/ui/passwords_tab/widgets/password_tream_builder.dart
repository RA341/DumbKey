import 'package:dumbkey/logic/database_handler.dart';
import 'package:dumbkey/model/password_model/password_model.dart';
import 'package:dumbkey/ui/passwords_tab/widgets/passkey_view.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';

class PasswordStreamBuilder extends StatefulWidget {
  const PasswordStreamBuilder({
    required this.valueListenable,
    super.key,
  });

  final ValueNotifier<String> valueListenable;

  @override
  State<PasswordStreamBuilder> createState() => _PasswordStreamBuilderState();
}

class _PasswordStreamBuilderState extends State<PasswordStreamBuilder> {
  late final Stream<List<Password>> _passkeyStream;

  @override
  void initState() {
    _passkeyStream = GetIt.I.get<DatabaseHandler>().fetchAllPassKeys();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _passkeyStream,
      initialData: const <Password>[],
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          GetIt.I.get<Logger>().e('Stream builder returned error', [snapshot.error]);
          return Text(snapshot.error.toString());
        } else if (snapshot.data == null) {
          return const Text('Stream returned is null');
        } else {
          final data = snapshot.data ?? [];

          return PasskeyView(passkeyList: data, query: widget.valueListenable);
        }
      },
    );
  }
}
