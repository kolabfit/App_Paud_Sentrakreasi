import 'package:isar/isar.dart';

part 'learning_history_collection.g.dart';

@collection
class LearningHistoryEntity {
  Id id = Isar.autoIncrement;

  @Index()
  late String ownerUsername;

  @Index()
  late String category;

  late String materialId;
  int duration = 0;
  int score = 0;
  DateTime playedAt = DateTime.now();
}
