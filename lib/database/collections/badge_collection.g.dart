// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'badge_collection.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetBadgeModelEntityCollection on Isar {
  IsarCollection<BadgeModelEntity> get badgeModelEntitys => this.collection();
}

final BadgeModelEntitySchema = CollectionSchema(
  name: r'BadgeModelEntity',
  id: int.parse('-4488980966009466009'),
  properties: {
    r'badgeImagePath': PropertySchema(
      id: 0,
      name: r'badgeImagePath',
      type: IsarType.string,
    ),
    r'code': PropertySchema(id: 1, name: r'code', type: IsarType.string),
    r'description': PropertySchema(
      id: 2,
      name: r'description',
      type: IsarType.string,
    ),
    r'ownerUsername': PropertySchema(
      id: 3,
      name: r'ownerUsername',
      type: IsarType.string,
    ),
    r'rarity': PropertySchema(id: 4, name: r'rarity', type: IsarType.string),
    r'title': PropertySchema(id: 5, name: r'title', type: IsarType.string),
    r'unlocked': PropertySchema(id: 6, name: r'unlocked', type: IsarType.bool),
    r'unlockedAt': PropertySchema(
      id: 7,
      name: r'unlockedAt',
      type: IsarType.dateTime,
    ),
  },
  estimateSize: _badgeModelEntityEstimateSize,
  serialize: _badgeModelEntitySerialize,
  deserialize: _badgeModelEntityDeserialize,
  deserializeProp: _badgeModelEntityDeserializeProp,
  idName: r'id',
  indexes: {
    r'code_ownerUsername': IndexSchema(
      id: int.parse('166744829813898090'),
      name: r'code_ownerUsername',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'code',
          type: IndexType.hash,
          caseSensitive: true,
        ),
        IndexPropertySchema(
          name: r'ownerUsername',
          type: IndexType.hash,
          caseSensitive: true,
        ),
      ],
    ),
  },
  links: {},
  embeddedSchemas: {},
  getId: _badgeModelEntityGetId,
  getLinks: _badgeModelEntityGetLinks,
  attach: _badgeModelEntityAttach,
  version: '3.1.0+1',
);

int _badgeModelEntityEstimateSize(
  BadgeModelEntity object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.badgeImagePath.length * 3;
  bytesCount += 3 + object.code.length * 3;
  bytesCount += 3 + object.description.length * 3;
  bytesCount += 3 + object.ownerUsername.length * 3;
  bytesCount += 3 + object.rarity.length * 3;
  bytesCount += 3 + object.title.length * 3;
  return bytesCount;
}

void _badgeModelEntitySerialize(
  BadgeModelEntity object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.badgeImagePath);
  writer.writeString(offsets[1], object.code);
  writer.writeString(offsets[2], object.description);
  writer.writeString(offsets[3], object.ownerUsername);
  writer.writeString(offsets[4], object.rarity);
  writer.writeString(offsets[5], object.title);
  writer.writeBool(offsets[6], object.unlocked);
  writer.writeDateTime(offsets[7], object.unlockedAt);
}

BadgeModelEntity _badgeModelEntityDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = BadgeModelEntity();
  object.badgeImagePath = reader.readString(offsets[0]);
  object.code = reader.readString(offsets[1]);
  object.description = reader.readString(offsets[2]);
  object.id = id;
  object.ownerUsername = reader.readString(offsets[3]);
  object.rarity = reader.readString(offsets[4]);
  object.title = reader.readString(offsets[5]);
  object.unlocked = reader.readBool(offsets[6]);
  object.unlockedAt = reader.readDateTimeOrNull(offsets[7]);
  return object;
}

P _badgeModelEntityDeserializeProp<P>(
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
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readBool(offset)) as P;
    case 7:
      return (reader.readDateTimeOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _badgeModelEntityGetId(BadgeModelEntity object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _badgeModelEntityGetLinks(BadgeModelEntity object) {
  return [];
}

void _badgeModelEntityAttach(
  IsarCollection<dynamic> col,
  Id id,
  BadgeModelEntity object,
) {
  object.id = id;
}

extension BadgeModelEntityByIndex on IsarCollection<BadgeModelEntity> {
  Future<BadgeModelEntity?> getByCodeOwnerUsername(
    String code,
    String ownerUsername,
  ) {
    return getByIndex(r'code_ownerUsername', [code, ownerUsername]);
  }

  BadgeModelEntity? getByCodeOwnerUsernameSync(
    String code,
    String ownerUsername,
  ) {
    return getByIndexSync(r'code_ownerUsername', [code, ownerUsername]);
  }

  Future<bool> deleteByCodeOwnerUsername(String code, String ownerUsername) {
    return deleteByIndex(r'code_ownerUsername', [code, ownerUsername]);
  }

  bool deleteByCodeOwnerUsernameSync(String code, String ownerUsername) {
    return deleteByIndexSync(r'code_ownerUsername', [code, ownerUsername]);
  }

  Future<List<BadgeModelEntity?>> getAllByCodeOwnerUsername(
    List<String> codeValues,
    List<String> ownerUsernameValues,
  ) {
    final len = codeValues.length;
    assert(
      ownerUsernameValues.length == len,
      'All index values must have the same length',
    );
    final values = <List<dynamic>>[];
    for (var i = 0; i < len; i++) {
      values.add([codeValues[i], ownerUsernameValues[i]]);
    }

    return getAllByIndex(r'code_ownerUsername', values);
  }

  List<BadgeModelEntity?> getAllByCodeOwnerUsernameSync(
    List<String> codeValues,
    List<String> ownerUsernameValues,
  ) {
    final len = codeValues.length;
    assert(
      ownerUsernameValues.length == len,
      'All index values must have the same length',
    );
    final values = <List<dynamic>>[];
    for (var i = 0; i < len; i++) {
      values.add([codeValues[i], ownerUsernameValues[i]]);
    }

    return getAllByIndexSync(r'code_ownerUsername', values);
  }

  Future<int> deleteAllByCodeOwnerUsername(
    List<String> codeValues,
    List<String> ownerUsernameValues,
  ) {
    final len = codeValues.length;
    assert(
      ownerUsernameValues.length == len,
      'All index values must have the same length',
    );
    final values = <List<dynamic>>[];
    for (var i = 0; i < len; i++) {
      values.add([codeValues[i], ownerUsernameValues[i]]);
    }

    return deleteAllByIndex(r'code_ownerUsername', values);
  }

  int deleteAllByCodeOwnerUsernameSync(
    List<String> codeValues,
    List<String> ownerUsernameValues,
  ) {
    final len = codeValues.length;
    assert(
      ownerUsernameValues.length == len,
      'All index values must have the same length',
    );
    final values = <List<dynamic>>[];
    for (var i = 0; i < len; i++) {
      values.add([codeValues[i], ownerUsernameValues[i]]);
    }

    return deleteAllByIndexSync(r'code_ownerUsername', values);
  }

  Future<Id> putByCodeOwnerUsername(BadgeModelEntity object) {
    return putByIndex(r'code_ownerUsername', object);
  }

  Id putByCodeOwnerUsernameSync(
    BadgeModelEntity object, {
    bool saveLinks = true,
  }) {
    return putByIndexSync(r'code_ownerUsername', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByCodeOwnerUsername(List<BadgeModelEntity> objects) {
    return putAllByIndex(r'code_ownerUsername', objects);
  }

  List<Id> putAllByCodeOwnerUsernameSync(
    List<BadgeModelEntity> objects, {
    bool saveLinks = true,
  }) {
    return putAllByIndexSync(
      r'code_ownerUsername',
      objects,
      saveLinks: saveLinks,
    );
  }
}

extension BadgeModelEntityQueryWhereSort
    on QueryBuilder<BadgeModelEntity, BadgeModelEntity, QWhere> {
  QueryBuilder<BadgeModelEntity, BadgeModelEntity, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension BadgeModelEntityQueryWhere
    on QueryBuilder<BadgeModelEntity, BadgeModelEntity, QWhereClause> {
  QueryBuilder<BadgeModelEntity, BadgeModelEntity, QAfterWhereClause> idEqualTo(
    Id id,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<BadgeModelEntity, BadgeModelEntity, QAfterWhereClause>
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

  QueryBuilder<BadgeModelEntity, BadgeModelEntity, QAfterWhereClause>
  idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<BadgeModelEntity, BadgeModelEntity, QAfterWhereClause>
  idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<BadgeModelEntity, BadgeModelEntity, QAfterWhereClause> idBetween(
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

  QueryBuilder<BadgeModelEntity, BadgeModelEntity, QAfterWhereClause>
  codeEqualToAnyOwnerUsername(String code) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(
          indexName: r'code_ownerUsername',
          value: [code],
        ),
      );
    });
  }

  QueryBuilder<BadgeModelEntity, BadgeModelEntity, QAfterWhereClause>
  codeNotEqualToAnyOwnerUsername(String code) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'code_ownerUsername',
                lower: [],
                upper: [code],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'code_ownerUsername',
                lower: [code],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'code_ownerUsername',
                lower: [code],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'code_ownerUsername',
                lower: [],
                upper: [code],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<BadgeModelEntity, BadgeModelEntity, QAfterWhereClause>
  codeOwnerUsernameEqualTo(String code, String ownerUsername) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(
          indexName: r'code_ownerUsername',
          value: [code, ownerUsername],
        ),
      );
    });
  }

  QueryBuilder<BadgeModelEntity, BadgeModelEntity, QAfterWhereClause>
  codeEqualToOwnerUsernameNotEqualTo(String code, String ownerUsername) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'code_ownerUsername',
                lower: [code],
                upper: [code, ownerUsername],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'code_ownerUsername',
                lower: [code, ownerUsername],
                includeLower: false,
                upper: [code],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'code_ownerUsername',
                lower: [code, ownerUsername],
                includeLower: false,
                upper: [code],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'code_ownerUsername',
                lower: [code],
                upper: [code, ownerUsername],
                includeUpper: false,
              ),
            );
      }
    });
  }
}

extension BadgeModelEntityQueryFilter
    on QueryBuilder<BadgeModelEntity, BadgeModelEntity, QFilterCondition> {
  QueryBuilder<BadgeModelEntity, BadgeModelEntity, QAfterFilterCondition>
  badgeImagePathEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'badgeImagePath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<BadgeModelEntity, BadgeModelEntity, QAfterFilterCondition>
  badgeImagePathGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'badgeImagePath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<BadgeModelEntity, BadgeModelEntity, QAfterFilterCondition>
  badgeImagePathLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'badgeImagePath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<BadgeModelEntity, BadgeModelEntity, QAfterFilterCondition>
  badgeImagePathBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'badgeImagePath',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<BadgeModelEntity, BadgeModelEntity, QAfterFilterCondition>
  badgeImagePathStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'badgeImagePath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<BadgeModelEntity, BadgeModelEntity, QAfterFilterCondition>
  badgeImagePathEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'badgeImagePath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<BadgeModelEntity, BadgeModelEntity, QAfterFilterCondition>
  badgeImagePathContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'badgeImagePath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<BadgeModelEntity, BadgeModelEntity, QAfterFilterCondition>
  badgeImagePathMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'badgeImagePath',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<BadgeModelEntity, BadgeModelEntity, QAfterFilterCondition>
  badgeImagePathIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'badgeImagePath', value: ''),
      );
    });
  }

  QueryBuilder<BadgeModelEntity, BadgeModelEntity, QAfterFilterCondition>
  badgeImagePathIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'badgeImagePath', value: ''),
      );
    });
  }

  QueryBuilder<BadgeModelEntity, BadgeModelEntity, QAfterFilterCondition>
  codeEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'code',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<BadgeModelEntity, BadgeModelEntity, QAfterFilterCondition>
  codeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'code',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<BadgeModelEntity, BadgeModelEntity, QAfterFilterCondition>
  codeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'code',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<BadgeModelEntity, BadgeModelEntity, QAfterFilterCondition>
  codeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'code',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<BadgeModelEntity, BadgeModelEntity, QAfterFilterCondition>
  codeStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'code',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<BadgeModelEntity, BadgeModelEntity, QAfterFilterCondition>
  codeEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'code',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<BadgeModelEntity, BadgeModelEntity, QAfterFilterCondition>
  codeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'code',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<BadgeModelEntity, BadgeModelEntity, QAfterFilterCondition>
  codeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'code',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<BadgeModelEntity, BadgeModelEntity, QAfterFilterCondition>
  codeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'code', value: ''),
      );
    });
  }

  QueryBuilder<BadgeModelEntity, BadgeModelEntity, QAfterFilterCondition>
  codeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'code', value: ''),
      );
    });
  }

  QueryBuilder<BadgeModelEntity, BadgeModelEntity, QAfterFilterCondition>
  descriptionEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'description',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<BadgeModelEntity, BadgeModelEntity, QAfterFilterCondition>
  descriptionGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'description',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<BadgeModelEntity, BadgeModelEntity, QAfterFilterCondition>
  descriptionLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'description',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<BadgeModelEntity, BadgeModelEntity, QAfterFilterCondition>
  descriptionBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'description',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<BadgeModelEntity, BadgeModelEntity, QAfterFilterCondition>
  descriptionStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'description',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<BadgeModelEntity, BadgeModelEntity, QAfterFilterCondition>
  descriptionEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'description',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<BadgeModelEntity, BadgeModelEntity, QAfterFilterCondition>
  descriptionContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'description',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<BadgeModelEntity, BadgeModelEntity, QAfterFilterCondition>
  descriptionMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'description',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<BadgeModelEntity, BadgeModelEntity, QAfterFilterCondition>
  descriptionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'description', value: ''),
      );
    });
  }

  QueryBuilder<BadgeModelEntity, BadgeModelEntity, QAfterFilterCondition>
  descriptionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'description', value: ''),
      );
    });
  }

  QueryBuilder<BadgeModelEntity, BadgeModelEntity, QAfterFilterCondition>
  idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<BadgeModelEntity, BadgeModelEntity, QAfterFilterCondition>
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

  QueryBuilder<BadgeModelEntity, BadgeModelEntity, QAfterFilterCondition>
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

  QueryBuilder<BadgeModelEntity, BadgeModelEntity, QAfterFilterCondition>
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

  QueryBuilder<BadgeModelEntity, BadgeModelEntity, QAfterFilterCondition>
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

  QueryBuilder<BadgeModelEntity, BadgeModelEntity, QAfterFilterCondition>
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

  QueryBuilder<BadgeModelEntity, BadgeModelEntity, QAfterFilterCondition>
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

  QueryBuilder<BadgeModelEntity, BadgeModelEntity, QAfterFilterCondition>
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

  QueryBuilder<BadgeModelEntity, BadgeModelEntity, QAfterFilterCondition>
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

  QueryBuilder<BadgeModelEntity, BadgeModelEntity, QAfterFilterCondition>
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

  QueryBuilder<BadgeModelEntity, BadgeModelEntity, QAfterFilterCondition>
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

  QueryBuilder<BadgeModelEntity, BadgeModelEntity, QAfterFilterCondition>
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

  QueryBuilder<BadgeModelEntity, BadgeModelEntity, QAfterFilterCondition>
  ownerUsernameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'ownerUsername', value: ''),
      );
    });
  }

  QueryBuilder<BadgeModelEntity, BadgeModelEntity, QAfterFilterCondition>
  ownerUsernameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'ownerUsername', value: ''),
      );
    });
  }

  QueryBuilder<BadgeModelEntity, BadgeModelEntity, QAfterFilterCondition>
  rarityEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'rarity',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<BadgeModelEntity, BadgeModelEntity, QAfterFilterCondition>
  rarityGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'rarity',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<BadgeModelEntity, BadgeModelEntity, QAfterFilterCondition>
  rarityLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'rarity',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<BadgeModelEntity, BadgeModelEntity, QAfterFilterCondition>
  rarityBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'rarity',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<BadgeModelEntity, BadgeModelEntity, QAfterFilterCondition>
  rarityStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'rarity',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<BadgeModelEntity, BadgeModelEntity, QAfterFilterCondition>
  rarityEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'rarity',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<BadgeModelEntity, BadgeModelEntity, QAfterFilterCondition>
  rarityContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'rarity',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<BadgeModelEntity, BadgeModelEntity, QAfterFilterCondition>
  rarityMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'rarity',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<BadgeModelEntity, BadgeModelEntity, QAfterFilterCondition>
  rarityIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'rarity', value: ''),
      );
    });
  }

  QueryBuilder<BadgeModelEntity, BadgeModelEntity, QAfterFilterCondition>
  rarityIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'rarity', value: ''),
      );
    });
  }

  QueryBuilder<BadgeModelEntity, BadgeModelEntity, QAfterFilterCondition>
  titleEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'title',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<BadgeModelEntity, BadgeModelEntity, QAfterFilterCondition>
  titleGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'title',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<BadgeModelEntity, BadgeModelEntity, QAfterFilterCondition>
  titleLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'title',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<BadgeModelEntity, BadgeModelEntity, QAfterFilterCondition>
  titleBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'title',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<BadgeModelEntity, BadgeModelEntity, QAfterFilterCondition>
  titleStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'title',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<BadgeModelEntity, BadgeModelEntity, QAfterFilterCondition>
  titleEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'title',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<BadgeModelEntity, BadgeModelEntity, QAfterFilterCondition>
  titleContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'title',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<BadgeModelEntity, BadgeModelEntity, QAfterFilterCondition>
  titleMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'title',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<BadgeModelEntity, BadgeModelEntity, QAfterFilterCondition>
  titleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'title', value: ''),
      );
    });
  }

  QueryBuilder<BadgeModelEntity, BadgeModelEntity, QAfterFilterCondition>
  titleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'title', value: ''),
      );
    });
  }

  QueryBuilder<BadgeModelEntity, BadgeModelEntity, QAfterFilterCondition>
  unlockedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'unlocked', value: value),
      );
    });
  }

  QueryBuilder<BadgeModelEntity, BadgeModelEntity, QAfterFilterCondition>
  unlockedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'unlockedAt'),
      );
    });
  }

  QueryBuilder<BadgeModelEntity, BadgeModelEntity, QAfterFilterCondition>
  unlockedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'unlockedAt'),
      );
    });
  }

  QueryBuilder<BadgeModelEntity, BadgeModelEntity, QAfterFilterCondition>
  unlockedAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'unlockedAt', value: value),
      );
    });
  }

  QueryBuilder<BadgeModelEntity, BadgeModelEntity, QAfterFilterCondition>
  unlockedAtGreaterThan(DateTime? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'unlockedAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<BadgeModelEntity, BadgeModelEntity, QAfterFilterCondition>
  unlockedAtLessThan(DateTime? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'unlockedAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<BadgeModelEntity, BadgeModelEntity, QAfterFilterCondition>
  unlockedAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'unlockedAt',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension BadgeModelEntityQueryObject
    on QueryBuilder<BadgeModelEntity, BadgeModelEntity, QFilterCondition> {}

extension BadgeModelEntityQueryLinks
    on QueryBuilder<BadgeModelEntity, BadgeModelEntity, QFilterCondition> {}

extension BadgeModelEntityQuerySortBy
    on QueryBuilder<BadgeModelEntity, BadgeModelEntity, QSortBy> {
  QueryBuilder<BadgeModelEntity, BadgeModelEntity, QAfterSortBy>
  sortByBadgeImagePath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'badgeImagePath', Sort.asc);
    });
  }

  QueryBuilder<BadgeModelEntity, BadgeModelEntity, QAfterSortBy>
  sortByBadgeImagePathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'badgeImagePath', Sort.desc);
    });
  }

  QueryBuilder<BadgeModelEntity, BadgeModelEntity, QAfterSortBy> sortByCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'code', Sort.asc);
    });
  }

  QueryBuilder<BadgeModelEntity, BadgeModelEntity, QAfterSortBy>
  sortByCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'code', Sort.desc);
    });
  }

  QueryBuilder<BadgeModelEntity, BadgeModelEntity, QAfterSortBy>
  sortByDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.asc);
    });
  }

  QueryBuilder<BadgeModelEntity, BadgeModelEntity, QAfterSortBy>
  sortByDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.desc);
    });
  }

  QueryBuilder<BadgeModelEntity, BadgeModelEntity, QAfterSortBy>
  sortByOwnerUsername() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ownerUsername', Sort.asc);
    });
  }

  QueryBuilder<BadgeModelEntity, BadgeModelEntity, QAfterSortBy>
  sortByOwnerUsernameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ownerUsername', Sort.desc);
    });
  }

  QueryBuilder<BadgeModelEntity, BadgeModelEntity, QAfterSortBy>
  sortByRarity() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rarity', Sort.asc);
    });
  }

  QueryBuilder<BadgeModelEntity, BadgeModelEntity, QAfterSortBy>
  sortByRarityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rarity', Sort.desc);
    });
  }

  QueryBuilder<BadgeModelEntity, BadgeModelEntity, QAfterSortBy> sortByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<BadgeModelEntity, BadgeModelEntity, QAfterSortBy>
  sortByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }

  QueryBuilder<BadgeModelEntity, BadgeModelEntity, QAfterSortBy>
  sortByUnlocked() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'unlocked', Sort.asc);
    });
  }

  QueryBuilder<BadgeModelEntity, BadgeModelEntity, QAfterSortBy>
  sortByUnlockedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'unlocked', Sort.desc);
    });
  }

  QueryBuilder<BadgeModelEntity, BadgeModelEntity, QAfterSortBy>
  sortByUnlockedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'unlockedAt', Sort.asc);
    });
  }

  QueryBuilder<BadgeModelEntity, BadgeModelEntity, QAfterSortBy>
  sortByUnlockedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'unlockedAt', Sort.desc);
    });
  }
}

extension BadgeModelEntityQuerySortThenBy
    on QueryBuilder<BadgeModelEntity, BadgeModelEntity, QSortThenBy> {
  QueryBuilder<BadgeModelEntity, BadgeModelEntity, QAfterSortBy>
  thenByBadgeImagePath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'badgeImagePath', Sort.asc);
    });
  }

  QueryBuilder<BadgeModelEntity, BadgeModelEntity, QAfterSortBy>
  thenByBadgeImagePathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'badgeImagePath', Sort.desc);
    });
  }

  QueryBuilder<BadgeModelEntity, BadgeModelEntity, QAfterSortBy> thenByCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'code', Sort.asc);
    });
  }

  QueryBuilder<BadgeModelEntity, BadgeModelEntity, QAfterSortBy>
  thenByCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'code', Sort.desc);
    });
  }

  QueryBuilder<BadgeModelEntity, BadgeModelEntity, QAfterSortBy>
  thenByDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.asc);
    });
  }

  QueryBuilder<BadgeModelEntity, BadgeModelEntity, QAfterSortBy>
  thenByDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.desc);
    });
  }

  QueryBuilder<BadgeModelEntity, BadgeModelEntity, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<BadgeModelEntity, BadgeModelEntity, QAfterSortBy>
  thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<BadgeModelEntity, BadgeModelEntity, QAfterSortBy>
  thenByOwnerUsername() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ownerUsername', Sort.asc);
    });
  }

  QueryBuilder<BadgeModelEntity, BadgeModelEntity, QAfterSortBy>
  thenByOwnerUsernameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ownerUsername', Sort.desc);
    });
  }

  QueryBuilder<BadgeModelEntity, BadgeModelEntity, QAfterSortBy>
  thenByRarity() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rarity', Sort.asc);
    });
  }

  QueryBuilder<BadgeModelEntity, BadgeModelEntity, QAfterSortBy>
  thenByRarityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rarity', Sort.desc);
    });
  }

  QueryBuilder<BadgeModelEntity, BadgeModelEntity, QAfterSortBy> thenByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<BadgeModelEntity, BadgeModelEntity, QAfterSortBy>
  thenByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }

  QueryBuilder<BadgeModelEntity, BadgeModelEntity, QAfterSortBy>
  thenByUnlocked() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'unlocked', Sort.asc);
    });
  }

  QueryBuilder<BadgeModelEntity, BadgeModelEntity, QAfterSortBy>
  thenByUnlockedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'unlocked', Sort.desc);
    });
  }

  QueryBuilder<BadgeModelEntity, BadgeModelEntity, QAfterSortBy>
  thenByUnlockedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'unlockedAt', Sort.asc);
    });
  }

  QueryBuilder<BadgeModelEntity, BadgeModelEntity, QAfterSortBy>
  thenByUnlockedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'unlockedAt', Sort.desc);
    });
  }
}

extension BadgeModelEntityQueryWhereDistinct
    on QueryBuilder<BadgeModelEntity, BadgeModelEntity, QDistinct> {
  QueryBuilder<BadgeModelEntity, BadgeModelEntity, QDistinct>
  distinctByBadgeImagePath({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'badgeImagePath',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<BadgeModelEntity, BadgeModelEntity, QDistinct> distinctByCode({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'code', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<BadgeModelEntity, BadgeModelEntity, QDistinct>
  distinctByDescription({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'description', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<BadgeModelEntity, BadgeModelEntity, QDistinct>
  distinctByOwnerUsername({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'ownerUsername',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<BadgeModelEntity, BadgeModelEntity, QDistinct> distinctByRarity({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'rarity', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<BadgeModelEntity, BadgeModelEntity, QDistinct> distinctByTitle({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'title', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<BadgeModelEntity, BadgeModelEntity, QDistinct>
  distinctByUnlocked() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'unlocked');
    });
  }

  QueryBuilder<BadgeModelEntity, BadgeModelEntity, QDistinct>
  distinctByUnlockedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'unlockedAt');
    });
  }
}

extension BadgeModelEntityQueryProperty
    on QueryBuilder<BadgeModelEntity, BadgeModelEntity, QQueryProperty> {
  QueryBuilder<BadgeModelEntity, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<BadgeModelEntity, String, QQueryOperations>
  badgeImagePathProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'badgeImagePath');
    });
  }

  QueryBuilder<BadgeModelEntity, String, QQueryOperations> codeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'code');
    });
  }

  QueryBuilder<BadgeModelEntity, String, QQueryOperations>
  descriptionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'description');
    });
  }

  QueryBuilder<BadgeModelEntity, String, QQueryOperations>
  ownerUsernameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'ownerUsername');
    });
  }

  QueryBuilder<BadgeModelEntity, String, QQueryOperations> rarityProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'rarity');
    });
  }

  QueryBuilder<BadgeModelEntity, String, QQueryOperations> titleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'title');
    });
  }

  QueryBuilder<BadgeModelEntity, bool, QQueryOperations> unlockedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'unlocked');
    });
  }

  QueryBuilder<BadgeModelEntity, DateTime?, QQueryOperations>
  unlockedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'unlockedAt');
    });
  }
}
