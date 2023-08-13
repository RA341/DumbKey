import 'package:dumbkey/home/logic/database/database_handler.dart';
import 'package:dumbkey/model/card_details_model/card_details_model.dart';
import 'package:dumbkey/model/notes_model/notes_model.dart';
import 'package:dumbkey/model/password_model/password_model.dart';
import 'package:dumbkey/model/type_base_model.dart';
import 'package:dumbkey/utils/helper_func.dart';

class SearchHandler {
  List<TypeBase> search(String query, List<TypeBase> list) {
    var result = <TypeBase>[];

    final passWords = dep.get<DatabaseHandler>().passwordCache;
    final notes = dep.get<DatabaseHandler>().notesCache;
    final cards = dep.get<DatabaseHandler>().cardDetailsCache;

    return result;
  }

  Iterable<TypeBase> fuzzySearch(String query, List<TypeBase> list) sync* {
    for (final data in list) {
      switch (data.dataType) {
        case DataType.password:
          if (searchPasswords(data as Password) != null) yield data;
        case DataType.notes:
          if (searchNotes(data as Notes) != null) yield data;
        case DataType.card:
          if (searchCards(data as CardDetails) != null) yield data;
      }
    }
  }

  Password? searchPasswords(Password data) {}

  CardDetails? searchCards(CardDetails card) {}

  Notes? searchNotes(Notes note) {}
}
