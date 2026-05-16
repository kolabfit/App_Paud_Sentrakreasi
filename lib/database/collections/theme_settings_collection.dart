import 'package:isar/isar.dart';

part 'theme_settings_collection.g.dart';

@collection
class ThemeSettingsEntity {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String ownerUsername;

  String selectedTheme = 'default';
  bool darkMode = false;
  DateTime updatedAt = DateTime.now();
}
