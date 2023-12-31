import 'package:flutter/material.dart';

class PassKeySearchBar extends StatelessWidget {
  const PassKeySearchBar({
    required this.query, super.key,
  });

  final ValueNotifier<String> query;

  @override
  Widget build(BuildContext context) {
    return SearchBar(
      onChanged: (value) => query.value = value,
    );
  }
}
