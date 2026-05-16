import 'package:isar/isar.dart';

part 'learning_material_collection.g.dart';

@collection
class LearningMaterialEntity {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String materialId;

  @Index()
  late String category;

  @Index()
  bool favorite = false;

  String title = '';
  String subcategory = '';
  String imagePath = '';
  String audioPath = '';
  String videoPath = '';
  String thumbnailPath = '';
  String fileName = '';
  String sourceUrl = '';
  DateTime createdAt = DateTime.now();
  DateTime updatedAt = DateTime.now();
}
