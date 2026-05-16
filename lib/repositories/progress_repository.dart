import 'package:isar/isar.dart';

import '../core/constants/default_learning_catalog.dart';
import '../database/collections/learning_progress_collection.dart';
import '../database/isar_database_service.dart';

class ProgressRepository {
  ProgressRepository(this._database);

  final IsarDatabaseService _database;

  Future<void> ensureDefaults(String username) async {
    final owner = username.toLowerCase().trim();
    await _database.write((isar) async {
      for (final category in LearningCategories.progressCategories) {
        final existing = await isar.learningProgressEntitys
            .filter()
            .ownerUsernameEqualTo(owner)
            .categoryEqualTo(category)
            .findFirst();
        if (existing != null) continue;
        await isar.learningProgressEntitys.put(
          LearningProgressEntity()
            ..ownerUsername = owner
            ..category = category
            ..progressPercent = 0
            ..completedItems = 0
            ..totalItems = DefaultLearningCatalog.totalForCategory(category)
            ..updatedAt = DateTime.now(),
        );
      }
    });
  }

  Future<Map<String, int>> loadProgress(String username) async {
    final owner = username.toLowerCase().trim();
    final items = await _database.read(
      (isar) => isar.learningProgressEntitys
          .filter()
          .ownerUsernameEqualTo(owner)
          .findAll(),
    );
    final progress = <String, int>{
      LearningCategories.appStateHuruf: 0,
      LearningCategories.angka: 0,
      LearningCategories.benda: 0,
      LearningCategories.iqra: 0,
      LearningCategories.modeSeru: 0,
    };
    for (final item in items) {
      progress[LearningCategories.appStateKey(item.category)] =
          item.progressPercent;
    }
    return progress;
  }

  Future<void> syncProgress({
    required String username,
    required Map<String, int> progress,
    required List<String> hurfMastered,
    required List<String> angkaMastered,
    required List<String> bendaMastered,
    required List<String> iqraMastered,
  }) async {
    final owner = username.toLowerCase().trim();
    await ensureDefaults(owner);
    final masteryMap = <String, List<String>>{
      LearningCategories.huruf: hurfMastered,
      LearningCategories.angka: angkaMastered,
      LearningCategories.benda: bendaMastered,
      LearningCategories.iqra: iqraMastered,
      LearningCategories.modeSeru: const [],
    };

    await _database.write((isar) async {
      for (final entry in masteryMap.entries) {
        final category = entry.key;
        final existing = await isar.learningProgressEntitys
            .filter()
            .ownerUsernameEqualTo(owner)
            .categoryEqualTo(category)
            .findFirst();
        final entity = existing ?? LearningProgressEntity()
          ..ownerUsername = owner
          ..category = category;
        entity
          ..completedKeys = List<String>.from(entry.value)
          ..completedItems = entry.value.length
          ..totalItems = DefaultLearningCatalog.totalForCategory(category)
          ..progressPercent =
              progress[LearningCategories.appStateKey(category)] ?? 0
          ..updatedAt = DateTime.now();
        await isar.learningProgressEntitys.put(entity);
      }
    });
  }
}
