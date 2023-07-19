import 'package:dumbkey/services/settings_handler.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class CategoryField extends StatelessWidget {
  const CategoryField({
    required this.controller,
    required this.currFocusNode,
    super.key,
  });

  final FocusNode currFocusNode;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final settings = GetIt.I.get<SettingsHandler>();
    print(settings.settingsInst.categories);

    return Autocomplete<String>(
      optionsBuilder: (textEditingValue) {
        if (settings.settingsInst.categories == null || textEditingValue.text.isEmpty) {
          return const Iterable<String>.empty();
        }
        print(textEditingValue.text);
        return settings.settingsInst.categories!
            .where((element) => element.contains(textEditingValue.text.toLowerCase()));
      },
      fieldViewBuilder: (context, textEditingController, focusNode, onFieldSubmitted) {
        return TextFormField(
          autofillHints: settings.settingsInst.categories,
          focusNode: currFocusNode,
          onFieldSubmitted: (_) async {
            if (controller.text.isNotEmpty) {
              await settings.addCategory(controller.text.toLowerCase());
            }
            currFocusNode.unfocus();
          },
          scrollPadding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          controller: controller,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Category',
          ),
        );
      },
      onSelected: (String selection) async {
        await settings.addCategory(selection.toLowerCase());
        controller.text = selection;
      },
    );
  }
}
