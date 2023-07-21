import 'package:dumbkey/model/type_base_model.dart';
import 'package:dumbkey/utils/constants.dart';
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
      id: map[DumbData.id] as int,
      dataType: TypeBase.getDataType(map[DumbData.dataType] as String),
      syncStatus: TypeBase.getSyncStatus(map[DumbData.syncStatus] as String),
      dateAdded: TypeBase.getDateTime(map[DumbData.dateAdded] as String),
      title: map[DumbData.title] as String,
      cardNumber: map[DumbData.cardNumber] as String,
      cardHolderName: map[DumbData.cardHolderName] as String,
      expirationDate: map[DumbData.expirationDate] as String,
      cvv: map[DumbData.cvv] as String,
    );
  }

  @override
  CardDetails copyWith(Map<String, dynamic> update) {
    return CardDetails(
      id: (update[DumbData.id] as int?) ?? id,
      dataType: update[DumbData.dataType] == null
          ? TypeBase.getDataType(update[DumbData.dataType]! as String)
          : dataType,
      syncStatus: update[DumbData.syncStatus] == null
          ? TypeBase.getSyncStatus(update[DumbData.syncStatus]! as String)
          : syncStatus,
      dateAdded: update[DumbData.dateAdded] == null
          ? TypeBase.getDateTime(update[DumbData.dateAdded]! as String)
          : dateAdded,
      title: (update[DumbData.title] as String?) ?? title,
      cardNumber: (update[DumbData.cardNumber] as String?) ?? cardNumber,
      cardHolderName: (update[DumbData.cardHolderName] as String?) ?? cardHolderName,
      expirationDate: (update[DumbData.expirationDate] as String?) ?? expirationDate,
      cvv: (update[DumbData.cvv] as String?) ?? cvv,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final data = super.toJson();
    data[DumbData.cardNumber] = cardNumber;
    data[DumbData.cardHolderName] = cardHolderName;
    data[DumbData.expirationDate] = expirationDate;
    data[DumbData.cvv] = cvv;
    return data;
  }

  String cardNumber;
  String cardHolderName;
  String expirationDate;
  String cvv;
}
