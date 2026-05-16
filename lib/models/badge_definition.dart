import 'package:flutter/material.dart';

enum BadgeRarity { common, rare, epic, legendary }

class BadgeDefinition {
  const BadgeDefinition({
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

typedef BadgeData = BadgeDefinition;

String rarityLabel(BadgeRarity rarity) => switch (rarity) {
  BadgeRarity.common => 'Common',
  BadgeRarity.rare => 'Rare',
  BadgeRarity.epic => 'Epic',
  BadgeRarity.legendary => 'Legendary',
};

Color rarityColor(BadgeRarity rarity) => switch (rarity) {
  BadgeRarity.common => const Color(0xff4CAF50),
  BadgeRarity.rare => const Color(0xff2196F3),
  BadgeRarity.epic => const Color(0xff9C27B0),
  BadgeRarity.legendary => const Color(0xffFF9800),
};

const badgeDefinitions = [
  BadgeDefinition(
    id: 'master_huruf',
    title: 'Master Huruf',
    description: 'Menyelesaikan seluruh pembelajaran Huruf A-Z',
    rarity: BadgeRarity.rare,
    assetUnlocked: 'assets/images/Badge_Huruf.png',
    assetLocked: 'assets/images/Badge_Huruf_notunlock.png',
    progressKey: 'membaca',
    requiredProgress: 100,
    glowColor: Color(0xffFFD700),
  ),
  BadgeDefinition(
    id: 'master_angka',
    title: 'Master Angka',
    description: 'Menyelesaikan seluruh pembelajaran Angka 1-10',
    rarity: BadgeRarity.rare,
    assetUnlocked: 'assets/images/Badge_Angka.png',
    assetLocked: 'assets/images/Badge_Angka_notunlock.png',
    progressKey: 'angka',
    requiredProgress: 100,
    glowColor: Color(0xff42A5F5),
  ),
  BadgeDefinition(
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
  BadgeDefinition(
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
  BadgeDefinition(
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
