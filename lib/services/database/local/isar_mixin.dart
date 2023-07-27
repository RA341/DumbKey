import 'package:dumbkey/model/card_details_model/card_details_model.dart';
import 'package:dumbkey/model/notes_model/notes_model.dart';
import 'package:dumbkey/model/password_model/password_model.dart';
import 'package:dumbkey/model/type_base_model.dart';
import 'package:dumbkey/services/encryption_handler.dart';
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
      // logger.d('added data to local', [data]);
    } catch (e) {
      logger.e('error deleting data from local ${data.id}');
      throw Exception('Error adding data to local: $e');
    }
  }

  Future<void> isarDelete(int id, DataType type) async {
    try {
      await isarDb.writeTxn(() async {
        final as = await collectionSwitcher(type).delete(id);
        logger.d('deleted from local $id: $as');
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
    final decrypted = cryptMap(e.toJson(), GetIt.I.get<IDataEncryptor>().decryptMap);
    return e.copyWith(decrypted) as T;
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
