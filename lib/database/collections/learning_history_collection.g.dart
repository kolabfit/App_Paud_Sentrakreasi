// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'learning_history_collection.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetLearningHistoryEntityCollection on Isar {
  IsarCollection<LearningHistoryEntity> get learningHistoryEntitys =>
      this.collection();
}

final LearningHistoryEntitySchema = CollectionSchema(
  name: r'LearningHistoryEntity',
  id: int.parse('7917947214307255236'),
  properties: {
    r'category': PropertySchema(
      id: 0,
      name: r'category',
      type: IsarType.string,
    ),
    r'duration': PropertySchema(id: 1, name: r'duration', type: IsarType.long),
    r'materialId': PropertySchema(
      id: 2,
      name: r'materialId',
      type: IsarType.string,
    ),
    r'ownerUsername': PropertySchema(
      id: 3,
      name: r'ownerUsername',
      type: IsarType.string,
    ),
    r'playedAt': PropertySchema(
      id: 4,
      name: r'playedAt',
      type: IsarType.dateTime,
    ),
    r'score': PropertySchema(id: 5, name: r'score', type: IsarType.long),
  },
  estimateSize: _learningHistoryEntityEstimateSize,
  serialize: _learningHistoryEntitySerialize,
  deserialize: _learningHistoryEntityDeserialize,
  deserializeProp: _learningHistoryEntityDeserializeProp,
  idName: r'id',
  indexes: {
    r'ownerUsername': IndexSchema(
      id: int.parse('9203638787039241762'),
      name: r'ownerUsername',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'ownerUsername',
          type: IndexType.hash,
          caseSensitive: true,
        ),
      ],
    ),
    r'category': IndexSchema(
      id: int.parse('-7560358558326323820'),
      name: r'category',
      unique: false,
      replace: false,
      properties: [
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
  getId: _learningHistoryEntityGetId,
  getLinks: _learningHistoryEntityGetLinks,
  attach: _learningHistoryEntityAttach,
  version: '3.1.0+1',
);

int _learningHistoryEntityEstimateSize(
  LearningHistoryEntity object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.category.length * 3;
  bytesCount += 3 + object.materialId.length * 3;
  bytesCount += 3 + object.ownerUsername.length * 3;
  return bytesCount;
}

void _learningHistoryEntitySerialize(
  LearningHistoryEntity object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.category);
  writer.writeLong(offsets[1], object.duration);
  writer.writeString(offsets[2], object.materialId);
  writer.writeString(offsets[3], object.ownerUsername);
  writer.writeDateTime(offsets[4], object.playedAt);
  writer.writeLong(offsets[5], object.score);
}

LearningHistoryEntity _learningHistoryEntityDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = LearningHistoryEntity();
  object.category = reader.readString(offsets[0]);
  object.duration = reader.readLong(offsets[1]);
  object.id = id;
  object.materialId = reader.readString(offsets[2]);
  object.ownerUsername = reader.readString(offsets[3]);
  object.playedAt = reader.readDateTime(offsets[4]);
  object.score = reader.readLong(offsets[5]);
  return object;
}

P _learningHistoryEntityDeserializeProp<P>(
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
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readDateTime(offset)) as P;
    case 5:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _learningHistoryEntityGetId(LearningHistoryEntity object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _learningHistoryEntityGetLinks(
  LearningHistoryEntity object,
) {
  return [];
}

void _learningHistoryEntityAttach(
  IsarCollection<dynamic> col,
  Id id,
  LearningHistoryEntity object,
) {
  object.id = id;
}

extension LearningHistoryEntityQueryWhereSort
    on QueryBuilder<LearningHistoryEntity, LearningHistoryEntity, QWhere> {
  QueryBuilder<LearningHistoryEntity, LearningHistoryEntity, QAfterWhere>
  anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension LearningHistoryEntityQueryWhere
    on
        QueryBuilder<
          LearningHistoryEntity,
          LearningHistoryEntity,
          QWhereClause
        > {
  QueryBuilder<LearningHistoryEntity, LearningHistoryEntity, QAfterWhereClause>
  idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<LearningHistoryEntity, LearningHistoryEntity, QAfterWhereClause>
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

  QueryBuilder<LearningHistoryEntity, LearningHistoryEntity, QAfterWhereClause>
  idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<LearningHistoryEntity, LearningHistoryEntity, QAfterWhereClause>
  idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<LearningHistoryEntity, LearningHistoryEntity, QAfterWhereClause>
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

  QueryBuilder<LearningHistoryEntity, LearningHistoryEntity, QAfterWhereClause>
  ownerUsernameEqualTo(String ownerUsername) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(
          indexName: r'ownerUsername',
          value: [ownerUsername],
        ),
      );
    });
  }

  QueryBuilder<LearningHistoryEntity, LearningHistoryEntity, QAfterWhereClause>
  ownerUsernameNotEqualTo(String ownerUsername) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'ownerUsername',
                lower: [],
                upper: [ownerUsername],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'ownerUsername',
                lower: [ownerUsername],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'ownerUsername',
                lower: [ownerUsername],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'ownerUsername',
                lower: [],
                upper: [ownerUsername],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<LearningHistoryEntity, LearningHistoryEntity, QAfterWhereClause>
  categoryEqualTo(String category) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'category', value: [category]),
      );
    });
  }

  QueryBuilder<LearningHistoryEntity, LearningHistoryEntity, QAfterWhereClause>
  categoryNotEqualTo(String category) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'category',
                lower: [],
                upper: [category],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'category',
                lower: [category],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'category',
                lower: [category],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'category',
                lower: [],
                upper: [category],
                includeUpper: false,
              ),
            );
      }
    });
  }
}

extension LearningHistoryEntityQueryFilter
    on
        QueryBuilder<
          LearningHistoryEntity,
          LearningHistoryEntity,
          QFilterCondition
        > {
  QueryBuilder<
    LearningHistoryEntity,
    LearningHistoryEntity,
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
    LearningHistoryEntity,
    LearningHistoryEntity,
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
    LearningHistoryEntity,
    LearningHistoryEntity,
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
    LearningHistoryEntity,
    LearningHistoryEntity,
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
    LearningHistoryEntity,
    LearningHistoryEntity,
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
    LearningHistoryEntity,
    LearningHistoryEntity,
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
    LearningHistoryEntity,
    LearningHistoryEntity,
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
    LearningHistoryEntity,
    LearningHistoryEntity,
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
    LearningHistoryEntity,
    LearningHistoryEntity,
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
    LearningHistoryEntity,
    LearningHistoryEntity,
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
    LearningHistoryEntity,
    LearningHistoryEntity,
    QAfterFilterCondition
  >
  durationEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'duration', value: value),
      );
    });
  }

  QueryBuilder<
    LearningHistoryEntity,
    LearningHistoryEntity,
    QAfterFilterCondition
  >
  durationGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'duration',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    LearningHistoryEntity,
    LearningHistoryEntity,
    QAfterFilterCondition
  >
  durationLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'duration',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    LearningHistoryEntity,
    LearningHistoryEntity,
    QAfterFilterCondition
  >
  durationBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'duration',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    LearningHistoryEntity,
    LearningHistoryEntity,
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
    LearningHistoryEntity,
    LearningHistoryEntity,
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
    LearningHistoryEntity,
    LearningHistoryEntity,
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
    LearningHistoryEntity,
    LearningHistoryEntity,
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
    LearningHistoryEntity,
    LearningHistoryEntity,
    QAfterFilterCondition
  >
  materialIdEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'materialId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    LearningHistoryEntity,
    LearningHistoryEntity,
    QAfterFilterCondition
  >
  materialIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'materialId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    LearningHistoryEntity,
    LearningHistoryEntity,
    QAfterFilterCondition
  >
  materialIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'materialId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    LearningHistoryEntity,
    LearningHistoryEntity,
    QAfterFilterCondition
  >
  materialIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'materialId',
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
    LearningHistoryEntity,
    LearningHistoryEntity,
    QAfterFilterCondition
  >
  materialIdStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'materialId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    LearningHistoryEntity,
    LearningHistoryEntity,
    QAfterFilterCondition
  >
  materialIdEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'materialId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    LearningHistoryEntity,
    LearningHistoryEntity,
    QAfterFilterCondition
  >
  materialIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'materialId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    LearningHistoryEntity,
    LearningHistoryEntity,
    QAfterFilterCondition
  >
  materialIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'materialId',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    LearningHistoryEntity,
    LearningHistoryEntity,
    QAfterFilterCondition
  >
  materialIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'materialId', value: ''),
      );
    });
  }

  QueryBuilder<
    LearningHistoryEntity,
    LearningHistoryEntity,
    QAfterFilterCondition
  >
  materialIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'materialId', value: ''),
      );
    });
  }

  QueryBuilder<
    LearningHistoryEntity,
    LearningHistoryEntity,
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
    LearningHistoryEntity,
    LearningHistoryEntity,
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
    LearningHistoryEntity,
    LearningHistoryEntity,
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
    LearningHistoryEntity,
    LearningHistoryEntity,
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
    LearningHistoryEntity,
    LearningHistoryEntity,
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
    LearningHistoryEntity,
    LearningHistoryEntity,
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
    LearningHistoryEntity,
    LearningHistoryEntity,
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
    LearningHistoryEntity,
    LearningHistoryEntity,
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
    LearningHistoryEntity,
    LearningHistoryEntity,
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
    LearningHistoryEntity,
    LearningHistoryEntity,
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
    LearningHistoryEntity,
    LearningHistoryEntity,
    QAfterFilterCondition
  >
  playedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'playedAt', value: value),
      );
    });
  }

  QueryBuilder<
    LearningHistoryEntity,
    LearningHistoryEntity,
    QAfterFilterCondition
  >
  playedAtGreaterThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'playedAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    LearningHistoryEntity,
    LearningHistoryEntity,
    QAfterFilterCondition
  >
  playedAtLessThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'playedAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    LearningHistoryEntity,
    LearningHistoryEntity,
    QAfterFilterCondition
  >
  playedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'playedAt',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    LearningHistoryEntity,
    LearningHistoryEntity,
    QAfterFilterCondition
  >
  scoreEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'score', value: value),
      );
    });
  }

  QueryBuilder<
    LearningHistoryEntity,
    LearningHistoryEntity,
    QAfterFilterCondition
  >
  scoreGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'score',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    LearningHistoryEntity,
    LearningHistoryEntity,
    QAfterFilterCondition
  >
  scoreLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'score',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    LearningHistoryEntity,
    LearningHistoryEntity,
    QAfterFilterCondition
  >
  scoreBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'score',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension LearningHistoryEntityQueryObject
    on
        QueryBuilder<
          LearningHistoryEntity,
          LearningHistoryEntity,
          QFilterCondition
        > {}

extension LearningHistoryEntityQueryLinks
    on
        QueryBuilder<
          LearningHistoryEntity,
          LearningHistoryEntity,
          QFilterCondition
        > {}

extension LearningHistoryEntityQuerySortBy
    on QueryBuilder<LearningHistoryEntity, LearningHistoryEntity, QSortBy> {
  QueryBuilder<LearningHistoryEntity, LearningHistoryEntity, QAfterSortBy>
  sortByCategory() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'category', Sort.asc);
    });
  }

  QueryBuilder<LearningHistoryEntity, LearningHistoryEntity, QAfterSortBy>
  sortByCategoryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'category', Sort.desc);
    });
  }

  QueryBuilder<LearningHistoryEntity, LearningHistoryEntity, QAfterSortBy>
  sortByDuration() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'duration', Sort.asc);
    });
  }

  QueryBuilder<LearningHistoryEntity, LearningHistoryEntity, QAfterSortBy>
  sortByDurationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'duration', Sort.desc);
    });
  }

  QueryBuilder<LearningHistoryEntity, LearningHistoryEntity, QAfterSortBy>
  sortByMaterialId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'materialId', Sort.asc);
    });
  }

  QueryBuilder<LearningHistoryEntity, LearningHistoryEntity, QAfterSortBy>
  sortByMaterialIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'materialId', Sort.desc);
    });
  }

  QueryBuilder<LearningHistoryEntity, LearningHistoryEntity, QAfterSortBy>
  sortByOwnerUsername() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ownerUsername', Sort.asc);
    });
  }

  QueryBuilder<LearningHistoryEntity, LearningHistoryEntity, QAfterSortBy>
  sortByOwnerUsernameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ownerUsername', Sort.desc);
    });
  }

  QueryBuilder<LearningHistoryEntity, LearningHistoryEntity, QAfterSortBy>
  sortByPlayedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'playedAt', Sort.asc);
    });
  }

  QueryBuilder<LearningHistoryEntity, LearningHistoryEntity, QAfterSortBy>
  sortByPlayedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'playedAt', Sort.desc);
    });
  }

  QueryBuilder<LearningHistoryEntity, LearningHistoryEntity, QAfterSortBy>
  sortByScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'score', Sort.asc);
    });
  }

  QueryBuilder<LearningHistoryEntity, LearningHistoryEntity, QAfterSortBy>
  sortByScoreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'score', Sort.desc);
    });
  }
}

extension LearningHistoryEntityQuerySortThenBy
    on QueryBuilder<LearningHistoryEntity, LearningHistoryEntity, QSortThenBy> {
  QueryBuilder<LearningHistoryEntity, LearningHistoryEntity, QAfterSortBy>
  thenByCategory() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'category', Sort.asc);
    });
  }

  QueryBuilder<LearningHistoryEntity, LearningHistoryEntity, QAfterSortBy>
  thenByCategoryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'category', Sort.desc);
    });
  }

  QueryBuilder<LearningHistoryEntity, LearningHistoryEntity, QAfterSortBy>
  thenByDuration() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'duration', Sort.asc);
    });
  }

  QueryBuilder<LearningHistoryEntity, LearningHistoryEntity, QAfterSortBy>
  thenByDurationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'duration', Sort.desc);
    });
  }

  QueryBuilder<LearningHistoryEntity, LearningHistoryEntity, QAfterSortBy>
  thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<LearningHistoryEntity, LearningHistoryEntity, QAfterSortBy>
  thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<LearningHistoryEntity, LearningHistoryEntity, QAfterSortBy>
  thenByMaterialId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'materialId', Sort.asc);
    });
  }

  QueryBuilder<LearningHistoryEntity, LearningHistoryEntity, QAfterSortBy>
  thenByMaterialIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'materialId', Sort.desc);
    });
  }

  QueryBuilder<LearningHistoryEntity, LearningHistoryEntity, QAfterSortBy>
  thenByOwnerUsername() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ownerUsername', Sort.asc);
    });
  }

  QueryBuilder<LearningHistoryEntity, LearningHistoryEntity, QAfterSortBy>
  thenByOwnerUsernameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ownerUsername', Sort.desc);
    });
  }

  QueryBuilder<LearningHistoryEntity, LearningHistoryEntity, QAfterSortBy>
  thenByPlayedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'playedAt', Sort.asc);
    });
  }

  QueryBuilder<LearningHistoryEntity, LearningHistoryEntity, QAfterSortBy>
  thenByPlayedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'playedAt', Sort.desc);
    });
  }

  QueryBuilder<LearningHistoryEntity, LearningHistoryEntity, QAfterSortBy>
  thenByScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'score', Sort.asc);
    });
  }

  QueryBuilder<LearningHistoryEntity, LearningHistoryEntity, QAfterSortBy>
  thenByScoreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'score', Sort.desc);
    });
  }
}

extension LearningHistoryEntityQueryWhereDistinct
    on QueryBuilder<LearningHistoryEntity, LearningHistoryEntity, QDistinct> {
  QueryBuilder<LearningHistoryEntity, LearningHistoryEntity, QDistinct>
  distinctByCategory({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'category', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LearningHistoryEntity, LearningHistoryEntity, QDistinct>
  distinctByDuration() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'duration');
    });
  }

  QueryBuilder<LearningHistoryEntity, LearningHistoryEntity, QDistinct>
  distinctByMaterialId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'materialId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LearningHistoryEntity, LearningHistoryEntity, QDistinct>
  distinctByOwnerUsername({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'ownerUsername',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<LearningHistoryEntity, LearningHistoryEntity, QDistinct>
  distinctByPlayedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'playedAt');
    });
  }

  QueryBuilder<LearningHistoryEntity, LearningHistoryEntity, QDistinct>
  distinctByScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'score');
    });
  }
}

extension LearningHistoryEntityQueryProperty
    on
        QueryBuilder<
          LearningHistoryEntity,
          LearningHistoryEntity,
          QQueryProperty
        > {
  QueryBuilder<LearningHistoryEntity, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<LearningHistoryEntity, String, QQueryOperations>
  categoryProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'category');
    });
  }

  QueryBuilder<LearningHistoryEntity, int, QQueryOperations>
  durationProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'duration');
    });
  }

  QueryBuilder<LearningHistoryEntity, String, QQueryOperations>
  materialIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'materialId');
    });
  }

  QueryBuilder<LearningHistoryEntity, String, QQueryOperations>
  ownerUsernameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'ownerUsername');
    });
  }

  QueryBuilder<LearningHistoryEntity, DateTime, QQueryOperations>
  playedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'playedAt');
    });
  }

  QueryBuilder<LearningHistoryEntity, int, QQueryOperations> scoreProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'score');
    });
  }
}
