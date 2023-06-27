import 'package:dumbkey/model/passkey_model.dart';
import 'package:dumbkey/ui/home/widgets/passkey_tile.dart';
import 'package:flutter/material.dart';

class PasskeyListView extends StatelessWidget {
  const PasskeyListView({
    required this.passkeyList,
    super.key,
  });

  final List<PassKey> passkeyList;


  @override
  Widget build(BuildContext context) {
    final sortedBySyncStatus = <PassKey>[];
    final notSynced =
    passkeyList.where((e) => e.syncStatus == SyncStatus.notSynced).toList();
    final synced = passkeyList.where((e) => e.syncStatus == SyncStatus.synced).toList();
    sortedBySyncStatus.addAll([...synced, ...notSynced]);
    return ListView(
      children: sortedBySyncStatus.map((e) => PasskeyTitle(passkey: e)).toList(),
    );
  }
}
