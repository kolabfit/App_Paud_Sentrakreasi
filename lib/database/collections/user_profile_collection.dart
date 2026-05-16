import 'package:isar/isar.dart';

part 'user_profile_collection.g.dart';

@collection
class UserProfileEntity {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String username;

  String childName = 'Teman';
  String gender = 'boy';
  String role = 'child';
  String avatarPath = '';
  String passwordHash = '';
  int xp = 12;
  int level = 1;
  int coins = 12;
  int stars = 12;
  int iqraStreak = 0;
  String themeId = 'default';
  DateTime createdAt = DateTime.now();
  DateTime updatedAt = DateTime.now();
  List<String> iqraMastered = [];
  List<String> iqraHistory = [];
  List<String> hurfMastered = [];
  List<String> angkaMastered = [];
  List<String> bendaMastered = [];
  List<String> favoriteMaterialIds = [];
}
