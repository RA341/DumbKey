import 'package:dumbkey/home/logic/database/database_handler.dart';
import 'package:dumbkey/model/card_details_model/card_details_model.dart';
import 'package:dumbkey/model/notes_model/notes_model.dart';
import 'package:dumbkey/model/password_model/password_model.dart';
import 'package:dumbkey/model/type_base_model.dart';
import 'package:dumbkey/utils/helper_func.dart';
import 'package:flutter/material.dart';

class DataCrudController {
  final isLoading = ValueNotifier(false);

  /// prepare data for creation
  TypeBase createDataFromMap<T extends TypeBase>(Map<String, dynamic> data) {
    switch (T) {
      case Password:
        data.addAll(TypeBase.defaultMap(DataType.password));
        return Password.fromMap(data);
      case CardDetails:
        data.addAll(TypeBase.defaultMap(DataType.card));
        return CardDetails.fromMap(data);
      case Notes:
        data.addAll(TypeBase.defaultMap(DataType.notes));
        return Notes.fromMap(data);
      default:
        throw Exception('Invalid type');
    }
  }

  Future<void> createFunc<T extends TypeBase>(
    BuildContext context,
    Map<String, dynamic> data,
  ) async {
    final newPasskey = createDataFromMap<T>(data);

    try {
      await dep<DatabaseHandler>().createData(newPasskey);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not add $e'),
        ),
      );
    }
  }

  Future<void> updateKeyFunc(
    BuildContext context,
    Map<String, dynamic> updateData,
    TypeBase prevData,
  ) async {
    updateData.addAll(prevData.defaultUpdateMap());
    final updatedPasskey = prevData.copyWithFromMap(updateData);

    updateData.removeWhere((key, value) => value == null || value == '');

    try {
      await dep<DatabaseHandler>().updateData(updateData, updatedPasskey);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not update $e'),
        ),
      );
    }
  }

  Future<void> submitFunction<T extends TypeBase>({
    required BuildContext context,
    required GlobalKey<FormState> formKey,
    required Map<String, dynamic> Function() convertToMapFunc,
    required TypeBase? savedKey,
  }) async {
    if (isLoading.value) return;
    isLoading.value = true;

    if (formKey.currentState!.validate()) {
      final data = convertToMapFunc();
      if (savedKey != null) {
        await updateKeyFunc(context, data, savedKey);
      } else {
        await createFunc<T>(context, data);
      }
    }

    isLoading.value = false;
    if (!context.mounted) return;
    Navigator.of(context).pop();
  }
}
