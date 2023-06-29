import 'package:dumbkey/model/type_base_model.dart';
import 'package:dumbkey/utils/key_name_constants.dart';
import 'package:isar/isar.dart';

part 'card_details_model.g.dart';

@collection
class CardDetails extends TypeBase {
  CardDetails({
    required super.id,
    required super.dataType,
    required super.title,
    required super.dateAdded,
    required super.syncStatus,
    required this.cardNumber,
    required this.cardHolderName,
    required this.expirationDate,
    required this.cvv,
  });

  factory CardDetails.fromMap(Map<String, dynamic> map) {
    return CardDetails(
      id: map[KeyNames.id] as int,
      dataType: TypeBase.getDataType(map[KeyNames.dataType] as String),
      syncStatus: TypeBase.getSyncStatus(map[KeyNames.syncStatus] as String),
      dateAdded: TypeBase.getDateTime(map[KeyNames.dateAdded] as String),
      title: map[KeyNames.title] as String,
      cardNumber: map[KeyNames.cardNumber] as String,
      cardHolderName: map[KeyNames.cardHolderName] as String,
      expirationDate: map[KeyNames.expirationDate] as String,
      cvv: map[KeyNames.cvv] as String,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final data = super.toJson();
    data[KeyNames.cardNumber] = cardNumber;
    data[KeyNames.cardHolderName] = cardHolderName;
    data[KeyNames.expirationDate] = expirationDate;
    data[KeyNames.cvv] = cvv;
    return data;
  }

  String cardNumber;
  String cardHolderName;
  String expirationDate;
  String cvv;
}
