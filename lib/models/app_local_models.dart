class UserAccount {
  const UserAccount({
    required this.username,
    required this.childName,
    required this.gender,
    required this.role,
    required this.themeId,
    required this.stars,
    required this.iqraStreak,
    required this.progress,
    required this.iqraMastered,
    required this.iqraHistory,
    this.hurfMastered = const [],
    this.angkaMastered = const [],
    this.bendaMastered = const [],
    this.favoriteMaterialIds = const [],
    this.avatarPath = '',
    this.createdAt,
  });

  final String username;
  final String childName;
  final dynamic gender;
  final dynamic role;
  final String themeId;
  final int stars;
  final int iqraStreak;
  final Map<String, int> progress;
  final List<String> iqraMastered;
  final List<String> iqraHistory;
  final List<String> hurfMastered;
  final List<String> angkaMastered;
  final List<String> bendaMastered;
  final List<String> favoriteMaterialIds;
  final String avatarPath;
  final DateTime? createdAt;
}

class LearningHistoryRecord {
  const LearningHistoryRecord({
    required this.materialId,
    required this.category,
    required this.duration,
    required this.score,
    required this.playedAt,
  });

  final String materialId;
  final String category;
  final int duration;
  final int score;
  final DateTime playedAt;
}
