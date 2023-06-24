import 'package:dumbkey/logic/firestore_stub.dart';
import 'package:dumbkey/ui/form_input.dart';
import 'package:dumbkey/ui/widgets/home/passkey_listview.dart';
import 'package:dumbkey/model/passkey_model.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Column(
        children: [
          Expanded(
            child: ListViewStreamBuilder(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).push(
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
    super.key,
  });

  @override
  State<ListViewStreamBuilder> createState() => _ListViewStreamBuilderState();
}

class _ListViewStreamBuilderState extends State<ListViewStreamBuilder> {
  late final Stream<List<PassKey>> passkeyStream;

  @override
  void initState() {
    passkeyStream = GetIt.I.get<FireStoreBase>().fetchAllPassKeys();
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
          return PasskeyListView(passkeyList: data);
        } else if (snapshot.hasError) {
          print(snapshot.error);
          return Text(snapshot.error.toString());
        } else if (snapshot.data == null) {
          return const Text('Stream returned is null');
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}
