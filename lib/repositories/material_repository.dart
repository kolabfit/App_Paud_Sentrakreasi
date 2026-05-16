import 'package:isar/isar.dart';

import '../core/constants/default_learning_catalog.dart';
import '../database/collections/learning_material_collection.dart';
import '../database/isar_database_service.dart';

class MaterialRepository {
  MaterialRepository(this._database);

  final IsarDatabaseService _database;

  Future<void> seedDefaults({required Map<String, String> seededPaths}) async {
    await _database.write((isar) async {
      final hasAny = await isar.learningMaterialEntitys.count() > 0;
      if (hasAny) return;
      final entities = <LearningMaterialEntity>[
        ...DefaultLearningCatalog.hurufSeed.map(
          (letter) => LearningMaterialEntity()
            ..materialId = 'huruf_$letter'
            ..title = 'Huruf $letter'
            ..category = LearningCategories.huruf
            ..imagePath =
                seededPaths[DefaultStorageFiles.hurufImage] ??
                DefaultLearningCatalog.hurufPlaceholderAsset
            ..createdAt = DateTime.now()
            ..updatedAt = DateTime.now(),
        ),
        ...DefaultLearningCatalog.angkaSeed.map(
          (number) => LearningMaterialEntity()
            ..materialId = 'angka_$number'
            ..title = 'Angka $number'
            ..category = LearningCategories.angka
            ..imagePath =
                seededPaths[DefaultStorageFiles.angkaImage] ??
                DefaultLearningCatalog.angkaPlaceholderAsset
            ..createdAt = DateTime.now()
            ..updatedAt = DateTime.now(),
        ),
        ...DefaultLearningCatalog.bendaSeed.map(
          (item) => LearningMaterialEntity()
            ..materialId = 'benda_${item['title']!.toLowerCase()}'
            ..title = item['title']!
            ..subcategory = item['subcategory']!
            ..category = LearningCategories.benda
            ..imagePath =
                seededPaths[DefaultStorageFiles.bendaImage] ??
                DefaultLearningCatalog.bendaPlaceholderAsset
            ..createdAt = DateTime.now()
            ..updatedAt = DateTime.now(),
        ),
        ...DefaultLearningCatalog.iqraSeed.map(
          (item) => LearningMaterialEntity()
            ..materialId = 'iqra_${item.toLowerCase()}'
            ..title = item
            ..category = LearningCategories.iqra
            ..imagePath =
                seededPaths[DefaultStorageFiles.iqraImage] ??
                DefaultLearningCatalog.iqraPlaceholderAsset
            ..createdAt = DateTime.now()
            ..updatedAt = DateTime.now(),
        ),
      ];
      await isar.learningMaterialEntitys.putAll(entities);
    });
  }

  Future<List<LearningMaterialEntity>> loadByCategory(String category) {
    return _database.read(
      (isar) => isar.learningMaterialEntitys
          .where()
          .filter()
          .categoryEqualTo(category)
          .sortByCreatedAtDesc()
          .findAll(),
    );
  }

  Future<List<LearningMaterialEntity>> loadSongs() =>
      loadByCategory(LearningCategories.lagu);

  Future<void> replaceSongs(List<LearningMaterialEntity> items) async {
    await _database.write((isar) async {
      final existing = await isar.learningMaterialEntitys
          .filter()
          .categoryEqualTo(LearningCategories.lagu)
          .findAll();
      if (existing.isNotEmpty) {
        await isar.learningMaterialEntitys.deleteAll(
          existing.map((e) => e.id).toList(),
        );
      }
      await isar.learningMaterialEntitys.putAll(items);
    });
  }

  Future<LearningMaterialEntity> saveObject({
    required String title,
    required String imagePath,
    required String subcategory,
  }) async {
    final entity = LearningMaterialEntity()
      ..materialId =
          'benda_${title.toLowerCase()}_${DateTime.now().millisecondsSinceEpoch}'
      ..title = title
      ..subcategory = subcategory
      ..category = LearningCategories.benda
      ..imagePath = imagePath
      ..createdAt = DateTime.now()
      ..updatedAt = DateTime.now();
    await _database.write((isar) => isar.learningMaterialEntitys.put(entity));
    return entity;
  }

  Future<void> deleteMaterialById(String materialId) async {
    await _database.write((isar) async {
      final entity = await isar.learningMaterialEntitys
          .filter()
          .materialIdEqualTo(materialId)
          .findFirst();
      if (entity != null) {
        await isar.learningMaterialEntitys.delete(entity.id);
      }
    });
  }

  Future<void> upsertSong({
    required String id,
    required String title,
    required String videoPath,
    String? fileName,
  }) async {
    await _database.write((isar) async {
      final existing = await isar.learningMaterialEntitys
          .filter()
          .materialIdEqualTo(id)
          .findFirst();
      final entity = existing ?? LearningMaterialEntity()
        ..materialId = id;
      entity
        ..title = title
        ..category = LearningCategories.lagu
        ..videoPath = videoPath
        ..fileName = fileName ?? ''
        ..thumbnailPath = ''
        ..createdAt = existing?.createdAt ?? DateTime.now()
        ..updatedAt = DateTime.now();
      await isar.learningMaterialEntitys.put(entity);
    });
  }

  Future<void> setFavoriteState(Set<String> favoriteIds) async {
    await _database.write((isar) async {
      final items = await isar.learningMaterialEntitys.where().findAll();
      for (final item in items) {
        item.favorite = favoriteIds.contains(item.materialId);
      }
      await isar.learningMaterialEntitys.putAll(items);
    });
  }
}
