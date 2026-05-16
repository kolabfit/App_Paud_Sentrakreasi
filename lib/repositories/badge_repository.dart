import 'package:isar/isar.dart';

import '../database/collections/badge_collection.dart';
import '../database/isar_database_service.dart';
import '../models/badge_definition.dart';

class BadgeRepository {
  BadgeRepository(this._database);

  final IsarDatabaseService _database;

  Future<void> ensureSeeded(String username) async {
    final owner = username.toLowerCase().trim();
    await _database.write((isar) async {
      for (final badge in badgeDefinitions) {
        final existing = await isar.badgeModelEntitys
            .filter()
            .codeEqualTo(badge.id)
            .ownerUsernameEqualTo(owner)
            .findFirst();
        final entity = existing ?? BadgeModelEntity()
          ..code = badge.id
          ..ownerUsername = owner;
        entity
          ..title = badge.title
          ..description = badge.description
          ..badgeImagePath = badge.assetUnlocked
          ..rarity = badge.rarity.name;
        await isar.badgeModelEntitys.put(entity);
      }
    });
  }

  Future<List<String>> syncUnlocks({
    required String username,
    required Map<String, int> progress,
  }) async {
    final owner = username.toLowerCase().trim();
    await ensureSeeded(owner);
    final unlockedIds = <String>[];
    await _database.write((isar) async {
      for (final badge in badgeDefinitions) {
        final entity = await isar.badgeModelEntitys
            .filter()
            .codeEqualTo(badge.id)
            .ownerUsernameEqualTo(owner)
            .findFirst();
        if (entity == null) continue;
        final current = _currentProgress(badge, progress);
        if (current >= badge.requiredProgress && !entity.unlocked) {
          entity
            ..unlocked = true
            ..unlockedAt = DateTime.now();
          unlockedIds.add(badge.id);
          await isar.badgeModelEntitys.put(entity);
        }
      }
    });
    return unlockedIds;
  }

  Future<Set<String>> savedUnlocks(String username) async {
    final owner = username.toLowerCase().trim();
    final items = await _database.read(
      (isar) => isar.badgeModelEntitys
          .filter()
          .ownerUsernameEqualTo(owner)
          .unlockedEqualTo(true)
          .findAll(),
    );
    return items.map((e) => e.code).toSet();
  }

  int _currentProgress(BadgeDefinition badge, Map<String, int> progress) {
    if (badge.progressKey == '_all_') {
      final values = [
        'membaca',
        'angka',
        'benda',
        'iqra',
      ].map((key) => progress[key] ?? 0).toList();
      if (values.isEmpty) return 0;
      return (values.reduce((a, b) => a + b) / values.length).round();
    }
    return progress[badge.progressKey] ?? 0;
  }
}
