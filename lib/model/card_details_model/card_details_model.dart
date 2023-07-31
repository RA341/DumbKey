import 'package:dumbkey/model/type_base_model.dart';
import 'package:dumbkey/utils/constants.dart';
import 'package:isar/isar.dart';

part 'card_details_model.g.dart';

@collection
class CardDetails extends TypeBase {
  const CardDetails({
    required super.id,
    required super.dataType,
    required super.title,
    required super.dateAdded,
    required super.syncStatus,
    required super.nonce,
    required this.cardNumber,
    required this.cardHolderName,
    required this.expirationDate,
    required this.cvv,
  });

  factory CardDetails.fromMap(Map<String, dynamic> map) {
    return CardDetails(
      id: map[DumbData.id] as int,
      nonce: map[DumbData.nonce] as String,
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

  factory CardDetails.empty() {
    return CardDetails(
      nonce: '',
      id: 0,
      dataType: DataType.card,
      title: '',
      dateAdded: DateTime.now(),
      syncStatus: SyncStatus.synced,
      cardNumber: '',
      cardHolderName: '',
      expirationDate: '',
      cvv: '',
    );
  }

  @override
  CardDetails copyWithFromMap(Map<String, dynamic> update) {
    return CardDetails(
      nonce: update[DumbData.nonce] as String? ?? nonce,
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

  @override
  CardDetails copyWith({
    int? id,
    DataType? dataType,
    String? title,
    DateTime? dateAdded,
    SyncStatus? syncStatus,
    String? nonce,
    String? cardNumber,
    String? cardHolderName,
    String? expirationDate,
    String? cvv,
  }) {
    return CardDetails(
      id: id ?? this.id,
      dataType: dataType ?? this.dataType,
      title: title ?? this.title,
      dateAdded: dateAdded ?? this.dateAdded,
      syncStatus: syncStatus ?? this.syncStatus,
      nonce: nonce ?? this.nonce,
      cardNumber: cardNumber ?? this.cardNumber,
      cardHolderName: cardHolderName ?? this.cardHolderName,
      expirationDate: expirationDate ?? this.expirationDate,
      cvv: cvv ?? this.cvv,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CardDetails &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          dataType == other.dataType &&
          title == other.title &&
          dateAdded == other.dateAdded &&
          syncStatus == other.syncStatus &&
          nonce == other.nonce &&
          cardNumber == other.cardNumber &&
          cardHolderName == other.cardHolderName &&
          expirationDate == other.expirationDate &&
          cvv == other.cvv;

  @override
  int get hashCode =>
      id.hashCode ^
      dataType.hashCode ^
      title.hashCode ^
      dateAdded.hashCode ^
      syncStatus.hashCode ^
      nonce.hashCode ^
      cardNumber.hashCode ^
      cardHolderName.hashCode ^
      expirationDate.hashCode ^
      cvv.hashCode;

  final String cardNumber;
  final String cardHolderName;
  final String expirationDate;
  final String cvv;
}
