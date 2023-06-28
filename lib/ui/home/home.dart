import 'package:dumbkey/database/database_handler.dart';
import 'package:dumbkey/model/passkey_model.dart';
import 'package:dumbkey/ui/form/form_input.dart';
import 'package:dumbkey/ui/home/widgets/passkey_listview.dart';
import 'package:dumbkey/ui/home/widgets/serach_bar.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final queryListener = ValueNotifier<String>('');

    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('DumbKey')),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            child: PassKeySearchBar(query: queryListener),
          ),
          Expanded(
            child: ListViewStreamBuilder(
              valueListenable: queryListener,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).push(
          // ignore: inference_failure_on_instance_creation
          MaterialPageRoute(
            builder: (context) => const DetailsInputScreen(),
          ),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class ListViewStreamBuilder extends StatefulWidget {
  const ListViewStreamBuilder({
    required this.valueListenable,
    super.key,
  });

  final ValueNotifier<String> valueListenable;

  @override
  State<ListViewStreamBuilder> createState() => _ListViewStreamBuilderState();
}

class _ListViewStreamBuilderState extends State<ListViewStreamBuilder> {
  late final Stream<List<PassKey>> passkeyStream;

  @override
  void initState() {
    passkeyStream = GetIt.I.get<DatabaseHandler>().fetchAllPassKeys();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: passkeyStream,
      initialData: const <PassKey>[],
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          final data = snapshot.data ?? [];
          return PasskeyListView(
            query: widget.valueListenable,
            passkeyList: data,
          );
        } else if (snapshot.hasError) {
          GetIt.I.get<Logger>().e('Stream builder returned error', [snapshot.error]);
          return Text(snapshot.error.toString());
        } else if (snapshot.data == null) {
          return const Text('Stream returned is null');
        } else {
          final data = snapshot.data ?? [];
          return PasskeyListView(
            passkeyList: data,
            query: widget.valueListenable,
          );
        }
      },
    );
  }
}
