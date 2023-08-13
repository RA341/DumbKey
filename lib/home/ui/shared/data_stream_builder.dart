import 'package:flutter/material.dart';

class DataStreamBuilder<T> extends StatelessWidget {
  const DataStreamBuilder({
    required this.dataNotifier,
    required this.viewBuilder,
    super.key,
  });

  final ValueNotifier<List<T>> dataNotifier;
  final Widget Function(List<T> value) viewBuilder;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: dataNotifier,
      builder: (__, value, _) => viewBuilder(value),
    );
  }
}
