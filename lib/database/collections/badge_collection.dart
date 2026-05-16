import 'package:isar/isar.dart';

part 'badge_collection.g.dart';

@collection
class BadgeModelEntity {
  Id id = Isar.autoIncrement;

  @Index(
    unique: true,
    replace: true,
    composite: [CompositeIndex('ownerUsername')],
  )
  late String code;

  late String ownerUsername;
  String title = '';
  String description = '';
  bool unlocked = false;
  DateTime? unlockedAt;
  String badgeImagePath = '';
  String rarity = 'common';
}
