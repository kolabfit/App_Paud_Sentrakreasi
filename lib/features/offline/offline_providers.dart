import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../database/isar_database_service.dart';
import '../../repositories/badge_repository.dart';
import '../../repositories/history_repository.dart';
import '../../repositories/material_repository.dart';
import '../../repositories/progress_repository.dart';
import '../../repositories/theme_repository.dart';
import '../../repositories/user_repository.dart';
import '../../services/legacy_migration_service.dart';
import '../../services/offline_bootstrap_service.dart';
import '../../storage/local_storage_service.dart';

final isarDatabaseServiceProvider = Provider<IsarDatabaseService>(
  (ref) => IsarDatabaseService.instance,
);

final localStorageServiceProvider = Provider<LocalStorageService>(
  (ref) => LocalStorageService.instance,
);

final userRepositoryProvider = Provider<UserRepository>(
  (ref) => UserRepository(ref.watch(isarDatabaseServiceProvider)),
);

final progressRepositoryProvider = Provider<ProgressRepository>(
  (ref) => ProgressRepository(ref.watch(isarDatabaseServiceProvider)),
);

final materialRepositoryProvider = Provider<MaterialRepository>(
  (ref) => MaterialRepository(ref.watch(isarDatabaseServiceProvider)),
);

final themeRepositoryProvider = Provider<ThemeRepository>(
  (ref) => ThemeRepository(ref.watch(isarDatabaseServiceProvider)),
);

final historyRepositoryProvider = Provider<HistoryRepository>(
  (ref) => HistoryRepository(ref.watch(isarDatabaseServiceProvider)),
);

final badgeRepositoryProvider = Provider<BadgeRepository>(
  (ref) => BadgeRepository(ref.watch(isarDatabaseServiceProvider)),
);

final legacyMigrationServiceProvider = Provider<LegacyMigrationService>(
  (ref) => LegacyMigrationService(
    userRepository: ref.watch(userRepositoryProvider),
    progressRepository: ref.watch(progressRepositoryProvider),
    materialRepository: ref.watch(materialRepositoryProvider),
    themeRepository: ref.watch(themeRepositoryProvider),
    storageService: ref.watch(localStorageServiceProvider),
  ),
);

final offlineBootstrapServiceProvider = Provider<OfflineBootstrapService>(
  (ref) => OfflineBootstrapService(
    database: ref.watch(isarDatabaseServiceProvider),
    storageService: ref.watch(localStorageServiceProvider),
    materialRepository: ref.watch(materialRepositoryProvider),
    themeRepository: ref.watch(themeRepositoryProvider),
    legacyMigrationService: ref.watch(legacyMigrationServiceProvider),
  ),
);
