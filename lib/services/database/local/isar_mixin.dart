import 'package:dumbkey/model/card_details_model/card_details_model.dart';
import 'package:dumbkey/model/notes_model/notes_model.dart';
import 'package:dumbkey/model/password_model/password_model.dart';
import 'package:dumbkey/model/type_base_model.dart';
import 'package:dumbkey/services/encryption_handler.dart';
import 'package:dumbkey/utils/helper_func.dart';
import 'package:dumbkey/utils/logger.dart';
import 'package:isar/isar.dart';

mixin IsarDbMixin {
  final Isar isarDb = dep.get<Isar>();

  Future<void> isarCreateOrUpdateAll(List<TypeBase> remote) async {
    for (final datum in remote) {
      // if data is not present in local or data is changed
      final stuff = await collectionSwitcher(datum.dataType).get(datum.id);
      final dataChanged = stuff == null || stuff != datum;

      if (dataChanged) {
        await isarCreateOrUpdate(datum);
        logger.v('data changed updating ${datum.id}');
      }
    }
  }

  Future<void> isarCreateOrUpdate(TypeBase data) async {
    try {
      await isarDb.writeTxn(() async {
        await collectionSwitcher(data.dataType).put(data);
      });
      logger.v('added data to local ${data.id}');
    } catch (e) {
      logger.e('error deleting data from local ${data.id}');
      rethrow;
    }
  }

  Future<void> isarDelete(int id, DataType type) async {
    try {
      await isarDb.writeTxn(() async {
        final as = await collectionSwitcher(type).delete(id);
        logger.v('deleted from local $id: $as');
      });
      //
    } catch (e) {
      logger.e('error deleting data from local $id');
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

  T decryptLocalStream<T>(TypeBase e) {
    final decrypted = cryptMap(e.toJson(), dep.get<IDataEncryptor>().decryptMap);
    return e.copyWithFromMap(decrypted) as T;
  }

  Stream<List<Password>> fetchAllPassKeys() => isarDb.passwords
      .where()
      .filter()
      .not()
      .syncStatusEqualTo(SyncStatus.deleted)
      .build()
      .watch(fireImmediately: true)
      .distinct()
      .map((event) => event.map((e) => decryptLocalStream<Password>(e)).toList());

  Stream<List<Notes>> fetchAllNotes() => isarDb.notes
      .where()
      .filter()
      .not()
      .syncStatusEqualTo(SyncStatus.deleted)
      .build()
      .watch(fireImmediately: true)
      .distinct()
      .map((event) => event.map((e) => decryptLocalStream<Notes>(e)).toList());

  Stream<List<CardDetails>> fetchAllCardDetails() => isarDb.cardDetails
      .where()
      .filter()
      .not()
      .syncStatusEqualTo(SyncStatus.deleted)
      .build()
      .watch(fireImmediately: true)
      .distinct()
      .map((event) => event.map((e) => decryptLocalStream<CardDetails>(e)).toList());
}
