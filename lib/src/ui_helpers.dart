part of '../main.dart';

// ─── Tactile Card Decoration (3D pressed look) ──────────────────
BoxDecoration cardDecoration(BuildContext context, {Color? borderColor, double radius = 28}) {
  final t = _themeOf(context);
  return BoxDecoration(
    color: t.widgetBg,
    borderRadius: BorderRadius.circular(radius),
    border: Border.all(color: borderColor ?? t.widgetBorder.withValues(alpha: .28), width: 1.6),
    boxShadow: [
      BoxShadow(
        blurRadius: 18,
        offset: const Offset(0, 8),
        color: Colors.black.withValues(alpha: t.dark ? .25 : .07),
      ),
    ],
  );
}

BoxDecoration tactileCard(BuildContext context, {Color? border, double radius = 32}) {
  final t = _themeOf(context);
  final b = border ?? t.widgetBorder;
  return BoxDecoration(
    color: t.widgetBg,
    borderRadius: BorderRadius.circular(radius),
    border: Border.all(color: b, width: 3),
    boxShadow: [
      BoxShadow(
        offset: const Offset(0, 8),
        blurRadius: 0,
        color: b.withValues(alpha: .35),
      ),
      BoxShadow(
        blurRadius: 20,
        offset: const Offset(0, 10),
        color: Colors.black.withValues(alpha: t.dark ? .2 : .06),
      ),
    ],
  );
}

BoxDecoration pillBox(Color color, Color border) => BoxDecoration(
  color: color,
  borderRadius: BorderRadius.circular(20),
  border: Border.all(color: border),
);

ButtonStyle bigButton(Color color) => FilledButton.styleFrom(
  backgroundColor: color,
  foregroundColor: Colors.white,
  minimumSize: const Size.fromHeight(58),
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
  textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900, letterSpacing: 1),
);

ButtonStyle tactileButton(Color color) => FilledButton.styleFrom(
  backgroundColor: color,
  foregroundColor: Colors.white,
  minimumSize: const Size.fromHeight(62),
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
  elevation: 0,
  textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, letterSpacing: 1.2),
  padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
);

TextStyle sectionTitle(BuildContext context) => TextStyle(
  fontSize: 28,
  fontWeight: FontWeight.w900,
  color: Theme.of(context).colorScheme.onSurface,
  letterSpacing: -.5,
);

TextStyle headlineBold(BuildContext context) => TextStyle(
  fontSize: 34,
  fontWeight: FontWeight.w900,
  color: Theme.of(context).colorScheme.onSurface,
  letterSpacing: -1,
  height: 1.15,
);

Color muted(BuildContext context) =>
    Theme.of(context).colorScheme.onSurface.withValues(alpha: .55);

Color cardColor(BuildContext context) =>
    Theme.of(context).colorScheme.surface.withValues(alpha: .94);

final softShadow = [
  BoxShadow(
    blurRadius: 24,
    offset: const Offset(0, 10),
    color: Colors.black.withValues(alpha: .08),
  ),
];

AppThemeData _themeOf(BuildContext context) {
  try {
    final container = ProviderScope.containerOf(context);
    return container.read(appStateProvider).theme;
  } catch (_) {
    return appThemes[3]; // fallback to 'hewan'
  }
}

String titleForMode(LearnMode mode) => switch (mode) {
  LearnMode.huruf => 'Belajar Huruf',
  LearnMode.angka => 'Belajar Angka',
  LearnMode.benda => 'Belajar Benda',
  LearnMode.iqra => 'Belajar Iqra 1',
  LearnMode.menu => 'Pusat Belajar',
};

String labelForProgress(String key) => switch (key) {
  'membaca' => 'Membaca',
  'angka' => 'Angka',
  'benda' => 'Benda',
  'iqra' => 'Iqra',
  'mode_seru' => 'Mode Seru',
  _ => key,
};

String? youtubeThumb(String url) {
  final reg = RegExp(r'(?:embed/|v=|youtu\.be/)([A-Za-z0-9_-]{6,})');
  final id = reg.firstMatch(url)?.group(1);
  if (id == null) return null;
  return 'https://img.youtube.com/vi/$id/hqdefault.jpg';
}

Challenge randomChallenge([String? category]) {
  final r = Random();
  final bucket =
      category ??
      switch (r.nextInt(4)) {
        0 => 'huruf',
        1 => 'angka',
        2 => 'benda',
        _ => 'iqra',
      };
  if (bucket == 'huruf') {
    final x = lettersData[r.nextInt(lettersData.length)];
    return Challenge('membaca', 'Sebutkan huruf ini', x.letter, null, [
      x.letter,
    ]);
  }
  if (bucket == 'angka') {
    final x = numbersData[r.nextInt(numbersData.length)];
    return Challenge('angka', 'Sebutkan angka ini', x.number, x.img, [
      x.name,
      x.number,
    ]);
  }
  if (bucket == 'benda') {
    final x = objectsData[r.nextInt(objectsData.length)];
    return Challenge('benda', 'Sebutkan nama benda ini', x.name, x.img, [
      x.name,
    ]);
  }
  final x = iqraData[r.nextInt(iqraData.length)];
  return Challenge('iqra', 'Baca huruf hijaiyah ini', x.char, null, [x.latin]);
}

// ─── Color category helpers ──────────────────
Color colorForCategory(String cat) => switch (cat) {
  'huruf' || 'membaca' => const Color(0xffE74C3C),
  'angka' => const Color(0xff3498DB),
  'benda' => const Color(0xff27AE60),
  'iqra' => const Color(0xff9B59B6),
  'mode_seru' => const Color(0xffE67E22),
  _ => const Color(0xff95A5A6),
};

Color lightColorForCategory(String cat) => switch (cat) {
  'huruf' || 'membaca' => const Color(0xffFDE8E8),
  'angka' => const Color(0xffE8F4FD),
  'benda' => const Color(0xffE8F8EE),
  'iqra' => const Color(0xffF3E8FD),
  'mode_seru' => const Color(0xffFDF2E8),
  _ => const Color(0xffF0F0F0),
};
