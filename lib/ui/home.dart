import 'package:dumbkey/logic/abstract_firestore.dart';
import 'package:dumbkey/logic/firestore_mobile.dart';
import 'package:dumbkey/ui/form_input.dart';
import 'package:dumbkey/ui/widgets/home/passkey_listview.dart';
import 'package:dumbkey/utils/passkey_model.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FireStoreBase database = MobileFireStore();
  late final Stream<List<PassKey>> passkeyStream;

  @override
  void initState() {
    passkeyStream = database.fetchAllPassKeys();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: ListViewStreamBuilder(
              passkeyStream: passkeyStream,
              deleteKeyFunc: deleteKey,
              updateKeyFunc: updateKey,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => DetailsInputScreen(
              addOrUpdateKeyFunc: createKey,
            ),
          ),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> createKey(PassKey data) async => database.createPassKey(data);

  Future<void> deleteKey(PassKey data) async => database.deletePassKey(data);

  Future<void> updateKey(PassKey data) async => database.updatePassKey(data);
}

class ListViewStreamBuilder extends StatelessWidget {
  const ListViewStreamBuilder({
    required this.passkeyStream,
    required this.updateKeyFunc,
    required this.deleteKeyFunc,
    super.key,
  });

  final Future<void> Function(PassKey) updateKeyFunc;
  final Future<void> Function(PassKey) deleteKeyFunc;
  final Stream<List<PassKey>> passkeyStream;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: passkeyStream,
      initialData: const <PassKey>[],
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          final data = snapshot.data ?? [];
          return PasskeyListView(
            passkeyList: data,
            deleteKeyFunc: deleteKeyFunc,
            updateKeyFunc: updateKeyFunc,
          );
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
