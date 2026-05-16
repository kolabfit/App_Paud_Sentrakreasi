import '../utils/media_source_helper.dart';

class LearningCategories {
  const LearningCategories._();

  static const huruf = 'huruf';
  static const angka = 'angka';
  static const benda = 'benda';
  static const iqra = 'iqra';
  static const lagu = 'lagu';
  static const modeSeru = 'mode_seru';

  static const appStateHuruf = 'membaca';

  static const progressCategories = [huruf, angka, benda, iqra, modeSeru];

  static String normalizeProgressKey(String key) {
    return key == appStateHuruf ? huruf : key;
  }

  static String appStateKey(String key) {
    return key == huruf ? appStateHuruf : key;
  }
}

class DefaultLearningCatalog {
  const DefaultLearningCatalog._();

  static const hurufPlaceholderAsset = 'assets/images/Logo_membaca.png';
  static const angkaPlaceholderAsset = 'assets/images/Logo_123.png';
  static const bendaPlaceholderAsset = 'assets/images/Logo_Benda.png';
  static const iqraPlaceholderAsset = 'assets/images/Logo_iqra.png';
  static const laguPlaceholderAsset = 'assets/images/lagu_anak.png';
  static const avatarBoyAsset = 'assets/images/profil_lakilaki.png';
  static const avatarGirlAsset = 'assets/images/profil_perempuan.png';

  static const bendaSeed = <Map<String, String>>[
    {'title': 'Mobil', 'subcategory': 'kendaraan'},
    {'title': 'Rumah', 'subcategory': 'benda'},
    {'title': 'Sepeda', 'subcategory': 'kendaraan'},
    {'title': 'Meja', 'subcategory': 'alat sekolah'},
    {'title': 'Kursi', 'subcategory': 'alat sekolah'},
    {'title': 'Buku', 'subcategory': 'alat sekolah'},
    {'title': 'Pensil', 'subcategory': 'alat sekolah'},
    {'title': 'Tas', 'subcategory': 'alat sekolah'},
  ];

  static const hurufSeed = <String>[
    'A',
    'B',
    'C',
    'D',
    'E',
    'F',
    'G',
    'H',
    'I',
    'J',
    'K',
    'L',
    'M',
    'N',
    'O',
    'P',
    'Q',
    'R',
    'S',
    'T',
    'U',
    'V',
    'W',
    'X',
    'Y',
    'Z',
  ];

  static const angkaSeed = <String>[
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10',
  ];

  static const iqraSeed = <String>[
    'Alif',
    'Ba',
    'Ta',
    'Tsa',
    'Jim',
    'Ha',
    'Kho',
    'Dal',
    'Dzal',
    'Ra',
    'Zai',
    'Sin',
    'Syin',
    'Shod',
    'Dhod',
    'Tho',
    'Zho',
    'Ain',
    'Ghoin',
    'Fa',
    'Qof',
    'Kaf',
    'Lam',
    'Mim',
    'Nun',
    'Wau',
    'Ha',
    'Hamzah',
    'Ya',
  ];

  static int totalForCategory(String category) {
    return switch (category) {
      LearningCategories.huruf => hurufSeed.length,
      LearningCategories.angka => angkaSeed.length,
      LearningCategories.benda => bendaSeed.length,
      LearningCategories.iqra => iqraSeed.length,
      LearningCategories.modeSeru => 1,
      _ => 0,
    };
  }
}

class DefaultStorageFiles {
  const DefaultStorageFiles._();

  static const hurufImage = 'images/huruf/default_huruf.png';
  static const angkaImage = 'images/huruf/default_angka.png';
  static const bendaImage = 'images/benda/default_benda.png';
  static const iqraImage = 'images/huruf/default_iqra.png';
  static const laguImage = 'images/benda/default_lagu.png';
  static const badgeHuruf = 'images/badge/badge_huruf.png';
  static const badgeAngka = 'images/badge/badge_angka.png';
  static const badgeBenda = 'images/badge/badge_benda.png';
  static const badgeIqra = 'images/badge/badge_iqra.png';
  static const badgeComplete = 'images/badge/badge_complete.png';
  static const profileBoy = 'images/profile/profile_boy.png';
  static const profileGirl = 'images/profile/profile_girl.png';
}

String defaultMediaFallback(String category) {
  return switch (MediaSourceHelper.normalizeCategory(category)) {
    LearningCategories.angka => DefaultLearningCatalog.angkaPlaceholderAsset,
    LearningCategories.benda => DefaultLearningCatalog.bendaPlaceholderAsset,
    LearningCategories.iqra => DefaultLearningCatalog.iqraPlaceholderAsset,
    LearningCategories.lagu => DefaultLearningCatalog.laguPlaceholderAsset,
    _ => DefaultLearningCatalog.hurufPlaceholderAsset,
  };
}
