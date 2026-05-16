import 'package:isar/isar.dart';

part 'learning_progress_collection.g.dart';

@collection
class LearningProgressEntity {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true, composite: [CompositeIndex('category')])
  late String ownerUsername;

  late String category;
  int progressPercent = 0;
  int completedItems = 0;
  int totalItems = 0;
  DateTime updatedAt = DateTime.now();
  List<String> completedKeys = [];
}
