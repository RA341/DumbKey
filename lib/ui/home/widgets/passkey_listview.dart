import 'package:dumbkey/logic/settings_handler.dart';
import 'package:dumbkey/model/passkey_model.dart';
import 'package:dumbkey/ui/home/widgets/passkey_tile.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:string_extensions/string_extensions.dart';

final logger = GetIt.I.get<Logger>();

class PasskeyListView extends StatelessWidget {
  const PasskeyListView({
    required this.passkeyList,
    required this.query,
    super.key,
  });

  final List<PassKey> passkeyList;
  final ValueNotifier<String> query;

  @override
  Widget build(BuildContext context) {
    if (passkeyList.isEmpty) {
      return const Center(
        child: Text('No passwords found'),
      );
    }

    var sortedBySyncStatus = <PassKey>[];
    final notSynced = passkeyList.where((e) => e.syncStatus == SyncStatus.notSynced).toList();
    final synced = passkeyList.where((e) => e.syncStatus == SyncStatus.synced).toList();
    sortedBySyncStatus = [...synced, ...notSynced];
    return ValueListenableBuilder(
        valueListenable: query,
        builder: (context, value, _) {
          if (value.isNotEmpty) {
            sortedBySyncStatus = filterList(sortedBySyncStatus);
          } else {
            sortedBySyncStatus = [...synced, ...notSynced];
          }

          return ListView(
            children: sortedBySyncStatus.map((e) => PasskeyTitle(passkey: e)).toList(),
          );
        });
  }

  List<PassKey> filterList(List<PassKey> sortedBySyncStatus) {
    final settings = GetIt.I.get<SettingsHandler>();

    // TODO(filterList): add config if user wants to search through passwords
    const searchThroughPasswords = false;

    var results = <int, double>{};

    for (final passKeys in sortedBySyncStatus) {
      var totalScore = 0.0;
      for (final value in passKeys.toJSON().values) {
        if (value.runtimeType != String) continue;
        totalScore += (value as String).getJaro(query.value);
      }
      results[passKeys.docId] = totalScore;
    }

    final sortedByScore = results.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
    results = {for (var entry in sortedByScore) entry.key: entry.value};

    final sortedList = <PassKey>[];
    for (final entry in results.entries) {
      final data = sortedBySyncStatus.firstWhere((element) => element.docId == entry.key);
      sortedList.add(data);
    }
    // logger.d('Sorted list: ${sortedList.map((e) => e.docId)}');
    return sortedList;
  }
}
