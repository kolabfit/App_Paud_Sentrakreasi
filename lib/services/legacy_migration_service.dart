import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast_io.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/constants/default_learning_catalog.dart';
import '../database/collections/learning_material_collection.dart';
import '../repositories/material_repository.dart';
import '../repositories/progress_repository.dart';
import '../repositories/theme_repository.dart';
import '../repositories/user_repository.dart';
import '../storage/local_storage_service.dart';

class LegacyMigrationService {
  LegacyMigrationService({
    required this.userRepository,
    required this.progressRepository,
    required this.materialRepository,
    required this.themeRepository,
    required this.storageService,
  });

  final UserRepository userRepository;
  final ProgressRepository progressRepository;
  final MaterialRepository materialRepository;
  final ThemeRepository themeRepository;
  final LocalStorageService storageService;

  Future<void> migrateIfNeeded() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool('khoir_quest_offline_migration_v1') == true) return;

    if (!kIsWeb) {
      final supportDir = await getApplicationSupportDirectory();
      final legacyPath = p.join(supportDir.path, 'belajar_yuk.db');
      final legacyFile = File(legacyPath);
      if (await legacyFile.exists()) {
        final db = await databaseFactoryIo.openDatabase(legacyPath, version: 1);
        await _migrateAccounts(db);
        await _migrateSongs(db);
        await db.close();
      }
    }

    final savedTheme = prefs.getString('themeId') ?? 'default';
    await themeRepository.saveTheme(
      ownerUsername: 'guest',
      themeId: savedTheme,
      darkMode: savedTheme.toLowerCase().contains('malam'),
    );

    await prefs.setBool('khoir_quest_offline_migration_v1', true);
  }

  Future<void> _migrateAccounts(Database db) async {
    final accountsStore = stringMapStoreFactory.store('accounts');
    final sessionStore = stringMapStoreFactory.store('session');
    final session = await sessionStore.record('current').get(db);
    final current = session?['username']?.toString();
    final accounts = await accountsStore.find(db);
    for (final snapshot in accounts) {
      final raw = snapshot.value;
      final username = raw['username']?.toString();
      if (username == null || username.isEmpty) continue;
      final progress = <String, int>{};
      final rawProgress = raw['progress'];
      if (rawProgress is Map) {
        for (final entry in rawProgress.entries) {
          progress[entry.key.toString()] = (entry.value as num?)?.toInt() ?? 0;
        }
      }
      await userRepository.migrateLegacyAccount(
        username: username,
        childName: raw['childName']?.toString() ?? 'Teman',
        gender: _EnumLike(raw['gender'] == 'girl' ? 'girl' : 'boy'),
        role: _EnumLike(raw['role'] == 'teacher' ? 'teacher' : 'child'),
        themeId: raw['themeId']?.toString() ?? 'default',
        stars: (raw['stars'] as num?)?.toInt() ?? 12,
        iqraStreak: (raw['iqraStreak'] as num?)?.toInt() ?? 0,
        progress: progress,
        iqraMastered: List<String>.from(
          raw['iqraMastered'] as List? ?? const [],
        ),
        iqraHistory: List<String>.from(raw['iqraHistory'] as List? ?? const []),
        hurfMastered: List<String>.from(
          raw['hurfMastered'] as List? ?? const [],
        ),
        angkaMastered: List<String>.from(
          raw['angkaMastered'] as List? ?? const [],
        ),
        bendaMastered: List<String>.from(
          raw['bendaMastered'] as List? ?? const [],
        ),
      );
      await progressRepository.syncProgress(
        username: username,
        progress: progress,
        hurfMastered: List<String>.from(
          raw['hurfMastered'] as List? ?? const [],
        ),
        angkaMastered: List<String>.from(
          raw['angkaMastered'] as List? ?? const [],
        ),
        bendaMastered: List<String>.from(
          raw['bendaMastered'] as List? ?? const [],
        ),
        iqraMastered: List<String>.from(
          raw['iqraMastered'] as List? ?? const [],
        ),
      );
      if (current != null && current == username.toLowerCase().trim()) {
        await userRepository.saveFavoriteIds(username, const []);
      }
    }
  }

  Future<void> _migrateSongs(Database db) async {
    final contentStore = stringMapStoreFactory.store('content');
    final data = await contentStore.record('songs').get(db);
    final rawSongs = data?['items'] as List?;
    if (rawSongs == null) return;
    final entities = <LearningMaterialEntity>[];
    for (final raw in rawSongs) {
      final item = Map<String, Object?>.from(raw as Map);
      final materialId =
          item['id']?.toString() ??
          DateTime.now().millisecondsSinceEpoch.toString();
      final title = item['title']?.toString() ?? 'Lagu Anak';
      final originalVideo = item['videoUrl']?.toString() ?? '';
      final fileName = item['fileName']?.toString() ?? '$materialId.mp4';
      String videoPath = originalVideo;
      if (originalVideo.startsWith('data:')) {
        videoPath =
            await storageService.persistDataUri(
              originalVideo,
              bucket: StorageBucket.songVideos,
              fileName: fileName,
            ) ??
            '';
      }
      entities.add(
        LearningMaterialEntity()
          ..materialId = materialId
          ..title = title
          ..category = LearningCategories.lagu
          ..videoPath = videoPath
          ..fileName = fileName
          ..createdAt = DateTime.now()
          ..updatedAt = DateTime.now(),
      );
    }
    if (entities.isNotEmpty) {
      await materialRepository.replaceSongs(entities);
    }
  }
}

class _EnumLike {
  const _EnumLike(this.name);
  final String name;
}
