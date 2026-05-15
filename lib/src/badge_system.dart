part of '../main.dart';

// ═══════════════════════════════════════════════════════════════
//  BADGE MODEL
// ═══════════════════════════════════════════════════════════════

enum BadgeRarity { common, rare, epic, legendary }

class BadgeData {
  const BadgeData({
    required this.id,
    required this.title,
    required this.description,
    required this.rarity,
    required this.assetUnlocked,
    required this.assetLocked,
    required this.progressKey,
    required this.requiredProgress,
    required this.glowColor,
  });

  final String id;
  final String title;
  final String description;
  final BadgeRarity rarity;
  final String assetUnlocked;
  final String assetLocked;
  final String progressKey;
  final int requiredProgress;
  final Color glowColor;
}

String rarityLabel(BadgeRarity r) => switch (r) {
  BadgeRarity.common => 'Common',
  BadgeRarity.rare => 'Rare',
  BadgeRarity.epic => 'Epic',
  BadgeRarity.legendary => 'Legendary',
};

Color rarityColor(BadgeRarity r) => switch (r) {
  BadgeRarity.common => const Color(0xff4CAF50),
  BadgeRarity.rare => const Color(0xff2196F3),
  BadgeRarity.epic => const Color(0xff9C27B0),
  BadgeRarity.legendary => const Color(0xffFF9800),
};

// ═══════════════════════════════════════════════════════════════
//  BADGE DEFINITIONS
// ═══════════════════════════════════════════════════════════════

const _allBadges = [
  BadgeData(
    id: 'master_huruf',
    title: 'Master Huruf',
    description: 'Menyelesaikan seluruh pembelajaran Huruf A–Z',
    rarity: BadgeRarity.rare,
    assetUnlocked: 'assets/images/Badge_Huruf.png',
    assetLocked: 'assets/images/Badge_Huruf_notunlock.png',
    progressKey: 'membaca',
    requiredProgress: 100,
    glowColor: Color(0xffFFD700),
  ),
  BadgeData(
    id: 'master_angka',
    title: 'Master Angka',
    description: 'Menyelesaikan seluruh pembelajaran Angka 1–10',
    rarity: BadgeRarity.rare,
    assetUnlocked: 'assets/images/Badge_Angka.png',
    assetLocked: 'assets/images/Badge_Angka_notunlock.png',
    progressKey: 'angka',
    requiredProgress: 100,
    glowColor: Color(0xff42A5F5),
  ),
  BadgeData(
    id: 'penjelajah_benda',
    title: 'Penjelajah Benda',
    description: 'Membuka seluruh katalog benda dan kategori',
    rarity: BadgeRarity.epic,
    assetUnlocked: 'assets/images/Badge_Benda.png',
    assetLocked: 'assets/images/Badge_Benda_notunlock .png',
    progressKey: 'benda',
    requiredProgress: 100,
    glowColor: Color(0xff66BB6A),
  ),
  BadgeData(
    id: 'sahabat_hijaiyah',
    title: 'Sahabat Hijaiyah',
    description: 'Menyelesaikan Iqra 1 dan membaca huruf hijaiyah',
    rarity: BadgeRarity.epic,
    assetUnlocked: 'assets/images/Badge_Iqra.png',
    assetLocked: 'assets/images/Badge_Iqra_notunlock.png',
    progressKey: 'iqra',
    requiredProgress: 100,
    glowColor: Color(0xffAB47BC),
  ),
  BadgeData(
    id: 'petualang_hebat',
    title: 'Petualang Hebat',
    description: 'Menyelesaikan seluruh progress belajar 100%!',
    rarity: BadgeRarity.legendary,
    assetUnlocked: 'assets/images/Badge_Complete.png',
    assetLocked: 'assets/images/Badge_Semua_notunlocck.png',
    progressKey: '_all_',
    requiredProgress: 100,
    glowColor: Color(0xffFF9800),
  ),
];

// ═══════════════════════════════════════════════════════════════
//  BADGE SERVICE  (checks unlock, persists via sembast)
// ═══════════════════════════════════════════════════════════════

class BadgeService {
  BadgeService._();
  static final instance = BadgeService._();

  final _store = stringMapStoreFactory.store('badges');

  List<BadgeData> get allBadges => _allBadges;

  int currentProgress(BadgeData badge, Map<String, int> progress) {
    if (badge.progressKey == '_all_') {
      final vals = ['membaca', 'angka', 'benda', 'iqra']
          .map((k) => progress[k] ?? 0)
          .toList();
      if (vals.isEmpty) return 0;
      return (vals.reduce((a, b) => a + b) / vals.length).round();
    }
    return progress[badge.progressKey] ?? 0;
  }

  bool isUnlocked(BadgeData badge, Map<String, int> progress) {
    return currentProgress(badge, progress) >= badge.requiredProgress;
  }

  int unlockedCount(Map<String, int> progress) {
    return allBadges.where((b) => isUnlocked(b, progress)).length;
  }

  /// Returns list of badge IDs that were newly unlocked (not previously saved).
  Future<List<String>> checkNewUnlocks({
    required String username,
    required Map<String, int> progress,
    required Database database,
  }) async {
    final key = username.toLowerCase().trim();
    final saved = await _store.record(key).get(database);
    final previous = Set<String>.from(
      (saved?['unlocked'] as List?)?.cast<String>() ?? <String>[],
    );

    final nowUnlocked = <String>[];
    for (final badge in allBadges) {
      if (isUnlocked(badge, progress) && !previous.contains(badge.id)) {
        nowUnlocked.add(badge.id);
      }
    }

    if (nowUnlocked.isNotEmpty) {
      final all = {...previous, ...nowUnlocked}.toList();
      await _store.record(key).put(database, {
        'unlocked': all,
        'updatedAt': DateTime.now().toIso8601String(),
      });
    }

    return nowUnlocked;
  }

  Future<Set<String>> savedUnlocks(String username, Database database) async {
    final key = username.toLowerCase().trim();
    final saved = await _store.record(key).get(database);
    return Set<String>.from(
      (saved?['unlocked'] as List?)?.cast<String>() ?? <String>[],
    );
  }
}
