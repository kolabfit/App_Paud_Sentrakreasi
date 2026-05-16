// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'theme_settings_collection.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetThemeSettingsEntityCollection on Isar {
  IsarCollection<ThemeSettingsEntity> get themeSettingsEntitys =>
      this.collection();
}

final ThemeSettingsEntitySchema = CollectionSchema(
  name: r'ThemeSettingsEntity',
  id: int.parse('7886392070402085114'),
  properties: {
    r'darkMode': PropertySchema(id: 0, name: r'darkMode', type: IsarType.bool),
    r'ownerUsername': PropertySchema(
      id: 1,
      name: r'ownerUsername',
      type: IsarType.string,
    ),
    r'selectedTheme': PropertySchema(
      id: 2,
      name: r'selectedTheme',
      type: IsarType.string,
    ),
    r'updatedAt': PropertySchema(
      id: 3,
      name: r'updatedAt',
      type: IsarType.dateTime,
    ),
  },
  estimateSize: _themeSettingsEntityEstimateSize,
  serialize: _themeSettingsEntitySerialize,
  deserialize: _themeSettingsEntityDeserialize,
  deserializeProp: _themeSettingsEntityDeserializeProp,
  idName: r'id',
  indexes: {
    r'ownerUsername': IndexSchema(
      id: int.parse('9203638787039241762'),
      name: r'ownerUsername',
      unique: true,
      replace: true,
      properties: [
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
  getId: _themeSettingsEntityGetId,
  getLinks: _themeSettingsEntityGetLinks,
  attach: _themeSettingsEntityAttach,
  version: '3.1.0+1',
);

int _themeSettingsEntityEstimateSize(
  ThemeSettingsEntity object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.ownerUsername.length * 3;
  bytesCount += 3 + object.selectedTheme.length * 3;
  return bytesCount;
}

void _themeSettingsEntitySerialize(
  ThemeSettingsEntity object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeBool(offsets[0], object.darkMode);
  writer.writeString(offsets[1], object.ownerUsername);
  writer.writeString(offsets[2], object.selectedTheme);
  writer.writeDateTime(offsets[3], object.updatedAt);
}

ThemeSettingsEntity _themeSettingsEntityDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ThemeSettingsEntity();
  object.darkMode = reader.readBool(offsets[0]);
  object.id = id;
  object.ownerUsername = reader.readString(offsets[1]);
  object.selectedTheme = reader.readString(offsets[2]);
  object.updatedAt = reader.readDateTime(offsets[3]);
  return object;
}

P _themeSettingsEntityDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readBool(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _themeSettingsEntityGetId(ThemeSettingsEntity object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _themeSettingsEntityGetLinks(
  ThemeSettingsEntity object,
) {
  return [];
}

void _themeSettingsEntityAttach(
  IsarCollection<dynamic> col,
  Id id,
  ThemeSettingsEntity object,
) {
  object.id = id;
}

extension ThemeSettingsEntityByIndex on IsarCollection<ThemeSettingsEntity> {
  Future<ThemeSettingsEntity?> getByOwnerUsername(String ownerUsername) {
    return getByIndex(r'ownerUsername', [ownerUsername]);
  }

  ThemeSettingsEntity? getByOwnerUsernameSync(String ownerUsername) {
    return getByIndexSync(r'ownerUsername', [ownerUsername]);
  }

  Future<bool> deleteByOwnerUsername(String ownerUsername) {
    return deleteByIndex(r'ownerUsername', [ownerUsername]);
  }

  bool deleteByOwnerUsernameSync(String ownerUsername) {
    return deleteByIndexSync(r'ownerUsername', [ownerUsername]);
  }

  Future<List<ThemeSettingsEntity?>> getAllByOwnerUsername(
    List<String> ownerUsernameValues,
  ) {
    final values = ownerUsernameValues.map((e) => [e]).toList();
    return getAllByIndex(r'ownerUsername', values);
  }

  List<ThemeSettingsEntity?> getAllByOwnerUsernameSync(
    List<String> ownerUsernameValues,
  ) {
    final values = ownerUsernameValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'ownerUsername', values);
  }

  Future<int> deleteAllByOwnerUsername(List<String> ownerUsernameValues) {
    final values = ownerUsernameValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'ownerUsername', values);
  }

  int deleteAllByOwnerUsernameSync(List<String> ownerUsernameValues) {
    final values = ownerUsernameValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'ownerUsername', values);
  }

  Future<Id> putByOwnerUsername(ThemeSettingsEntity object) {
    return putByIndex(r'ownerUsername', object);
  }

  Id putByOwnerUsernameSync(
    ThemeSettingsEntity object, {
    bool saveLinks = true,
  }) {
    return putByIndexSync(r'ownerUsername', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByOwnerUsername(List<ThemeSettingsEntity> objects) {
    return putAllByIndex(r'ownerUsername', objects);
  }

  List<Id> putAllByOwnerUsernameSync(
    List<ThemeSettingsEntity> objects, {
    bool saveLinks = true,
  }) {
    return putAllByIndexSync(r'ownerUsername', objects, saveLinks: saveLinks);
  }
}

extension ThemeSettingsEntityQueryWhereSort
    on QueryBuilder<ThemeSettingsEntity, ThemeSettingsEntity, QWhere> {
  QueryBuilder<ThemeSettingsEntity, ThemeSettingsEntity, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension ThemeSettingsEntityQueryWhere
    on QueryBuilder<ThemeSettingsEntity, ThemeSettingsEntity, QWhereClause> {
  QueryBuilder<ThemeSettingsEntity, ThemeSettingsEntity, QAfterWhereClause>
  idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<ThemeSettingsEntity, ThemeSettingsEntity, QAfterWhereClause>
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

  QueryBuilder<ThemeSettingsEntity, ThemeSettingsEntity, QAfterWhereClause>
  idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<ThemeSettingsEntity, ThemeSettingsEntity, QAfterWhereClause>
  idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<ThemeSettingsEntity, ThemeSettingsEntity, QAfterWhereClause>
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

  QueryBuilder<ThemeSettingsEntity, ThemeSettingsEntity, QAfterWhereClause>
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

  QueryBuilder<ThemeSettingsEntity, ThemeSettingsEntity, QAfterWhereClause>
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
}

extension ThemeSettingsEntityQueryFilter
    on
        QueryBuilder<
          ThemeSettingsEntity,
          ThemeSettingsEntity,
          QFilterCondition
        > {
  QueryBuilder<ThemeSettingsEntity, ThemeSettingsEntity, QAfterFilterCondition>
  darkModeEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'darkMode', value: value),
      );
    });
  }

  QueryBuilder<ThemeSettingsEntity, ThemeSettingsEntity, QAfterFilterCondition>
  idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<ThemeSettingsEntity, ThemeSettingsEntity, QAfterFilterCondition>
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

  QueryBuilder<ThemeSettingsEntity, ThemeSettingsEntity, QAfterFilterCondition>
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

  QueryBuilder<ThemeSettingsEntity, ThemeSettingsEntity, QAfterFilterCondition>
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

  QueryBuilder<ThemeSettingsEntity, ThemeSettingsEntity, QAfterFilterCondition>
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

  QueryBuilder<ThemeSettingsEntity, ThemeSettingsEntity, QAfterFilterCondition>
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

  QueryBuilder<ThemeSettingsEntity, ThemeSettingsEntity, QAfterFilterCondition>
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

  QueryBuilder<ThemeSettingsEntity, ThemeSettingsEntity, QAfterFilterCondition>
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

  QueryBuilder<ThemeSettingsEntity, ThemeSettingsEntity, QAfterFilterCondition>
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

  QueryBuilder<ThemeSettingsEntity, ThemeSettingsEntity, QAfterFilterCondition>
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

  QueryBuilder<ThemeSettingsEntity, ThemeSettingsEntity, QAfterFilterCondition>
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

  QueryBuilder<ThemeSettingsEntity, ThemeSettingsEntity, QAfterFilterCondition>
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

  QueryBuilder<ThemeSettingsEntity, ThemeSettingsEntity, QAfterFilterCondition>
  ownerUsernameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'ownerUsername', value: ''),
      );
    });
  }

  QueryBuilder<ThemeSettingsEntity, ThemeSettingsEntity, QAfterFilterCondition>
  ownerUsernameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'ownerUsername', value: ''),
      );
    });
  }

  QueryBuilder<ThemeSettingsEntity, ThemeSettingsEntity, QAfterFilterCondition>
  selectedThemeEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'selectedTheme',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ThemeSettingsEntity, ThemeSettingsEntity, QAfterFilterCondition>
  selectedThemeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'selectedTheme',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ThemeSettingsEntity, ThemeSettingsEntity, QAfterFilterCondition>
  selectedThemeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'selectedTheme',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ThemeSettingsEntity, ThemeSettingsEntity, QAfterFilterCondition>
  selectedThemeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'selectedTheme',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ThemeSettingsEntity, ThemeSettingsEntity, QAfterFilterCondition>
  selectedThemeStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'selectedTheme',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ThemeSettingsEntity, ThemeSettingsEntity, QAfterFilterCondition>
  selectedThemeEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'selectedTheme',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ThemeSettingsEntity, ThemeSettingsEntity, QAfterFilterCondition>
  selectedThemeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'selectedTheme',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ThemeSettingsEntity, ThemeSettingsEntity, QAfterFilterCondition>
  selectedThemeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'selectedTheme',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ThemeSettingsEntity, ThemeSettingsEntity, QAfterFilterCondition>
  selectedThemeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'selectedTheme', value: ''),
      );
    });
  }

  QueryBuilder<ThemeSettingsEntity, ThemeSettingsEntity, QAfterFilterCondition>
  selectedThemeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'selectedTheme', value: ''),
      );
    });
  }

  QueryBuilder<ThemeSettingsEntity, ThemeSettingsEntity, QAfterFilterCondition>
  updatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'updatedAt', value: value),
      );
    });
  }

  QueryBuilder<ThemeSettingsEntity, ThemeSettingsEntity, QAfterFilterCondition>
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

  QueryBuilder<ThemeSettingsEntity, ThemeSettingsEntity, QAfterFilterCondition>
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

  QueryBuilder<ThemeSettingsEntity, ThemeSettingsEntity, QAfterFilterCondition>
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

extension ThemeSettingsEntityQueryObject
    on
        QueryBuilder<
          ThemeSettingsEntity,
          ThemeSettingsEntity,
          QFilterCondition
        > {}

extension ThemeSettingsEntityQueryLinks
    on
        QueryBuilder<
          ThemeSettingsEntity,
          ThemeSettingsEntity,
          QFilterCondition
        > {}

extension ThemeSettingsEntityQuerySortBy
    on QueryBuilder<ThemeSettingsEntity, ThemeSettingsEntity, QSortBy> {
  QueryBuilder<ThemeSettingsEntity, ThemeSettingsEntity, QAfterSortBy>
  sortByDarkMode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'darkMode', Sort.asc);
    });
  }

  QueryBuilder<ThemeSettingsEntity, ThemeSettingsEntity, QAfterSortBy>
  sortByDarkModeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'darkMode', Sort.desc);
    });
  }

  QueryBuilder<ThemeSettingsEntity, ThemeSettingsEntity, QAfterSortBy>
  sortByOwnerUsername() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ownerUsername', Sort.asc);
    });
  }

  QueryBuilder<ThemeSettingsEntity, ThemeSettingsEntity, QAfterSortBy>
  sortByOwnerUsernameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ownerUsername', Sort.desc);
    });
  }

  QueryBuilder<ThemeSettingsEntity, ThemeSettingsEntity, QAfterSortBy>
  sortBySelectedTheme() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'selectedTheme', Sort.asc);
    });
  }

  QueryBuilder<ThemeSettingsEntity, ThemeSettingsEntity, QAfterSortBy>
  sortBySelectedThemeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'selectedTheme', Sort.desc);
    });
  }

  QueryBuilder<ThemeSettingsEntity, ThemeSettingsEntity, QAfterSortBy>
  sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<ThemeSettingsEntity, ThemeSettingsEntity, QAfterSortBy>
  sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension ThemeSettingsEntityQuerySortThenBy
    on QueryBuilder<ThemeSettingsEntity, ThemeSettingsEntity, QSortThenBy> {
  QueryBuilder<ThemeSettingsEntity, ThemeSettingsEntity, QAfterSortBy>
  thenByDarkMode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'darkMode', Sort.asc);
    });
  }

  QueryBuilder<ThemeSettingsEntity, ThemeSettingsEntity, QAfterSortBy>
  thenByDarkModeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'darkMode', Sort.desc);
    });
  }

  QueryBuilder<ThemeSettingsEntity, ThemeSettingsEntity, QAfterSortBy>
  thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<ThemeSettingsEntity, ThemeSettingsEntity, QAfterSortBy>
  thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<ThemeSettingsEntity, ThemeSettingsEntity, QAfterSortBy>
  thenByOwnerUsername() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ownerUsername', Sort.asc);
    });
  }

  QueryBuilder<ThemeSettingsEntity, ThemeSettingsEntity, QAfterSortBy>
  thenByOwnerUsernameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ownerUsername', Sort.desc);
    });
  }

  QueryBuilder<ThemeSettingsEntity, ThemeSettingsEntity, QAfterSortBy>
  thenBySelectedTheme() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'selectedTheme', Sort.asc);
    });
  }

  QueryBuilder<ThemeSettingsEntity, ThemeSettingsEntity, QAfterSortBy>
  thenBySelectedThemeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'selectedTheme', Sort.desc);
    });
  }

  QueryBuilder<ThemeSettingsEntity, ThemeSettingsEntity, QAfterSortBy>
  thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<ThemeSettingsEntity, ThemeSettingsEntity, QAfterSortBy>
  thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension ThemeSettingsEntityQueryWhereDistinct
    on QueryBuilder<ThemeSettingsEntity, ThemeSettingsEntity, QDistinct> {
  QueryBuilder<ThemeSettingsEntity, ThemeSettingsEntity, QDistinct>
  distinctByDarkMode() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'darkMode');
    });
  }

  QueryBuilder<ThemeSettingsEntity, ThemeSettingsEntity, QDistinct>
  distinctByOwnerUsername({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'ownerUsername',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<ThemeSettingsEntity, ThemeSettingsEntity, QDistinct>
  distinctBySelectedTheme({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'selectedTheme',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<ThemeSettingsEntity, ThemeSettingsEntity, QDistinct>
  distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }
}

extension ThemeSettingsEntityQueryProperty
    on QueryBuilder<ThemeSettingsEntity, ThemeSettingsEntity, QQueryProperty> {
  QueryBuilder<ThemeSettingsEntity, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<ThemeSettingsEntity, bool, QQueryOperations> darkModeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'darkMode');
    });
  }

  QueryBuilder<ThemeSettingsEntity, String, QQueryOperations>
  ownerUsernameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'ownerUsername');
    });
  }

  QueryBuilder<ThemeSettingsEntity, String, QQueryOperations>
  selectedThemeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'selectedTheme');
    });
  }

  QueryBuilder<ThemeSettingsEntity, DateTime, QQueryOperations>
  updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }
}
