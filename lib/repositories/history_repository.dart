import '../database/collections/learning_history_collection.dart';
import '../database/isar_database_service.dart';
import '../models/app_local_models.dart';

class HistoryRepository {
  HistoryRepository(this._database);

  final IsarDatabaseService _database;

  Future<void> addRecord(String username, LearningHistoryRecord record) async {
    final owner = username.toLowerCase().trim();
    await _database.write(
      (isar) => isar.learningHistoryEntitys.put(
        LearningHistoryEntity()
          ..ownerUsername = owner
          ..materialId = record.materialId
          ..category = record.category
          ..duration = record.duration
          ..score = record.score
          ..playedAt = record.playedAt,
      ),
    );
  }
}
