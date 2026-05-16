import '../core/constants/default_learning_catalog.dart';
import '../database/isar_database_service.dart';
import '../repositories/material_repository.dart';
import '../repositories/theme_repository.dart';
import '../services/legacy_migration_service.dart';
import '../storage/local_storage_service.dart';

class OfflineBootstrapService {
  OfflineBootstrapService({
    required this.database,
    required this.storageService,
    required this.materialRepository,
    required this.themeRepository,
    required this.legacyMigrationService,
  });

  final IsarDatabaseService database;
  final LocalStorageService storageService;
  final MaterialRepository materialRepository;
  final ThemeRepository themeRepository;
  final LegacyMigrationService legacyMigrationService;

  bool _ready = false;

  Future<void> ensureReady() async {
    if (_ready) return;
    await storageService.ensureReady();
    await database.initDatabase();
    final seededPaths = await _seedDefaultStorage();
    await materialRepository.seedDefaults(seededPaths: seededPaths);
    await legacyMigrationService.migrateIfNeeded();
    final guestTheme = await themeRepository.loadThemeId('guest');
    if (guestTheme == null) {
      await themeRepository.saveTheme(
        ownerUsername: 'guest',
        themeId: 'default',
        darkMode: false,
      );
    }
    _ready = true;
  }

  Future<Map<String, String>> _seedDefaultStorage() async {
    return {
      DefaultStorageFiles.hurufImage: await storageService.ensureAssetFile(
        assetPath: DefaultLearningCatalog.hurufPlaceholderAsset,
        bucket: StorageBucket.hurufImages,
        fileName: 'default_huruf.png',
      ),
      DefaultStorageFiles.angkaImage: await storageService.ensureAssetFile(
        assetPath: DefaultLearningCatalog.angkaPlaceholderAsset,
        bucket: StorageBucket.hurufImages,
        fileName: 'default_angka.png',
      ),
      DefaultStorageFiles.bendaImage: await storageService.ensureAssetFile(
        assetPath: DefaultLearningCatalog.bendaPlaceholderAsset,
        bucket: StorageBucket.bendaImages,
        fileName: 'default_benda.png',
      ),
      DefaultStorageFiles.iqraImage: await storageService.ensureAssetFile(
        assetPath: DefaultLearningCatalog.iqraPlaceholderAsset,
        bucket: StorageBucket.hurufImages,
        fileName: 'default_iqra.png',
      ),
      DefaultStorageFiles.laguImage: await storageService.ensureAssetFile(
        assetPath: DefaultLearningCatalog.laguPlaceholderAsset,
        bucket: StorageBucket.bendaImages,
        fileName: 'default_lagu.png',
      ),
      DefaultStorageFiles.profileBoy: await storageService.ensureAssetFile(
        assetPath: DefaultLearningCatalog.avatarBoyAsset,
        bucket: StorageBucket.profileImages,
        fileName: 'profile_boy.png',
      ),
      DefaultStorageFiles.profileGirl: await storageService.ensureAssetFile(
        assetPath: DefaultLearningCatalog.avatarGirlAsset,
        bucket: StorageBucket.profileImages,
        fileName: 'profile_girl.png',
      ),
    };
  }
}
