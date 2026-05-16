class MediaSourceHelper {
  const MediaSourceHelper._();

  static bool isRemoteUrl(String value) {
    final lower = value.toLowerCase();
    return lower.startsWith('http://') || lower.startsWith('https://');
  }

  static bool isAssetPath(String value) => value.startsWith('assets/');

  static bool isDataUri(String value) => value.startsWith('data:');

  static bool isLocalFilePath(String value) {
    if (value.isEmpty ||
        isAssetPath(value) ||
        isRemoteUrl(value) ||
        isDataUri(value)) {
      return false;
    }
    return value.contains(':\\') ||
        value.startsWith('/') ||
        value.startsWith('\\');
  }

  static String normalizeCategory(String category) {
    final value = category.toLowerCase().trim();
    return switch (value) {
      'membaca' => 'huruf',
      'numbers' => 'angka',
      'songs' => 'lagu',
      _ => value,
    };
  }
}
