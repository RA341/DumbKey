// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'card_details_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetCardDetailsCollection on Isar {
  IsarCollection<CardDetails> get cardDetails => this.collection();
}

const CardDetailsSchema = CollectionSchema(
  name: r'CardDetails',
  id: -1262872517231032116,
  properties: {
    r'cardHolderName': PropertySchema(
      id: 0,
      name: r'cardHolderName',
      type: IsarType.string,
    ),
    r'cardNumber': PropertySchema(
      id: 1,
      name: r'cardNumber',
      type: IsarType.string,
    ),
    r'cvv': PropertySchema(
      id: 2,
      name: r'cvv',
      type: IsarType.string,
    ),
    r'dataType': PropertySchema(
      id: 3,
      name: r'dataType',
      type: IsarType.byte,
      enumMap: _CardDetailsdataTypeEnumValueMap,
    ),
    r'dateAdded': PropertySchema(
      id: 4,
      name: r'dateAdded',
      type: IsarType.dateTime,
    ),
    r'expirationDate': PropertySchema(
      id: 5,
      name: r'expirationDate',
      type: IsarType.string,
    ),
    r'hashCode': PropertySchema(
      id: 6,
      name: r'hashCode',
      type: IsarType.long,
    ),
    r'nonce': PropertySchema(
      id: 7,
      name: r'nonce',
      type: IsarType.string,
    ),
    r'syncStatus': PropertySchema(
      id: 8,
      name: r'syncStatus',
      type: IsarType.byte,
      enumMap: _CardDetailssyncStatusEnumValueMap,
    ),
    r'title': PropertySchema(
      id: 9,
      name: r'title',
      type: IsarType.string,
    )
  },
  estimateSize: _cardDetailsEstimateSize,
  serialize: _cardDetailsSerialize,
  deserialize: _cardDetailsDeserialize,
  deserializeProp: _cardDetailsDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _cardDetailsGetId,
  getLinks: _cardDetailsGetLinks,
  attach: _cardDetailsAttach,
  version: '3.1.0+1',
);

int _cardDetailsEstimateSize(
  CardDetails object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.cardHolderName.length * 3;
  bytesCount += 3 + object.cardNumber.length * 3;
  bytesCount += 3 + object.cvv.length * 3;
  bytesCount += 3 + object.expirationDate.length * 3;
  bytesCount += 3 + object.nonce.length * 3;
  bytesCount += 3 + object.title.length * 3;
  return bytesCount;
}

void _cardDetailsSerialize(
  CardDetails object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.cardHolderName);
  writer.writeString(offsets[1], object.cardNumber);
  writer.writeString(offsets[2], object.cvv);
  writer.writeByte(offsets[3], object.dataType.index);
  writer.writeDateTime(offsets[4], object.dateAdded);
  writer.writeString(offsets[5], object.expirationDate);
  writer.writeLong(offsets[6], object.hashCode);
  writer.writeString(offsets[7], object.nonce);
  writer.writeByte(offsets[8], object.syncStatus.index);
  writer.writeString(offsets[9], object.title);
}

CardDetails _cardDetailsDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = CardDetails(
    cardHolderName: reader.readString(offsets[0]),
    cardNumber: reader.readString(offsets[1]),
    cvv: reader.readString(offsets[2]),
    dataType:
        _CardDetailsdataTypeValueEnumMap[reader.readByteOrNull(offsets[3])] ??
            DataType.card,
    dateAdded: reader.readDateTime(offsets[4]),
    expirationDate: reader.readString(offsets[5]),
    id: id,
    nonce: reader.readStringOrNull(offsets[7]) ?? '',
    syncStatus:
        _CardDetailssyncStatusValueEnumMap[reader.readByteOrNull(offsets[8])] ??
            SyncStatus.notSynced,
    title: reader.readString(offsets[9]),
  );
  return object;
}

P _cardDetailsDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (_CardDetailsdataTypeValueEnumMap[reader.readByteOrNull(offset)] ??
          DataType.card) as P;
    case 4:
      return (reader.readDateTime(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readLong(offset)) as P;
    case 7:
      return (reader.readStringOrNull(offset) ?? '') as P;
    case 8:
      return (_CardDetailssyncStatusValueEnumMap[
              reader.readByteOrNull(offset)] ??
          SyncStatus.notSynced) as P;
    case 9:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _CardDetailsdataTypeEnumValueMap = {
  'card': 0,
  'password': 1,
  'notes': 2,
};
const _CardDetailsdataTypeValueEnumMap = {
  0: DataType.card,
  1: DataType.password,
  2: DataType.notes,
};
const _CardDetailssyncStatusEnumValueMap = {
  'notSynced': 0,
  'synced': 1,
  'deleted': 2,
};
const _CardDetailssyncStatusValueEnumMap = {
  0: SyncStatus.notSynced,
  1: SyncStatus.synced,
  2: SyncStatus.deleted,
};

Id _cardDetailsGetId(CardDetails object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _cardDetailsGetLinks(CardDetails object) {
  return [];
}

void _cardDetailsAttach(
    IsarCollection<dynamic> col, Id id, CardDetails object) {}

extension CardDetailsQueryWhereSort
    on QueryBuilder<CardDetails, CardDetails, QWhere> {
  QueryBuilder<CardDetails, CardDetails, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension CardDetailsQueryWhere
    on QueryBuilder<CardDetails, CardDetails, QWhereClause> {
  QueryBuilder<CardDetails, CardDetails, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<CardDetails, CardDetails, QAfterWhereClause> idNotEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<CardDetails, CardDetails, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<CardDetails, CardDetails, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<CardDetails, CardDetails, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension CardDetailsQueryFilter
    on QueryBuilder<CardDetails, CardDetails, QFilterCondition> {
  QueryBuilder<CardDetails, CardDetails, QAfterFilterCondition>
      cardHolderNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'cardHolderName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CardDetails, CardDetails, QAfterFilterCondition>
      cardHolderNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'cardHolderName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CardDetails, CardDetails, QAfterFilterCondition>
      cardHolderNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'cardHolderName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CardDetails, CardDetails, QAfterFilterCondition>
      cardHolderNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'cardHolderName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CardDetails, CardDetails, QAfterFilterCondition>
      cardHolderNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'cardHolderName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CardDetails, CardDetails, QAfterFilterCondition>
      cardHolderNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'cardHolderName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CardDetails, CardDetails, QAfterFilterCondition>
      cardHolderNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'cardHolderName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CardDetails, CardDetails, QAfterFilterCondition>
      cardHolderNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'cardHolderName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CardDetails, CardDetails, QAfterFilterCondition>
      cardHolderNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'cardHolderName',
        value: '',
      ));
    });
  }

  QueryBuilder<CardDetails, CardDetails, QAfterFilterCondition>
      cardHolderNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'cardHolderName',
        value: '',
      ));
    });
  }

  QueryBuilder<CardDetails, CardDetails, QAfterFilterCondition>
      cardNumberEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'cardNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CardDetails, CardDetails, QAfterFilterCondition>
      cardNumberGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'cardNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CardDetails, CardDetails, QAfterFilterCondition>
      cardNumberLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'cardNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CardDetails, CardDetails, QAfterFilterCondition>
      cardNumberBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'cardNumber',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CardDetails, CardDetails, QAfterFilterCondition>
      cardNumberStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'cardNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CardDetails, CardDetails, QAfterFilterCondition>
      cardNumberEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'cardNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CardDetails, CardDetails, QAfterFilterCondition>
      cardNumberContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'cardNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CardDetails, CardDetails, QAfterFilterCondition>
      cardNumberMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'cardNumber',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CardDetails, CardDetails, QAfterFilterCondition>
      cardNumberIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'cardNumber',
        value: '',
      ));
    });
  }

  QueryBuilder<CardDetails, CardDetails, QAfterFilterCondition>
      cardNumberIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'cardNumber',
        value: '',
      ));
    });
  }

  QueryBuilder<CardDetails, CardDetails, QAfterFilterCondition> cvvEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'cvv',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CardDetails, CardDetails, QAfterFilterCondition> cvvGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'cvv',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CardDetails, CardDetails, QAfterFilterCondition> cvvLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'cvv',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CardDetails, CardDetails, QAfterFilterCondition> cvvBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'cvv',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CardDetails, CardDetails, QAfterFilterCondition> cvvStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'cvv',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CardDetails, CardDetails, QAfterFilterCondition> cvvEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'cvv',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CardDetails, CardDetails, QAfterFilterCondition> cvvContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'cvv',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CardDetails, CardDetails, QAfterFilterCondition> cvvMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'cvv',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CardDetails, CardDetails, QAfterFilterCondition> cvvIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'cvv',
        value: '',
      ));
    });
  }

  QueryBuilder<CardDetails, CardDetails, QAfterFilterCondition>
      cvvIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'cvv',
        value: '',
      ));
    });
  }

  QueryBuilder<CardDetails, CardDetails, QAfterFilterCondition> dataTypeEqualTo(
      DataType value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dataType',
        value: value,
      ));
    });
  }

  QueryBuilder<CardDetails, CardDetails, QAfterFilterCondition>
      dataTypeGreaterThan(
    DataType value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dataType',
        value: value,
      ));
    });
  }

  QueryBuilder<CardDetails, CardDetails, QAfterFilterCondition>
      dataTypeLessThan(
    DataType value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dataType',
        value: value,
      ));
    });
  }

  QueryBuilder<CardDetails, CardDetails, QAfterFilterCondition> dataTypeBetween(
    DataType lower,
    DataType upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dataType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CardDetails, CardDetails, QAfterFilterCondition>
      dateAddedEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dateAdded',
        value: value,
      ));
    });
  }

  QueryBuilder<CardDetails, CardDetails, QAfterFilterCondition>
      dateAddedGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dateAdded',
        value: value,
      ));
    });
  }

  QueryBuilder<CardDetails, CardDetails, QAfterFilterCondition>
      dateAddedLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dateAdded',
        value: value,
      ));
    });
  }

  QueryBuilder<CardDetails, CardDetails, QAfterFilterCondition>
      dateAddedBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dateAdded',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CardDetails, CardDetails, QAfterFilterCondition>
      expirationDateEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'expirationDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CardDetails, CardDetails, QAfterFilterCondition>
      expirationDateGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'expirationDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CardDetails, CardDetails, QAfterFilterCondition>
      expirationDateLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'expirationDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CardDetails, CardDetails, QAfterFilterCondition>
      expirationDateBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'expirationDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CardDetails, CardDetails, QAfterFilterCondition>
      expirationDateStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'expirationDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CardDetails, CardDetails, QAfterFilterCondition>
      expirationDateEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'expirationDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CardDetails, CardDetails, QAfterFilterCondition>
      expirationDateContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'expirationDate',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CardDetails, CardDetails, QAfterFilterCondition>
      expirationDateMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'expirationDate',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CardDetails, CardDetails, QAfterFilterCondition>
      expirationDateIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'expirationDate',
        value: '',
      ));
    });
  }

  QueryBuilder<CardDetails, CardDetails, QAfterFilterCondition>
      expirationDateIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'expirationDate',
        value: '',
      ));
    });
  }

  QueryBuilder<CardDetails, CardDetails, QAfterFilterCondition> hashCodeEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'hashCode',
        value: value,
      ));
    });
  }

  QueryBuilder<CardDetails, CardDetails, QAfterFilterCondition>
      hashCodeGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'hashCode',
        value: value,
      ));
    });
  }

  QueryBuilder<CardDetails, CardDetails, QAfterFilterCondition>
      hashCodeLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'hashCode',
        value: value,
      ));
    });
  }

  QueryBuilder<CardDetails, CardDetails, QAfterFilterCondition> hashCodeBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'hashCode',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CardDetails, CardDetails, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<CardDetails, CardDetails, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<CardDetails, CardDetails, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<CardDetails, CardDetails, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CardDetails, CardDetails, QAfterFilterCondition> nonceEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'nonce',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CardDetails, CardDetails, QAfterFilterCondition>
      nonceGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'nonce',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CardDetails, CardDetails, QAfterFilterCondition> nonceLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'nonce',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CardDetails, CardDetails, QAfterFilterCondition> nonceBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'nonce',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CardDetails, CardDetails, QAfterFilterCondition> nonceStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'nonce',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CardDetails, CardDetails, QAfterFilterCondition> nonceEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'nonce',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CardDetails, CardDetails, QAfterFilterCondition> nonceContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'nonce',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CardDetails, CardDetails, QAfterFilterCondition> nonceMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'nonce',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CardDetails, CardDetails, QAfterFilterCondition> nonceIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'nonce',
        value: '',
      ));
    });
  }

  QueryBuilder<CardDetails, CardDetails, QAfterFilterCondition>
      nonceIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'nonce',
        value: '',
      ));
    });
  }

  QueryBuilder<CardDetails, CardDetails, QAfterFilterCondition>
      syncStatusEqualTo(SyncStatus value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'syncStatus',
        value: value,
      ));
    });
  }

  QueryBuilder<CardDetails, CardDetails, QAfterFilterCondition>
      syncStatusGreaterThan(
    SyncStatus value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'syncStatus',
        value: value,
      ));
    });
  }

  QueryBuilder<CardDetails, CardDetails, QAfterFilterCondition>
      syncStatusLessThan(
    SyncStatus value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'syncStatus',
        value: value,
      ));
    });
  }

  QueryBuilder<CardDetails, CardDetails, QAfterFilterCondition>
      syncStatusBetween(
    SyncStatus lower,
    SyncStatus upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'syncStatus',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CardDetails, CardDetails, QAfterFilterCondition> titleEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CardDetails, CardDetails, QAfterFilterCondition>
      titleGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CardDetails, CardDetails, QAfterFilterCondition> titleLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CardDetails, CardDetails, QAfterFilterCondition> titleBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'title',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CardDetails, CardDetails, QAfterFilterCondition> titleStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CardDetails, CardDetails, QAfterFilterCondition> titleEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CardDetails, CardDetails, QAfterFilterCondition> titleContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CardDetails, CardDetails, QAfterFilterCondition> titleMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'title',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CardDetails, CardDetails, QAfterFilterCondition> titleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'title',
        value: '',
      ));
    });
  }

  QueryBuilder<CardDetails, CardDetails, QAfterFilterCondition>
      titleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'title',
        value: '',
      ));
    });
  }
}

extension CardDetailsQueryObject
    on QueryBuilder<CardDetails, CardDetails, QFilterCondition> {}

extension CardDetailsQueryLinks
    on QueryBuilder<CardDetails, CardDetails, QFilterCondition> {}

extension CardDetailsQuerySortBy
    on QueryBuilder<CardDetails, CardDetails, QSortBy> {
  QueryBuilder<CardDetails, CardDetails, QAfterSortBy> sortByCardHolderName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cardHolderName', Sort.asc);
    });
  }

  QueryBuilder<CardDetails, CardDetails, QAfterSortBy>
      sortByCardHolderNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cardHolderName', Sort.desc);
    });
  }

  QueryBuilder<CardDetails, CardDetails, QAfterSortBy> sortByCardNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cardNumber', Sort.asc);
    });
  }

  QueryBuilder<CardDetails, CardDetails, QAfterSortBy> sortByCardNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cardNumber', Sort.desc);
    });
  }

  QueryBuilder<CardDetails, CardDetails, QAfterSortBy> sortByCvv() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cvv', Sort.asc);
    });
  }

  QueryBuilder<CardDetails, CardDetails, QAfterSortBy> sortByCvvDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cvv', Sort.desc);
    });
  }

  QueryBuilder<CardDetails, CardDetails, QAfterSortBy> sortByDataType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dataType', Sort.asc);
    });
  }

  QueryBuilder<CardDetails, CardDetails, QAfterSortBy> sortByDataTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dataType', Sort.desc);
    });
  }

  QueryBuilder<CardDetails, CardDetails, QAfterSortBy> sortByDateAdded() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateAdded', Sort.asc);
    });
  }

  QueryBuilder<CardDetails, CardDetails, QAfterSortBy> sortByDateAddedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateAdded', Sort.desc);
    });
  }

  QueryBuilder<CardDetails, CardDetails, QAfterSortBy> sortByExpirationDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expirationDate', Sort.asc);
    });
  }

  QueryBuilder<CardDetails, CardDetails, QAfterSortBy>
      sortByExpirationDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expirationDate', Sort.desc);
    });
  }

  QueryBuilder<CardDetails, CardDetails, QAfterSortBy> sortByHashCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hashCode', Sort.asc);
    });
  }

  QueryBuilder<CardDetails, CardDetails, QAfterSortBy> sortByHashCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hashCode', Sort.desc);
    });
  }

  QueryBuilder<CardDetails, CardDetails, QAfterSortBy> sortByNonce() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nonce', Sort.asc);
    });
  }

  QueryBuilder<CardDetails, CardDetails, QAfterSortBy> sortByNonceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nonce', Sort.desc);
    });
  }

  QueryBuilder<CardDetails, CardDetails, QAfterSortBy> sortBySyncStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncStatus', Sort.asc);
    });
  }

  QueryBuilder<CardDetails, CardDetails, QAfterSortBy> sortBySyncStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncStatus', Sort.desc);
    });
  }

  QueryBuilder<CardDetails, CardDetails, QAfterSortBy> sortByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<CardDetails, CardDetails, QAfterSortBy> sortByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }
}

extension CardDetailsQuerySortThenBy
    on QueryBuilder<CardDetails, CardDetails, QSortThenBy> {
  QueryBuilder<CardDetails, CardDetails, QAfterSortBy> thenByCardHolderName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cardHolderName', Sort.asc);
    });
  }

  QueryBuilder<CardDetails, CardDetails, QAfterSortBy>
      thenByCardHolderNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cardHolderName', Sort.desc);
    });
  }

  QueryBuilder<CardDetails, CardDetails, QAfterSortBy> thenByCardNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cardNumber', Sort.asc);
    });
  }

  QueryBuilder<CardDetails, CardDetails, QAfterSortBy> thenByCardNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cardNumber', Sort.desc);
    });
  }

  QueryBuilder<CardDetails, CardDetails, QAfterSortBy> thenByCvv() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cvv', Sort.asc);
    });
  }

  QueryBuilder<CardDetails, CardDetails, QAfterSortBy> thenByCvvDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cvv', Sort.desc);
    });
  }

  QueryBuilder<CardDetails, CardDetails, QAfterSortBy> thenByDataType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dataType', Sort.asc);
    });
  }

  QueryBuilder<CardDetails, CardDetails, QAfterSortBy> thenByDataTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dataType', Sort.desc);
    });
  }

  QueryBuilder<CardDetails, CardDetails, QAfterSortBy> thenByDateAdded() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateAdded', Sort.asc);
    });
  }

  QueryBuilder<CardDetails, CardDetails, QAfterSortBy> thenByDateAddedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateAdded', Sort.desc);
    });
  }

  QueryBuilder<CardDetails, CardDetails, QAfterSortBy> thenByExpirationDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expirationDate', Sort.asc);
    });
  }

  QueryBuilder<CardDetails, CardDetails, QAfterSortBy>
      thenByExpirationDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expirationDate', Sort.desc);
    });
  }

  QueryBuilder<CardDetails, CardDetails, QAfterSortBy> thenByHashCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hashCode', Sort.asc);
    });
  }

  QueryBuilder<CardDetails, CardDetails, QAfterSortBy> thenByHashCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hashCode', Sort.desc);
    });
  }

  QueryBuilder<CardDetails, CardDetails, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<CardDetails, CardDetails, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<CardDetails, CardDetails, QAfterSortBy> thenByNonce() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nonce', Sort.asc);
    });
  }

  QueryBuilder<CardDetails, CardDetails, QAfterSortBy> thenByNonceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nonce', Sort.desc);
    });
  }

  QueryBuilder<CardDetails, CardDetails, QAfterSortBy> thenBySyncStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncStatus', Sort.asc);
    });
  }

  QueryBuilder<CardDetails, CardDetails, QAfterSortBy> thenBySyncStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncStatus', Sort.desc);
    });
  }

  QueryBuilder<CardDetails, CardDetails, QAfterSortBy> thenByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<CardDetails, CardDetails, QAfterSortBy> thenByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }
}

extension CardDetailsQueryWhereDistinct
    on QueryBuilder<CardDetails, CardDetails, QDistinct> {
  QueryBuilder<CardDetails, CardDetails, QDistinct> distinctByCardHolderName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'cardHolderName',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CardDetails, CardDetails, QDistinct> distinctByCardNumber(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'cardNumber', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CardDetails, CardDetails, QDistinct> distinctByCvv(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'cvv', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CardDetails, CardDetails, QDistinct> distinctByDataType() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dataType');
    });
  }

  QueryBuilder<CardDetails, CardDetails, QDistinct> distinctByDateAdded() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dateAdded');
    });
  }

  QueryBuilder<CardDetails, CardDetails, QDistinct> distinctByExpirationDate(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'expirationDate',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CardDetails, CardDetails, QDistinct> distinctByHashCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'hashCode');
    });
  }

  QueryBuilder<CardDetails, CardDetails, QDistinct> distinctByNonce(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'nonce', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CardDetails, CardDetails, QDistinct> distinctBySyncStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'syncStatus');
    });
  }

  QueryBuilder<CardDetails, CardDetails, QDistinct> distinctByTitle(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'title', caseSensitive: caseSensitive);
    });
  }
}

extension CardDetailsQueryProperty
    on QueryBuilder<CardDetails, CardDetails, QQueryProperty> {
  QueryBuilder<CardDetails, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<CardDetails, String, QQueryOperations> cardHolderNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'cardHolderName');
    });
  }

  QueryBuilder<CardDetails, String, QQueryOperations> cardNumberProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'cardNumber');
    });
  }

  QueryBuilder<CardDetails, String, QQueryOperations> cvvProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'cvv');
    });
  }

  QueryBuilder<CardDetails, DataType, QQueryOperations> dataTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dataType');
    });
  }

  QueryBuilder<CardDetails, DateTime, QQueryOperations> dateAddedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dateAdded');
    });
  }

  QueryBuilder<CardDetails, String, QQueryOperations> expirationDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'expirationDate');
    });
  }

  QueryBuilder<CardDetails, int, QQueryOperations> hashCodeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'hashCode');
    });
  }

  QueryBuilder<CardDetails, String, QQueryOperations> nonceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'nonce');
    });
  }

  QueryBuilder<CardDetails, SyncStatus, QQueryOperations> syncStatusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'syncStatus');
    });
  }

  QueryBuilder<CardDetails, String, QQueryOperations> titleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'title');
    });
  }
}
