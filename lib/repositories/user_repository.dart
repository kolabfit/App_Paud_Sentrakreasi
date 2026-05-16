import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:isar/isar.dart';

import '../core/constants/default_learning_catalog.dart';
import '../database/collections/local_session_collection.dart';
import '../database/collections/user_profile_collection.dart';
import '../database/isar_database_service.dart';
import '../models/app_local_models.dart';

class UserRepository {
  UserRepository(this._database);

  final IsarDatabaseService _database;

  Future<UserAccount?> currentAccount({
    required dynamic Function(String value) genderParser,
    required dynamic Function(String value) roleParser,
  }) async {
    final username = await currentUsername();
    if (username == null) return null;
    final profile = await _profileByUsername(username);
    if (profile == null) return null;
    return _toAccount(
      profile,
      genderParser: genderParser,
      roleParser: roleParser,
    );
  }

  Future<String?> currentUsername() async {
    final session = await _database.read(
      (isar) => isar.localSessionEntitys.get(0),
    );
    return session?.currentUsername;
  }

  Future<void> clearSession() async {
    await _database.write((isar) async {
      await isar.localSessionEntitys.put(
        LocalSessionEntity()
          ..id = 0
          ..currentUsername = null
          ..updatedAt = DateTime.now(),
      );
    });
  }

  Future<UserAccount> authenticate({
    required String username,
    required String password,
    required bool register,
    required bool autoCreate,
    required dynamic role,
    required String childName,
    required dynamic gender,
    required String themeId,
    required Map<String, int> defaultProgress,
    required int defaultStars,
    required dynamic Function(String value) genderParser,
    required dynamic Function(String value) roleParser,
  }) async {
    final normalized = _normalizeUsername(username);
    final saved = await _profileByUsername(normalized);
    final hash = _hash(password);
    final now = DateTime.now();
    final genderName = _enumName(gender, fallback: 'boy');
    final roleName = _enumName(role, fallback: 'child');

    if (saved == null) {
      if (!register && !autoCreate) throw 'Akun belum terdaftar';
      final created = UserProfileEntity()
        ..username = normalized
        ..childName = childName
        ..gender = genderName
        ..role = roleName
        ..themeId = themeId
        ..avatarPath = genderName == 'girl'
            ? DefaultLearningCatalog.avatarGirlAsset
            : DefaultLearningCatalog.avatarBoyAsset
        ..passwordHash = hash
        ..xp = defaultStars
        ..coins = defaultStars
        ..stars = defaultStars
        ..level = _levelFromStars(defaultStars)
        ..createdAt = now
        ..updatedAt = now;
      await _database.write((isar) async {
        await isar.userProfileEntitys.put(created);
        await isar.localSessionEntitys.put(
          LocalSessionEntity()
            ..id = 0
            ..currentUsername = normalized
            ..updatedAt = now,
        );
      });
      return _toAccount(
        created,
        genderParser: genderParser,
        roleParser: roleParser,
      );
    }

    if (register) throw 'Username sudah terdaftar';
    if (saved.passwordHash.isNotEmpty && saved.passwordHash != hash) {
      throw 'Password salah';
    }

    saved.passwordHash = hash;
    saved.updatedAt = now;
    await _database.write((isar) async {
      await isar.userProfileEntitys.put(saved);
      await isar.localSessionEntitys.put(
        LocalSessionEntity()
          ..id = 0
          ..currentUsername = normalized
          ..updatedAt = now,
      );
    });
    return _toAccount(
      saved,
      genderParser: genderParser,
      roleParser: roleParser,
    );
  }

  Future<void> saveAccount(UserAccount account) async {
    final username = _normalizeUsername(account.username);
    final existing = await _profileByUsername(username);
    final now = DateTime.now();
    final entity = existing ?? UserProfileEntity();
    final genderName = _enumName(account.gender, fallback: 'boy');
    final roleName = _enumName(account.role, fallback: 'child');
    entity
      ..username = username
      ..childName = account.childName
      ..gender = genderName
      ..role = roleName
      ..themeId = account.themeId
      ..avatarPath = account.avatarPath.isEmpty
          ? (genderName == 'girl'
                ? DefaultLearningCatalog.avatarGirlAsset
                : DefaultLearningCatalog.avatarBoyAsset)
          : account.avatarPath
      ..xp = account.stars
      ..coins = account.stars
      ..stars = account.stars
      ..level = _levelFromStars(account.stars)
      ..iqraStreak = account.iqraStreak
      ..iqraMastered = List<String>.from(account.iqraMastered)
      ..iqraHistory = List<String>.from(account.iqraHistory)
      ..hurfMastered = List<String>.from(account.hurfMastered)
      ..angkaMastered = List<String>.from(account.angkaMastered)
      ..bendaMastered = List<String>.from(account.bendaMastered)
      ..favoriteMaterialIds = List<String>.from(account.favoriteMaterialIds)
      ..createdAt = existing?.createdAt ?? account.createdAt ?? now
      ..updatedAt = now;
    await _database.write((isar) => isar.userProfileEntitys.put(entity));
  }

  Future<void> migrateLegacyAccount({
    required String username,
    required String childName,
    required dynamic gender,
    required dynamic role,
    required String themeId,
    required int stars,
    required int iqraStreak,
    required Map<String, int> progress,
    required List<String> iqraMastered,
    required List<String> iqraHistory,
    List<String> hurfMastered = const [],
    List<String> angkaMastered = const [],
    List<String> bendaMastered = const [],
    List<String> favoriteMaterialIds = const [],
  }) async {
    final normalized = _normalizeUsername(username);
    final existing = await _profileByUsername(normalized);
    if (existing != null) return;
    final now = DateTime.now();
    final genderName = _enumName(gender, fallback: 'boy');
    final roleName = _enumName(role, fallback: 'child');
    final entity = UserProfileEntity()
      ..username = normalized
      ..childName = childName
      ..gender = genderName
      ..role = roleName
      ..themeId = themeId
      ..avatarPath = genderName == 'girl'
          ? DefaultLearningCatalog.avatarGirlAsset
          : DefaultLearningCatalog.avatarBoyAsset
      ..xp = stars
      ..coins = stars
      ..stars = stars
      ..level = _levelFromStars(stars)
      ..iqraStreak = iqraStreak
      ..iqraMastered = List<String>.from(iqraMastered)
      ..iqraHistory = List<String>.from(iqraHistory)
      ..hurfMastered = List<String>.from(hurfMastered)
      ..angkaMastered = List<String>.from(angkaMastered)
      ..bendaMastered = List<String>.from(bendaMastered)
      ..favoriteMaterialIds = List<String>.from(favoriteMaterialIds)
      ..createdAt = now
      ..updatedAt = now;
    await _database.write((isar) async {
      await isar.userProfileEntitys.put(entity);
      await isar.localSessionEntitys.put(
        LocalSessionEntity()
          ..id = 0
          ..currentUsername = normalized
          ..updatedAt = now,
      );
    });
  }

  Future<List<String>> favoriteIds(String username) async {
    final profile = await _profileByUsername(username);
    return profile == null
        ? const []
        : List<String>.from(profile.favoriteMaterialIds);
  }

  Future<void> saveFavoriteIds(String username, Iterable<String> ids) async {
    final profile = await _profileByUsername(username);
    if (profile == null) return;
    profile
      ..favoriteMaterialIds = ids.toSet().toList()
      ..updatedAt = DateTime.now();
    await _database.write((isar) => isar.userProfileEntitys.put(profile));
  }

  Future<UserProfileEntity?> _profileByUsername(String username) {
    return _database.read(
      (isar) => isar.userProfileEntitys
          .filter()
          .usernameEqualTo(_normalizeUsername(username))
          .findFirst(),
    );
  }

  UserAccount _toAccount(
    UserProfileEntity profile, {
    required dynamic Function(String value) genderParser,
    required dynamic Function(String value) roleParser,
  }) {
    return UserAccount(
      username: profile.username,
      childName: profile.childName,
      gender: genderParser(profile.gender),
      role: roleParser(profile.role),
      themeId: profile.themeId,
      stars: profile.stars,
      iqraStreak: profile.iqraStreak,
      progress: const {},
      iqraMastered: List<String>.from(profile.iqraMastered),
      iqraHistory: List<String>.from(profile.iqraHistory),
      hurfMastered: List<String>.from(profile.hurfMastered),
      angkaMastered: List<String>.from(profile.angkaMastered),
      bendaMastered: List<String>.from(profile.bendaMastered),
      favoriteMaterialIds: List<String>.from(profile.favoriteMaterialIds),
      avatarPath: profile.avatarPath,
      createdAt: profile.createdAt,
    );
  }

  String _normalizeUsername(String username) => username.toLowerCase().trim();

  String _enumName(dynamic value, {required String fallback}) {
    if (value is Enum) return value.name;
    if (value is String) {
      final normalized = value.toLowerCase().trim();
      return normalized.isEmpty ? fallback : normalized;
    }
    final dynamicName = value?.name;
    if (dynamicName is String && dynamicName.isNotEmpty) {
      return dynamicName.toLowerCase().trim();
    }
    return fallback;
  }

  String _hash(String password) =>
      sha256.convert(utf8.encode(password)).toString();

  int _levelFromStars(int stars) => (stars ~/ 100 + 1).clamp(1, 5);
}
