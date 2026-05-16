// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'learning_progress_collection.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetLearningProgressEntityCollection on Isar {
  IsarCollection<LearningProgressEntity> get learningProgressEntitys =>
      this.collection();
}

final LearningProgressEntitySchema = CollectionSchema(
  name: r'LearningProgressEntity',
  id: int.parse('-226150867204275572'),
  properties: {
    r'category': PropertySchema(
      id: 0,
      name: r'category',
      type: IsarType.string,
    ),
    r'completedItems': PropertySchema(
      id: 1,
      name: r'completedItems',
      type: IsarType.long,
    ),
    r'completedKeys': PropertySchema(
      id: 2,
      name: r'completedKeys',
      type: IsarType.stringList,
    ),
    r'ownerUsername': PropertySchema(
      id: 3,
      name: r'ownerUsername',
      type: IsarType.string,
    ),
    r'progressPercent': PropertySchema(
      id: 4,
      name: r'progressPercent',
      type: IsarType.long,
    ),
    r'totalItems': PropertySchema(
      id: 5,
      name: r'totalItems',
      type: IsarType.long,
    ),
    r'updatedAt': PropertySchema(
      id: 6,
      name: r'updatedAt',
      type: IsarType.dateTime,
    ),
  },
  estimateSize: _learningProgressEntityEstimateSize,
  serialize: _learningProgressEntitySerialize,
  deserialize: _learningProgressEntityDeserialize,
  deserializeProp: _learningProgressEntityDeserializeProp,
  idName: r'id',
  indexes: {
    r'ownerUsername_category': IndexSchema(
      id: int.parse('7870599218042869831'),
      name: r'ownerUsername_category',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'ownerUsername',
          type: IndexType.hash,
          caseSensitive: true,
        ),
        IndexPropertySchema(
          name: r'category',
          type: IndexType.hash,
          caseSensitive: true,
        ),
      ],
    ),
  },
  links: {},
  embeddedSchemas: {},
  getId: _learningProgressEntityGetId,
  getLinks: _learningProgressEntityGetLinks,
  attach: _learningProgressEntityAttach,
  version: '3.1.0+1',
);

int _learningProgressEntityEstimateSize(
  LearningProgressEntity object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.category.length * 3;
  bytesCount += 3 + object.completedKeys.length * 3;
  {
    for (var i = 0; i < object.completedKeys.length; i++) {
      final value = object.completedKeys[i];
      bytesCount += value.length * 3;
    }
  }
  bytesCount += 3 + object.ownerUsername.length * 3;
  return bytesCount;
}

void _learningProgressEntitySerialize(
  LearningProgressEntity object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.category);
  writer.writeLong(offsets[1], object.completedItems);
  writer.writeStringList(offsets[2], object.completedKeys);
  writer.writeString(offsets[3], object.ownerUsername);
  writer.writeLong(offsets[4], object.progressPercent);
  writer.writeLong(offsets[5], object.totalItems);
  writer.writeDateTime(offsets[6], object.updatedAt);
}

LearningProgressEntity _learningProgressEntityDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = LearningProgressEntity();
  object.category = reader.readString(offsets[0]);
  object.completedItems = reader.readLong(offsets[1]);
  object.completedKeys = reader.readStringList(offsets[2]) ?? [];
  object.id = id;
  object.ownerUsername = reader.readString(offsets[3]);
  object.progressPercent = reader.readLong(offsets[4]);
  object.totalItems = reader.readLong(offsets[5]);
  object.updatedAt = reader.readDateTime(offsets[6]);
  return object;
}

P _learningProgressEntityDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readStringList(offset) ?? []) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readLong(offset)) as P;
    case 5:
      return (reader.readLong(offset)) as P;
    case 6:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _learningProgressEntityGetId(LearningProgressEntity object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _learningProgressEntityGetLinks(
  LearningProgressEntity object,
) {
  return [];
}

void _learningProgressEntityAttach(
  IsarCollection<dynamic> col,
  Id id,
  LearningProgressEntity object,
) {
  object.id = id;
}

extension LearningProgressEntityByIndex
    on IsarCollection<LearningProgressEntity> {
  Future<LearningProgressEntity?> getByOwnerUsernameCategory(
    String ownerUsername,
    String category,
  ) {
    return getByIndex(r'ownerUsername_category', [ownerUsername, category]);
  }

  LearningProgressEntity? getByOwnerUsernameCategorySync(
    String ownerUsername,
    String category,
  ) {
    return getByIndexSync(r'ownerUsername_category', [ownerUsername, category]);
  }

  Future<bool> deleteByOwnerUsernameCategory(
    String ownerUsername,
    String category,
  ) {
    return deleteByIndex(r'ownerUsername_category', [ownerUsername, category]);
  }

  bool deleteByOwnerUsernameCategorySync(
    String ownerUsername,
    String category,
  ) {
    return deleteByIndexSync(r'ownerUsername_category', [
      ownerUsername,
      category,
    ]);
  }

  Future<List<LearningProgressEntity?>> getAllByOwnerUsernameCategory(
    List<String> ownerUsernameValues,
    List<String> categoryValues,
  ) {
    final len = ownerUsernameValues.length;
    assert(
      categoryValues.length == len,
      'All index values must have the same length',
    );
    final values = <List<dynamic>>[];
    for (var i = 0; i < len; i++) {
      values.add([ownerUsernameValues[i], categoryValues[i]]);
    }

    return getAllByIndex(r'ownerUsername_category', values);
  }

  List<LearningProgressEntity?> getAllByOwnerUsernameCategorySync(
    List<String> ownerUsernameValues,
    List<String> categoryValues,
  ) {
    final len = ownerUsernameValues.length;
    assert(
      categoryValues.length == len,
      'All index values must have the same length',
    );
    final values = <List<dynamic>>[];
    for (var i = 0; i < len; i++) {
      values.add([ownerUsernameValues[i], categoryValues[i]]);
    }

    return getAllByIndexSync(r'ownerUsername_category', values);
  }

  Future<int> deleteAllByOwnerUsernameCategory(
    List<String> ownerUsernameValues,
    List<String> categoryValues,
  ) {
    final len = ownerUsernameValues.length;
    assert(
      categoryValues.length == len,
      'All index values must have the same length',
    );
    final values = <List<dynamic>>[];
    for (var i = 0; i < len; i++) {
      values.add([ownerUsernameValues[i], categoryValues[i]]);
    }

    return deleteAllByIndex(r'ownerUsername_category', values);
  }

  int deleteAllByOwnerUsernameCategorySync(
    List<String> ownerUsernameValues,
    List<String> categoryValues,
  ) {
    final len = ownerUsernameValues.length;
    assert(
      categoryValues.length == len,
      'All index values must have the same length',
    );
    final values = <List<dynamic>>[];
    for (var i = 0; i < len; i++) {
      values.add([ownerUsernameValues[i], categoryValues[i]]);
    }

    return deleteAllByIndexSync(r'ownerUsername_category', values);
  }

  Future<Id> putByOwnerUsernameCategory(LearningProgressEntity object) {
    return putByIndex(r'ownerUsername_category', object);
  }

  Id putByOwnerUsernameCategorySync(
    LearningProgressEntity object, {
    bool saveLinks = true,
  }) {
    return putByIndexSync(
      r'ownerUsername_category',
      object,
      saveLinks: saveLinks,
    );
  }

  Future<List<Id>> putAllByOwnerUsernameCategory(
    List<LearningProgressEntity> objects,
  ) {
    return putAllByIndex(r'ownerUsername_category', objects);
  }

  List<Id> putAllByOwnerUsernameCategorySync(
    List<LearningProgressEntity> objects, {
    bool saveLinks = true,
  }) {
    return putAllByIndexSync(
      r'ownerUsername_category',
      objects,
      saveLinks: saveLinks,
    );
  }
}

extension LearningProgressEntityQueryWhereSort
    on QueryBuilder<LearningProgressEntity, LearningProgressEntity, QWhere> {
  QueryBuilder<LearningProgressEntity, LearningProgressEntity, QAfterWhere>
  anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension LearningProgressEntityQueryWhere
    on
        QueryBuilder<
          LearningProgressEntity,
          LearningProgressEntity,
          QWhereClause
        > {
  QueryBuilder<
    LearningProgressEntity,
    LearningProgressEntity,
    QAfterWhereClause
  >
  idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<
    LearningProgressEntity,
    LearningProgressEntity,
    QAfterWhereClause
  >
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

  QueryBuilder<
    LearningProgressEntity,
    LearningProgressEntity,
    QAfterWhereClause
  >
  idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<
    LearningProgressEntity,
    LearningProgressEntity,
    QAfterWhereClause
  >
  idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<
    LearningProgressEntity,
    LearningProgressEntity,
    QAfterWhereClause
  >
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

  QueryBuilder<
    LearningProgressEntity,
    LearningProgressEntity,
    QAfterWhereClause
  >
  ownerUsernameEqualToAnyCategory(String ownerUsername) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(
          indexName: r'ownerUsername_category',
          value: [ownerUsername],
        ),
      );
    });
  }

  QueryBuilder<
    LearningProgressEntity,
    LearningProgressEntity,
    QAfterWhereClause
  >
  ownerUsernameNotEqualToAnyCategory(String ownerUsername) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'ownerUsername_category',
                lower: [],
                upper: [ownerUsername],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'ownerUsername_category',
                lower: [ownerUsername],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'ownerUsername_category',
                lower: [ownerUsername],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'ownerUsername_category',
                lower: [],
                upper: [ownerUsername],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<
    LearningProgressEntity,
    LearningProgressEntity,
    QAfterWhereClause
  >
  ownerUsernameCategoryEqualTo(String ownerUsername, String category) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(
          indexName: r'ownerUsername_category',
          value: [ownerUsername, category],
        ),
      );
    });
  }

  QueryBuilder<
    LearningProgressEntity,
    LearningProgressEntity,
    QAfterWhereClause
  >
  ownerUsernameEqualToCategoryNotEqualTo(
    String ownerUsername,
    String category,
  ) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'ownerUsername_category',
                lower: [ownerUsername],
                upper: [ownerUsername, category],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'ownerUsername_category',
                lower: [ownerUsername, category],
                includeLower: false,
                upper: [ownerUsername],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'ownerUsername_category',
                lower: [ownerUsername, category],
                includeLower: false,
                upper: [ownerUsername],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'ownerUsername_category',
                lower: [ownerUsername],
                upper: [ownerUsername, category],
                includeUpper: false,
              ),
            );
      }
    });
  }
}

extension LearningProgressEntityQueryFilter
    on
        QueryBuilder<
          LearningProgressEntity,
          LearningProgressEntity,
          QFilterCondition
        > {
  QueryBuilder<
    LearningProgressEntity,
    LearningProgressEntity,
    QAfterFilterCondition
  >
  categoryEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'category',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    LearningProgressEntity,
    LearningProgressEntity,
    QAfterFilterCondition
  >
  categoryGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'category',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    LearningProgressEntity,
    LearningProgressEntity,
    QAfterFilterCondition
  >
  categoryLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'category',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    LearningProgressEntity,
    LearningProgressEntity,
    QAfterFilterCondition
  >
  categoryBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'category',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    LearningProgressEntity,
    LearningProgressEntity,
    QAfterFilterCondition
  >
  categoryStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'category',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    LearningProgressEntity,
    LearningProgressEntity,
    QAfterFilterCondition
  >
  categoryEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'category',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    LearningProgressEntity,
    LearningProgressEntity,
    QAfterFilterCondition
  >
  categoryContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'category',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    LearningProgressEntity,
    LearningProgressEntity,
    QAfterFilterCondition
  >
  categoryMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'category',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    LearningProgressEntity,
    LearningProgressEntity,
    QAfterFilterCondition
  >
  categoryIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'category', value: ''),
      );
    });
  }

  QueryBuilder<
    LearningProgressEntity,
    LearningProgressEntity,
    QAfterFilterCondition
  >
  categoryIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'category', value: ''),
      );
    });
  }

  QueryBuilder<
    LearningProgressEntity,
    LearningProgressEntity,
    QAfterFilterCondition
  >
  completedItemsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'completedItems', value: value),
      );
    });
  }

  QueryBuilder<
    LearningProgressEntity,
    LearningProgressEntity,
    QAfterFilterCondition
  >
  completedItemsGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'completedItems',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    LearningProgressEntity,
    LearningProgressEntity,
    QAfterFilterCondition
  >
  completedItemsLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'completedItems',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    LearningProgressEntity,
    LearningProgressEntity,
    QAfterFilterCondition
  >
  completedItemsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'completedItems',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    LearningProgressEntity,
    LearningProgressEntity,
    QAfterFilterCondition
  >
  completedKeysElementEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'completedKeys',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    LearningProgressEntity,
    LearningProgressEntity,
    QAfterFilterCondition
  >
  completedKeysElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'completedKeys',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    LearningProgressEntity,
    LearningProgressEntity,
    QAfterFilterCondition
  >
  completedKeysElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'completedKeys',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    LearningProgressEntity,
    LearningProgressEntity,
    QAfterFilterCondition
  >
  completedKeysElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'completedKeys',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    LearningProgressEntity,
    LearningProgressEntity,
    QAfterFilterCondition
  >
  completedKeysElementStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'completedKeys',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    LearningProgressEntity,
    LearningProgressEntity,
    QAfterFilterCondition
  >
  completedKeysElementEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'completedKeys',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    LearningProgressEntity,
    LearningProgressEntity,
    QAfterFilterCondition
  >
  completedKeysElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'completedKeys',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    LearningProgressEntity,
    LearningProgressEntity,
    QAfterFilterCondition
  >
  completedKeysElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'completedKeys',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    LearningProgressEntity,
    LearningProgressEntity,
    QAfterFilterCondition
  >
  completedKeysElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'completedKeys', value: ''),
      );
    });
  }

  QueryBuilder<
    LearningProgressEntity,
    LearningProgressEntity,
    QAfterFilterCondition
  >
  completedKeysElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'completedKeys', value: ''),
      );
    });
  }

  QueryBuilder<
    LearningProgressEntity,
    LearningProgressEntity,
    QAfterFilterCondition
  >
  completedKeysLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'completedKeys', length, true, length, true);
    });
  }

  QueryBuilder<
    LearningProgressEntity,
    LearningProgressEntity,
    QAfterFilterCondition
  >
  completedKeysIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'completedKeys', 0, true, 0, true);
    });
  }

  QueryBuilder<
    LearningProgressEntity,
    LearningProgressEntity,
    QAfterFilterCondition
  >
  completedKeysIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'completedKeys', 0, false, 999999, true);
    });
  }

  QueryBuilder<
    LearningProgressEntity,
    LearningProgressEntity,
    QAfterFilterCondition
  >
  completedKeysLengthLessThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'completedKeys', 0, true, length, include);
    });
  }

  QueryBuilder<
    LearningProgressEntity,
    LearningProgressEntity,
    QAfterFilterCondition
  >
  completedKeysLengthGreaterThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'completedKeys', length, include, 999999, true);
    });
  }

  QueryBuilder<
    LearningProgressEntity,
    LearningProgressEntity,
    QAfterFilterCondition
  >
  completedKeysLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'completedKeys',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<
    LearningProgressEntity,
    LearningProgressEntity,
    QAfterFilterCondition
  >
  idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<
    LearningProgressEntity,
    LearningProgressEntity,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    LearningProgressEntity,
    LearningProgressEntity,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    LearningProgressEntity,
    LearningProgressEntity,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    LearningProgressEntity,
    LearningProgressEntity,
    QAfterFilterCondition
  >
  ownerUsernameEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'ownerUsername',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    LearningProgressEntity,
    LearningProgressEntity,
    QAfterFilterCondition
  >
  ownerUsernameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'ownerUsername',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    LearningProgressEntity,
    LearningProgressEntity,
    QAfterFilterCondition
  >
  ownerUsernameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'ownerUsername',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    LearningProgressEntity,
    LearningProgressEntity,
    QAfterFilterCondition
  >
  ownerUsernameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'ownerUsername',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    LearningProgressEntity,
    LearningProgressEntity,
    QAfterFilterCondition
  >
  ownerUsernameStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'ownerUsername',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    LearningProgressEntity,
    LearningProgressEntity,
    QAfterFilterCondition
  >
  ownerUsernameEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'ownerUsername',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    LearningProgressEntity,
    LearningProgressEntity,
    QAfterFilterCondition
  >
  ownerUsernameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'ownerUsername',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    LearningProgressEntity,
    LearningProgressEntity,
    QAfterFilterCondition
  >
  ownerUsernameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'ownerUsername',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    LearningProgressEntity,
    LearningProgressEntity,
    QAfterFilterCondition
  >
  ownerUsernameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'ownerUsername', value: ''),
      );
    });
  }

  QueryBuilder<
    LearningProgressEntity,
    LearningProgressEntity,
    QAfterFilterCondition
  >
  ownerUsernameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'ownerUsername', value: ''),
      );
    });
  }

  QueryBuilder<
    LearningProgressEntity,
    LearningProgressEntity,
    QAfterFilterCondition
  >
  progressPercentEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'progressPercent', value: value),
      );
    });
  }

  QueryBuilder<
    LearningProgressEntity,
    LearningProgressEntity,
    QAfterFilterCondition
  >
  progressPercentGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'progressPercent',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    LearningProgressEntity,
    LearningProgressEntity,
    QAfterFilterCondition
  >
  progressPercentLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'progressPercent',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    LearningProgressEntity,
    LearningProgressEntity,
    QAfterFilterCondition
  >
  progressPercentBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'progressPercent',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    LearningProgressEntity,
    LearningProgressEntity,
    QAfterFilterCondition
  >
  totalItemsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'totalItems', value: value),
      );
    });
  }

  QueryBuilder<
    LearningProgressEntity,
    LearningProgressEntity,
    QAfterFilterCondition
  >
  totalItemsGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'totalItems',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    LearningProgressEntity,
    LearningProgressEntity,
    QAfterFilterCondition
  >
  totalItemsLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'totalItems',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    LearningProgressEntity,
    LearningProgressEntity,
    QAfterFilterCondition
  >
  totalItemsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'totalItems',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    LearningProgressEntity,
    LearningProgressEntity,
    QAfterFilterCondition
  >
  updatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'updatedAt', value: value),
      );
    });
  }

  QueryBuilder<
    LearningProgressEntity,
    LearningProgressEntity,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    LearningProgressEntity,
    LearningProgressEntity,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    LearningProgressEntity,
    LearningProgressEntity,
    QAfterFilterCondition
  >
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

extension LearningProgressEntityQueryObject
    on
        QueryBuilder<
          LearningProgressEntity,
          LearningProgressEntity,
          QFilterCondition
        > {}

extension LearningProgressEntityQueryLinks
    on
        QueryBuilder<
          LearningProgressEntity,
          LearningProgressEntity,
          QFilterCondition
        > {}

extension LearningProgressEntityQuerySortBy
    on QueryBuilder<LearningProgressEntity, LearningProgressEntity, QSortBy> {
  QueryBuilder<LearningProgressEntity, LearningProgressEntity, QAfterSortBy>
  sortByCategory() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'category', Sort.asc);
    });
  }

  QueryBuilder<LearningProgressEntity, LearningProgressEntity, QAfterSortBy>
  sortByCategoryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'category', Sort.desc);
    });
  }

  QueryBuilder<LearningProgressEntity, LearningProgressEntity, QAfterSortBy>
  sortByCompletedItems() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedItems', Sort.asc);
    });
  }

  QueryBuilder<LearningProgressEntity, LearningProgressEntity, QAfterSortBy>
  sortByCompletedItemsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedItems', Sort.desc);
    });
  }

  QueryBuilder<LearningProgressEntity, LearningProgressEntity, QAfterSortBy>
  sortByOwnerUsername() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ownerUsername', Sort.asc);
    });
  }

  QueryBuilder<LearningProgressEntity, LearningProgressEntity, QAfterSortBy>
  sortByOwnerUsernameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ownerUsername', Sort.desc);
    });
  }

  QueryBuilder<LearningProgressEntity, LearningProgressEntity, QAfterSortBy>
  sortByProgressPercent() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'progressPercent', Sort.asc);
    });
  }

  QueryBuilder<LearningProgressEntity, LearningProgressEntity, QAfterSortBy>
  sortByProgressPercentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'progressPercent', Sort.desc);
    });
  }

  QueryBuilder<LearningProgressEntity, LearningProgressEntity, QAfterSortBy>
  sortByTotalItems() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalItems', Sort.asc);
    });
  }

  QueryBuilder<LearningProgressEntity, LearningProgressEntity, QAfterSortBy>
  sortByTotalItemsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalItems', Sort.desc);
    });
  }

  QueryBuilder<LearningProgressEntity, LearningProgressEntity, QAfterSortBy>
  sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<LearningProgressEntity, LearningProgressEntity, QAfterSortBy>
  sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension LearningProgressEntityQuerySortThenBy
    on
        QueryBuilder<
          LearningProgressEntity,
          LearningProgressEntity,
          QSortThenBy
        > {
  QueryBuilder<LearningProgressEntity, LearningProgressEntity, QAfterSortBy>
  thenByCategory() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'category', Sort.asc);
    });
  }

  QueryBuilder<LearningProgressEntity, LearningProgressEntity, QAfterSortBy>
  thenByCategoryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'category', Sort.desc);
    });
  }

  QueryBuilder<LearningProgressEntity, LearningProgressEntity, QAfterSortBy>
  thenByCompletedItems() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedItems', Sort.asc);
    });
  }

  QueryBuilder<LearningProgressEntity, LearningProgressEntity, QAfterSortBy>
  thenByCompletedItemsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedItems', Sort.desc);
    });
  }

  QueryBuilder<LearningProgressEntity, LearningProgressEntity, QAfterSortBy>
  thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<LearningProgressEntity, LearningProgressEntity, QAfterSortBy>
  thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<LearningProgressEntity, LearningProgressEntity, QAfterSortBy>
  thenByOwnerUsername() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ownerUsername', Sort.asc);
    });
  }

  QueryBuilder<LearningProgressEntity, LearningProgressEntity, QAfterSortBy>
  thenByOwnerUsernameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ownerUsername', Sort.desc);
    });
  }

  QueryBuilder<LearningProgressEntity, LearningProgressEntity, QAfterSortBy>
  thenByProgressPercent() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'progressPercent', Sort.asc);
    });
  }

  QueryBuilder<LearningProgressEntity, LearningProgressEntity, QAfterSortBy>
  thenByProgressPercentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'progressPercent', Sort.desc);
    });
  }

  QueryBuilder<LearningProgressEntity, LearningProgressEntity, QAfterSortBy>
  thenByTotalItems() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalItems', Sort.asc);
    });
  }

  QueryBuilder<LearningProgressEntity, LearningProgressEntity, QAfterSortBy>
  thenByTotalItemsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalItems', Sort.desc);
    });
  }

  QueryBuilder<LearningProgressEntity, LearningProgressEntity, QAfterSortBy>
  thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<LearningProgressEntity, LearningProgressEntity, QAfterSortBy>
  thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension LearningProgressEntityQueryWhereDistinct
    on QueryBuilder<LearningProgressEntity, LearningProgressEntity, QDistinct> {
  QueryBuilder<LearningProgressEntity, LearningProgressEntity, QDistinct>
  distinctByCategory({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'category', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LearningProgressEntity, LearningProgressEntity, QDistinct>
  distinctByCompletedItems() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'completedItems');
    });
  }

  QueryBuilder<LearningProgressEntity, LearningProgressEntity, QDistinct>
  distinctByCompletedKeys() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'completedKeys');
    });
  }

  QueryBuilder<LearningProgressEntity, LearningProgressEntity, QDistinct>
  distinctByOwnerUsername({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'ownerUsername',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<LearningProgressEntity, LearningProgressEntity, QDistinct>
  distinctByProgressPercent() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'progressPercent');
    });
  }

  QueryBuilder<LearningProgressEntity, LearningProgressEntity, QDistinct>
  distinctByTotalItems() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalItems');
    });
  }

  QueryBuilder<LearningProgressEntity, LearningProgressEntity, QDistinct>
  distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }
}

extension LearningProgressEntityQueryProperty
    on
        QueryBuilder<
          LearningProgressEntity,
          LearningProgressEntity,
          QQueryProperty
        > {
  QueryBuilder<LearningProgressEntity, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<LearningProgressEntity, String, QQueryOperations>
  categoryProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'category');
    });
  }

  QueryBuilder<LearningProgressEntity, int, QQueryOperations>
  completedItemsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'completedItems');
    });
  }

  QueryBuilder<LearningProgressEntity, List<String>, QQueryOperations>
  completedKeysProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'completedKeys');
    });
  }

  QueryBuilder<LearningProgressEntity, String, QQueryOperations>
  ownerUsernameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'ownerUsername');
    });
  }

  QueryBuilder<LearningProgressEntity, int, QQueryOperations>
  progressPercentProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'progressPercent');
    });
  }

  QueryBuilder<LearningProgressEntity, int, QQueryOperations>
  totalItemsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalItems');
    });
  }

  QueryBuilder<LearningProgressEntity, DateTime, QQueryOperations>
  updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }
}
