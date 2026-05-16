import 'package:isar/isar.dart';

import '../database/collections/theme_settings_collection.dart';
import '../database/isar_database_service.dart';

class ThemeRepository {
  ThemeRepository(this._database);

  final IsarDatabaseService _database;

  Future<String?> loadThemeId(String ownerUsername) async {
    final entity = await _database.read(
      (isar) => isar.themeSettingsEntitys
          .filter()
          .ownerUsernameEqualTo(ownerUsername)
          .findFirst(),
    );
    return entity?.selectedTheme;
  }

  Future<void> saveTheme({
    required String ownerUsername,
    required String themeId,
    required bool darkMode,
  }) async {
    final owner = ownerUsername.trim().isEmpty
        ? 'guest'
        : ownerUsername.toLowerCase().trim();
    final existing = await _database.read(
      (isar) => isar.themeSettingsEntitys
          .filter()
          .ownerUsernameEqualTo(owner)
          .findFirst(),
    );
    final entity = existing ?? ThemeSettingsEntity()
      ..ownerUsername = owner;
    entity
      ..selectedTheme = themeId
      ..darkMode = darkMode
      ..updatedAt = DateTime.now();
    await _database.write((isar) => isar.themeSettingsEntitys.put(entity));
  }
}
