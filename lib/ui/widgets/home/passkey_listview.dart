import 'package:dumbkey/ui/widgets/home/passkey_tile.dart';
import 'package:dumbkey/utils/passkey_model.dart';
import 'package:flutter/material.dart';

class PasskeyListView extends StatelessWidget {
  const PasskeyListView({
    required this.passkeyList,
    required this.updateKeyFunc,
    required this.deleteKeyFunc,
    super.key,
  });

  final Future<void> Function(String docId, Map<String,dynamic> map) updateKeyFunc;
  final Future<void> Function(PassKey) deleteKeyFunc;
  final List<PassKey> passkeyList;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: passkeyList
          .map(
            (e) => PasskeyTitle(
              passkey: e,
              deleteKeyFunc: deleteKeyFunc,
              updateKeyFunc: updateKeyFunc,
            ),
          )
          .toList(),
    );
  }
}
