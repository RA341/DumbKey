import 'package:dumbkey/model/card_details_model/card_details_model.dart';
import 'package:dumbkey/model/notes_model/notes_model.dart';
import 'package:dumbkey/model/password_model/password_model.dart';
import 'package:dumbkey/model/type_base_model.dart';
import 'package:dumbkey/utils/logger.dart';
import 'package:get_it/get_it.dart';
import 'package:isar/isar.dart';

mixin IsarDbMixin {
  final Isar isarDb = GetIt.I.get<Isar>();

  Future<void> isarCreateOrUpdateAll(List<TypeBase> data) async {
    for (final datum in data) {
      await isarCreateOrUpdate(datum);
    }
  }

  Future<void> isarCreateOrUpdate(TypeBase data) async {
    try {
      await isarDb.writeTxn(() async {
        await collectionSwitcher(data.dataType).put(data);
      });
      logger.d('added data to local', [data]);
    } catch (e) {
      logger.e('error adding data to local', [data]);
      throw Exception('Error adding data to local: $e');
    }
  }

  Future<void> isarDelete(int id, DataType type) async {
    try {
      await isarDb.writeTxn(() async {
        await collectionSwitcher(type).delete(id);
      });
      logger.d('deleted from local', [id]);
    } catch (e) {
      logger.e('error deleting data from local', [id]);
      throw Exception('Error deleting data from local: $e');
    }
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

  IsarCollection<T> collectionSwitcher2<T extends TypeBase>() {
    switch (T) {
      case CardDetails:
        return isarDb.cardDetails as IsarCollection<T>;
      case Password:
        return isarDb.passwords as IsarCollection<T>;
      case Notes:
        return isarDb.notes as IsarCollection<T>;
      default:
        throw Exception('Invalid type');
    }
  }
}
