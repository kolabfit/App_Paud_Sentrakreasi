// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_session_collection.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetLocalSessionEntityCollection on Isar {
  IsarCollection<LocalSessionEntity> get localSessionEntitys =>
      this.collection();
}

final LocalSessionEntitySchema = CollectionSchema(
  name: r'LocalSessionEntity',
  id: int.parse('-6232920299758717415'),
  properties: {
    r'currentUsername': PropertySchema(
      id: 0,
      name: r'currentUsername',
      type: IsarType.string,
    ),
    r'dataVersion': PropertySchema(
      id: 1,
      name: r'dataVersion',
      type: IsarType.long,
    ),
    r'updatedAt': PropertySchema(
      id: 2,
      name: r'updatedAt',
      type: IsarType.dateTime,
    ),
  },
  estimateSize: _localSessionEntityEstimateSize,
  serialize: _localSessionEntitySerialize,
  deserialize: _localSessionEntityDeserialize,
  deserializeProp: _localSessionEntityDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _localSessionEntityGetId,
  getLinks: _localSessionEntityGetLinks,
  attach: _localSessionEntityAttach,
  version: '3.1.0+1',
);

int _localSessionEntityEstimateSize(
  LocalSessionEntity object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.currentUsername;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _localSessionEntitySerialize(
  LocalSessionEntity object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.currentUsername);
  writer.writeLong(offsets[1], object.dataVersion);
  writer.writeDateTime(offsets[2], object.updatedAt);
}

LocalSessionEntity _localSessionEntityDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = LocalSessionEntity();
  object.currentUsername = reader.readStringOrNull(offsets[0]);
  object.dataVersion = reader.readLong(offsets[1]);
  object.id = id;
  object.updatedAt = reader.readDateTime(offsets[2]);
  return object;
}

P _localSessionEntityDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _localSessionEntityGetId(LocalSessionEntity object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _localSessionEntityGetLinks(
  LocalSessionEntity object,
) {
  return [];
}

void _localSessionEntityAttach(
  IsarCollection<dynamic> col,
  Id id,
  LocalSessionEntity object,
) {
  object.id = id;
}

extension LocalSessionEntityQueryWhereSort
    on QueryBuilder<LocalSessionEntity, LocalSessionEntity, QWhere> {
  QueryBuilder<LocalSessionEntity, LocalSessionEntity, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension LocalSessionEntityQueryWhere
    on QueryBuilder<LocalSessionEntity, LocalSessionEntity, QWhereClause> {
  QueryBuilder<LocalSessionEntity, LocalSessionEntity, QAfterWhereClause>
  idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<LocalSessionEntity, LocalSessionEntity, QAfterWhereClause>
  idNotEqualTo(Id id) {
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

  QueryBuilder<LocalSessionEntity, LocalSessionEntity, QAfterWhereClause>
  idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<LocalSessionEntity, LocalSessionEntity, QAfterWhereClause>
  idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<LocalSessionEntity, LocalSessionEntity, QAfterWhereClause>
  idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.between(
          lower: lowerId,
          includeLower: includeLower,
          upper: upperId,
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension LocalSessionEntityQueryFilter
    on QueryBuilder<LocalSessionEntity, LocalSessionEntity, QFilterCondition> {
  QueryBuilder<LocalSessionEntity, LocalSessionEntity, QAfterFilterCondition>
  currentUsernameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'currentUsername'),
      );
    });
  }

  QueryBuilder<LocalSessionEntity, LocalSessionEntity, QAfterFilterCondition>
  currentUsernameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'currentUsername'),
      );
    });
  }

  QueryBuilder<LocalSessionEntity, LocalSessionEntity, QAfterFilterCondition>
  currentUsernameEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'currentUsername',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LocalSessionEntity, LocalSessionEntity, QAfterFilterCondition>
  currentUsernameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'currentUsername',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LocalSessionEntity, LocalSessionEntity, QAfterFilterCondition>
  currentUsernameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'currentUsername',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LocalSessionEntity, LocalSessionEntity, QAfterFilterCondition>
  currentUsernameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'currentUsername',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LocalSessionEntity, LocalSessionEntity, QAfterFilterCondition>
  currentUsernameStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'currentUsername',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LocalSessionEntity, LocalSessionEntity, QAfterFilterCondition>
  currentUsernameEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'currentUsername',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LocalSessionEntity, LocalSessionEntity, QAfterFilterCondition>
  currentUsernameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'currentUsername',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LocalSessionEntity, LocalSessionEntity, QAfterFilterCondition>
  currentUsernameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'currentUsername',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<LocalSessionEntity, LocalSessionEntity, QAfterFilterCondition>
  currentUsernameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'currentUsername', value: ''),
      );
    });
  }

  QueryBuilder<LocalSessionEntity, LocalSessionEntity, QAfterFilterCondition>
  currentUsernameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'currentUsername', value: ''),
      );
    });
  }

  QueryBuilder<LocalSessionEntity, LocalSessionEntity, QAfterFilterCondition>
  dataVersionEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'dataVersion', value: value),
      );
    });
  }

  QueryBuilder<LocalSessionEntity, LocalSessionEntity, QAfterFilterCondition>
  dataVersionGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'dataVersion',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<LocalSessionEntity, LocalSessionEntity, QAfterFilterCondition>
  dataVersionLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'dataVersion',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<LocalSessionEntity, LocalSessionEntity, QAfterFilterCondition>
  dataVersionBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'dataVersion',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<LocalSessionEntity, LocalSessionEntity, QAfterFilterCondition>
  idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<LocalSessionEntity, LocalSessionEntity, QAfterFilterCondition>
  idGreaterThan(Id value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<LocalSessionEntity, LocalSessionEntity, QAfterFilterCondition>
  idLessThan(Id value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<LocalSessionEntity, LocalSessionEntity, QAfterFilterCondition>
  idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'id',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<LocalSessionEntity, LocalSessionEntity, QAfterFilterCondition>
  updatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'updatedAt', value: value),
      );
    });
  }

  QueryBuilder<LocalSessionEntity, LocalSessionEntity, QAfterFilterCondition>
  updatedAtGreaterThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'updatedAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<LocalSessionEntity, LocalSessionEntity, QAfterFilterCondition>
  updatedAtLessThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'updatedAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<LocalSessionEntity, LocalSessionEntity, QAfterFilterCondition>
  updatedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'updatedAt',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension LocalSessionEntityQueryObject
    on QueryBuilder<LocalSessionEntity, LocalSessionEntity, QFilterCondition> {}

extension LocalSessionEntityQueryLinks
    on QueryBuilder<LocalSessionEntity, LocalSessionEntity, QFilterCondition> {}

extension LocalSessionEntityQuerySortBy
    on QueryBuilder<LocalSessionEntity, LocalSessionEntity, QSortBy> {
  QueryBuilder<LocalSessionEntity, LocalSessionEntity, QAfterSortBy>
  sortByCurrentUsername() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentUsername', Sort.asc);
    });
  }

  QueryBuilder<LocalSessionEntity, LocalSessionEntity, QAfterSortBy>
  sortByCurrentUsernameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentUsername', Sort.desc);
    });
  }

  QueryBuilder<LocalSessionEntity, LocalSessionEntity, QAfterSortBy>
  sortByDataVersion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dataVersion', Sort.asc);
    });
  }

  QueryBuilder<LocalSessionEntity, LocalSessionEntity, QAfterSortBy>
  sortByDataVersionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dataVersion', Sort.desc);
    });
  }

  QueryBuilder<LocalSessionEntity, LocalSessionEntity, QAfterSortBy>
  sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<LocalSessionEntity, LocalSessionEntity, QAfterSortBy>
  sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension LocalSessionEntityQuerySortThenBy
    on QueryBuilder<LocalSessionEntity, LocalSessionEntity, QSortThenBy> {
  QueryBuilder<LocalSessionEntity, LocalSessionEntity, QAfterSortBy>
  thenByCurrentUsername() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentUsername', Sort.asc);
    });
  }

  QueryBuilder<LocalSessionEntity, LocalSessionEntity, QAfterSortBy>
  thenByCurrentUsernameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentUsername', Sort.desc);
    });
  }

  QueryBuilder<LocalSessionEntity, LocalSessionEntity, QAfterSortBy>
  thenByDataVersion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dataVersion', Sort.asc);
    });
  }

  QueryBuilder<LocalSessionEntity, LocalSessionEntity, QAfterSortBy>
  thenByDataVersionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dataVersion', Sort.desc);
    });
  }

  QueryBuilder<LocalSessionEntity, LocalSessionEntity, QAfterSortBy>
  thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<LocalSessionEntity, LocalSessionEntity, QAfterSortBy>
  thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<LocalSessionEntity, LocalSessionEntity, QAfterSortBy>
  thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<LocalSessionEntity, LocalSessionEntity, QAfterSortBy>
  thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension LocalSessionEntityQueryWhereDistinct
    on QueryBuilder<LocalSessionEntity, LocalSessionEntity, QDistinct> {
  QueryBuilder<LocalSessionEntity, LocalSessionEntity, QDistinct>
  distinctByCurrentUsername({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'currentUsername',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<LocalSessionEntity, LocalSessionEntity, QDistinct>
  distinctByDataVersion() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dataVersion');
    });
  }

  QueryBuilder<LocalSessionEntity, LocalSessionEntity, QDistinct>
  distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }
}

extension LocalSessionEntityQueryProperty
    on QueryBuilder<LocalSessionEntity, LocalSessionEntity, QQueryProperty> {
  QueryBuilder<LocalSessionEntity, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<LocalSessionEntity, String?, QQueryOperations>
  currentUsernameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'currentUsername');
    });
  }

  QueryBuilder<LocalSessionEntity, int, QQueryOperations>
  dataVersionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dataVersion');
    });
  }

  QueryBuilder<LocalSessionEntity, DateTime, QQueryOperations>
  updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }
}
