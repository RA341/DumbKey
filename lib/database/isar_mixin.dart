import 'package:dumbkey/model/card_details_model/card_details_model.dart';
import 'package:dumbkey/model/notes_model/notes_model.dart';
import 'package:dumbkey/model/password_model/password_model.dart';
import 'package:dumbkey/model/type_base_model.dart';
import 'package:get_it/get_it.dart';
import 'package:isar/isar.dart';

mixin IsarDbMixin {
  final Isar isarDb = GetIt.I.get<Isar>();

  Future<void> isarDelete(int id, DataType type) async {
    await isarDb.writeTxn(() async {
      await collectionSwitcher(type).delete(id);
    });
  }

  Future<void> isarCreateOrUpdateAll(List<TypeBase> data) async {
    for (final datum in data) {
      await isarCreateOrUpdate(datum);
    }
  }

  Future<void> isarCreateOrUpdate(TypeBase passkey) async {
    await isarDb.writeTxn(() async {
      await collectionSwitcher(passkey.dataType).put(passkey);
    });
  }

  IsarCollection<TypeBase> collectionSwitcher(DataType type) {
    switch (type) {
      case DataType.card:
        return isarDb.cardDetails;
      case DataType.password:
        return isarDb.passwords;
      case DataType.notes:
        return isarDb.notes;
    }
  }
}
