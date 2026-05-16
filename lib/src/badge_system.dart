part of '../main.dart';

class BadgeService {
  BadgeService._();
  static final instance = BadgeService._();

  List<BadgeData> get allBadges => badgeDefinitions;

  int currentProgress(BadgeData badge, Map<String, int> progress) {
    if (badge.progressKey == '_all_') {
      final vals = [
        'membaca',
        'angka',
        'benda',
        'iqra',
      ].map((key) => progress[key] ?? 0).toList();
      if (vals.isEmpty) return 0;
      return (vals.reduce((a, b) => a + b) / vals.length).round();
    }
    return progress[badge.progressKey] ?? 0;
  }

  bool isUnlocked(BadgeData badge, Map<String, int> progress) {
    return currentProgress(badge, progress) >= badge.requiredProgress;
  }

  int unlockedCount(Map<String, int> progress) {
    return allBadges.where((badge) => isUnlocked(badge, progress)).length;
  }

  Future<List<String>> checkNewUnlocks({
    required String username,
    required Map<String, int> progress,
  }) {
    return LocalDatabase.instance.checkNewUnlocks(
      username: username,
      progress: progress,
    );
  }

  Future<Set<String>> savedUnlocks(String username) {
    return LocalDatabase.instance.savedUnlocks(username);
  }
}
