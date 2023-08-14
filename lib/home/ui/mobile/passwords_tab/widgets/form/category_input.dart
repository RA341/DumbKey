import 'package:dumbkey/settings/logic/settings_handler.dart';
import 'package:dumbkey/utils/helper_func.dart';
import 'package:flutter/material.dart';

class CategoryField extends StatelessWidget {
  const CategoryField({
    required this.controller,
    super.key,
  });

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final settings = dep.get<SettingsHandler>();
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
          onFieldSubmitted: (_) {
            if (controller.text.isNotEmpty) {
              settings.addCategory(controller.text.toLowerCase());
            }
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
      onSelected: (String selection) {
        settings.addCategory(selection.toLowerCase());
        controller.text = selection;
      },
    );
  }
}
