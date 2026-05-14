part of '../main.dart';

Future<void> speakIndonesian(FlutterTts tts, String text) async {
  await tts.setLanguage('id-ID');
  await tts.setSpeechRate(.45);
  await tts.setPitch(1.05);
  await tts.speak(text);
}

Future<void> speakArabic(FlutterTts tts, String text) async {
  await tts.setLanguage('ar');
  await tts.setSpeechRate(.38);
  await tts.setPitch(1.0);
  await tts.speak(text);
}

class BelajarScreen extends ConsumerStatefulWidget {
  const BelajarScreen({super.key});

  @override
  ConsumerState<BelajarScreen> createState() => _BelajarScreenState();
}

class _BelajarScreenState extends ConsumerState<BelajarScreen> {
  bool readingHelp = false;

  @override
  Widget build(BuildContext context) {
    final app = ref.watch(appStateProvider);
    final body = modeBody(app);
    return app.learnMode == LearnMode.menu ? body : PagePad(child: body);
  }

  Widget modeBody(AppState app) {
    return switch (app.learnMode) {
      LearnMode.huruf => const HurufScreen(),
      LearnMode.angka => const AngkaScreen(),
      LearnMode.benda => const BendaScreen(),
      LearnMode.iqra => IqraLesson(
        readingHelp: readingHelp,
        onToggle: () => setState(() => readingHelp = !readingHelp),
      ),
      LearnMode.menu => const LearnMenu(),
    };
  }
}

class LearnMenu extends ConsumerWidget {
  const LearnMenu({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final app = ref.watch(appStateProvider);
    final size = MediaQuery.sizeOf(context);
    final tablet = size.width >= 700;
    final mascot = app.gender == Gender.girl
        ? 'assets/images/Anak_Perempuan_Menu.png'
        : 'assets/images/Anak_LakiLaki_Menu.png';
    final cards = [
      _AdventureData(
        'MEMBACA',
        'A sampai Z',
        'assets/images/Logo_membaca.png',
        const Color(0xffFFE2ED),
        const Color(0xffF65391),
        LearnMode.huruf,
      ),
      _AdventureData(
        'ANGKA',
        '1 sampai 10',
        'assets/images/Logo_123.png',
        const Color(0xffDDF4FF),
        const Color(0xff279AF3),
        LearnMode.angka,
      ),
      _AdventureData(
        'BENDA',
        'Mengenal berbagai benda di sekitar kita',
        'assets/images/Logo_Benda.png',
        const Color(0xffE3F8D8),
        const Color(0xff32C653),
        LearnMode.benda,
      ),
      _AdventureData(
        'IQRA',
        'Hijaiyah dasar',
        'assets/images/Logo_iqra.png',
        const Color(0xffEBDDFF),
        const Color(0xff9656F4),
        LearnMode.iqra,
      ),
    ];

    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          'assets/images/Background_image.png',
          fit: BoxFit.cover,
          alignment: Alignment.topCenter,
        ),
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white.withValues(alpha: .02),
                const Color(0xffEAF8FF).withValues(alpha: .58),
                Colors.white.withValues(alpha: .82),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        ...List.generate(18, (i) {
          final left = (i * 67 % max(1, size.width.toInt())).toDouble();
          final top = 42.0 + (i * 53 % 520);
          return Positioned(
            left: left,
            top: top,
            child:
                Icon(
                      i.isEven
                          ? Icons.star_rounded
                          : Icons.auto_awesome_rounded,
                      color: Colors.white.withValues(alpha: .86),
                      size: i.isEven ? 18 : 13,
                    )
                    .animate(onPlay: (c) => c.repeat(reverse: true))
                    .scale(
                      begin: const Offset(.72, .72),
                      end: const Offset(1.12, 1.12),
                      duration: (900 + i * 70).ms,
                    ),
          );
        }),
        SafeArea(
          child: Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: tablet ? 980 : 560),
              child: ListView(
                padding: EdgeInsets.fromLTRB(
                  tablet ? 28 : 18,
                  18,
                  tablet ? 28 : 18,
                  126,
                ),
                children: [
                  _AdventureTopBar(
                    stars: app.stars,
                    onBack: () => ref.read(appStateProvider).go(TabItem.main),
                  ),
                  SizedBox(height: tablet ? 10 : 18),
                  _AdventureHero(mascot: mascot, tablet: tablet),
                  SizedBox(height: tablet ? 24 : 20),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: tablet ? 4 : 2,
                      mainAxisSpacing: tablet ? 18 : 14,
                      crossAxisSpacing: tablet ? 18 : 14,
                      childAspectRatio: tablet ? .84 : .77,
                    ),
                    itemCount: cards.length,
                    itemBuilder: (context, i) => _AdventureCard(
                      data: cards[i],
                      delay: i * 90,
                      onTap: () =>
                          ref.read(appStateProvider).openLearn(cards[i].mode),
                    ),
                  ),
                  const SizedBox(height: 18),
                  _AdventureMotivation(mascot: mascot),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _AdventureTopBar extends StatelessWidget {
  const _AdventureTopBar({required this.stars, required this.onBack});
  final int stars;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _AdventureGlassButton(icon: Icons.chevron_left_rounded, onTap: onBack),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: .93),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: Colors.white, width: 1.5),
            boxShadow: [
              BoxShadow(
                blurRadius: 18,
                offset: const Offset(0, 9),
                color: const Color(0xff4EA7DB).withValues(alpha: .18),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.star_rounded,
                color: Color(0xffFFC928),
                size: 30,
              ),
              const SizedBox(width: 7),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$stars',
                    style: const TextStyle(
                      color: Color(0xff3B3D86),
                      fontSize: 17,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const Text(
                    'Poin Kamu',
                    style: TextStyle(
                      color: Color(0xff5A6090),
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _AdventureHero extends StatelessWidget {
  const _AdventureHero({required this.mascot, required this.tablet});
  final String mascot;
  final bool tablet;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: tablet ? 170 : 278,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          Positioned(
            top: 0,
            left: tablet ? 170 : 14,
            right: tablet ? 170 : 14,
            child:
                Image.asset(
                      'assets/images/Pusat_petualangan.png',
                      height: tablet ? 128 : 110,
                      fit: BoxFit.contain,
                    )
                    .animate()
                    .fadeIn(duration: 380.ms)
                    .scale(begin: const Offset(.92, .92)),
          ),
          Positioned(
            right: tablet ? 58 : 8,
            bottom: -6,
            child:
                Image.asset(
                      mascot,
                      height: tablet ? 170 : 134,
                      fit: BoxFit.contain,
                    )
                    .animate(onPlay: (c) => c.repeat(reverse: true))
                    .moveY(begin: -5, end: 5, duration: 1700.ms),
          ),
        ],
      ),
    );
  }
}

class _AdventureCard extends StatelessWidget {
  const _AdventureCard({
    required this.data,
    required this.delay,
    required this.onTap,
  });
  final _AdventureData data;
  final int delay;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(34),
        child: Ink(
          decoration: BoxDecoration(
            color: data.bg,
            borderRadius: BorderRadius.circular(34),
            border: Border.all(color: Colors.white, width: 3),
            boxShadow: [
              BoxShadow(
                blurRadius: 20,
                offset: const Offset(0, 12),
                color: data.color.withValues(alpha: .20),
              ),
            ],
          ),
          child: Column(
            children: [
              Expanded(
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Positioned.fill(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(31),
                          ),
                          gradient: LinearGradient(
                            colors: [
                              Colors.white.withValues(alpha: .25),
                              data.bg.withValues(alpha: .15),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 12,
                      top: 10,
                      child: Icon(
                        Icons.auto_awesome_rounded,
                        color: Colors.white.withValues(alpha: .84),
                        size: 18,
                      ),
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(14),
                        child: Image.asset(data.asset, fit: BoxFit.contain),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(16, 14, 14, 14),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: .78),
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(31),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: data.color,
                              fontSize: 17,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            data.subtitle,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Color(0xff4D5179),
                              fontSize: 12,
                              height: 1.2,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: data.color,
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 12,
                                offset: const Offset(0, 6),
                                color: data.color.withValues(alpha: .32),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.chevron_right_rounded,
                            color: Colors.white,
                            size: 32,
                          ),
                        )
                        .animate(onPlay: (c) => c.repeat(reverse: true))
                        .scale(
                          begin: const Offset(.95, .95),
                          end: const Offset(1.07, 1.07),
                          duration: 1200.ms,
                        ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(delay: Duration(milliseconds: delay)).slideY(begin: .07);
  }
}

class _AdventureMotivation extends StatelessWidget {
  const _AdventureMotivation({required this.mascot});
  final String mascot;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 14, 16, 14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .92),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [
          BoxShadow(
            blurRadius: 20,
            offset: const Offset(0, 10),
            color: const Color(0xff6AAFE6).withValues(alpha: .18),
          ),
        ],
      ),
      child: Row(
        children: [
          Image.asset(mascot, width: 72, fit: BoxFit.contain),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xffF1EAFF),
                borderRadius: BorderRadius.circular(22),
              ),
              child: const Text(
                'Terus belajar ya! Setiap langkah kecil membawamu jadi hebat!',
                style: TextStyle(
                  color: Color(0xff4A3B8F),
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                  height: 1.25,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AdventureGlassButton extends StatelessWidget {
  const _AdventureGlassButton({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Material(
          color: Colors.white.withValues(alpha: .88),
          child: InkWell(
            onTap: onTap,
            child: SizedBox(
              width: 58,
              height: 58,
              child: Icon(icon, color: const Color(0xff8B55F6), size: 34),
            ),
          ),
        ),
      ),
    );
  }
}

class _AdventureData {
  const _AdventureData(
    this.title,
    this.subtitle,
    this.asset,
    this.bg,
    this.color,
    this.mode,
  );
  final String title;
  final String subtitle;
  final String asset;
  final Color bg;
  final Color color;
  final LearnMode mode;
}

class HurufScreen extends ConsumerStatefulWidget {
  const HurufScreen({super.key});

  @override
  ConsumerState<HurufScreen> createState() => _HurufScreenState();
}

class _HurufScreenState extends ConsumerState<HurufScreen> {
  final tts = FlutterTts();
  int letterIndex = 0;
  int objectIndex = 0;
  bool seru = false;

  @override
  Widget build(BuildContext context) {
    if (seru) {
      return ModeSeruScreen(
        category: 'huruf',
        title: 'Kuis Huruf Seru',
        onClose: () => setState(() => seru = false),
      );
    }
    final app = ref.watch(appStateProvider);
    final t = app.theme;
    final data = lettersData[letterIndex];
    final obj = data.objects[objectIndex];
    return Column(
      children: [
        LessonTopBar(
          title: 'Kamus Huruf',
          color: t.dark ? Colors.orange.shade200 : Colors.orange.shade700,
          onPrev: () => setState(() {
            letterIndex =
                (letterIndex - 1 + lettersData.length) % lettersData.length;
            objectIndex = 0;
          }),
          onNext: () => setState(() {
            letterIndex = (letterIndex + 1) % lettersData.length;
            objectIndex = 0;
          }),
          onSeru: () => setState(() => seru = true),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Wrap(
              alignment: WrapAlignment.center,
              runSpacing: 24,
              spacing: 24,
              children: [
                TactilePanel(
                  width: 360,
                  height: 360,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        data.letter,
                        style: TextStyle(
                          fontSize: 150,
                          fontWeight: FontWeight.w900,
                          color: t.primary,
                        ),
                      ),
                      Text(
                        data.letter.toLowerCase(),
                        style: TextStyle(
                          fontSize: 104,
                          fontWeight: FontWeight.w900,
                          color: t.primary.withValues(alpha: .32),
                        ),
                      ),
                    ],
                  ),
                ),
                TactilePanel(
                  width: 360,
                  height: 360,
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.topRight,
                        child: IconButton.filled(
                          onPressed: () => setState(() {
                            objectIndex = Random().nextInt(data.objects.length);
                          }),
                          icon: const Icon(Icons.shuffle),
                        ),
                      ),
                      Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                                  width: 220,
                                  height: 190,
                                  child: AppImage(
                                    url: obj.img,
                                    fit: BoxFit.contain,
                                  ),
                                )
                                .animate(onPlay: (c) => c.repeat(reverse: true))
                                .moveY(begin: -8, end: 8),
                            const SizedBox(height: 16),
                            Chip(
                              label: Text(
                                obj.name,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 18,
                                vertical: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        FilledButton(
          onPressed: () async {
            await speakIndonesian(tts, '${data.letter}. ${obj.name}');
            await ref.read(appStateProvider).bump('membaca', 4);
          },
          child: const Text('Dengarkan'),
        ),
        const SizedBox(height: 10),
        OutlinedButton(
          onPressed: () => ref.read(appStateProvider).openLearn(LearnMode.menu),
          child: const Text('SELESAI BELAJAR'),
        ),
        const SizedBox(height: 110),
      ],
    );
  }
}

class AngkaScreen extends ConsumerStatefulWidget {
  const AngkaScreen({super.key});

  @override
  ConsumerState<AngkaScreen> createState() => _AngkaScreenState();
}

class _AngkaScreenState extends ConsumerState<AngkaScreen> {
  final tts = FlutterTts();
  int index = 0;
  bool seru = false;

  @override
  Widget build(BuildContext context) {
    if (seru) {
      return ModeSeruScreen(
        category: 'angka',
        title: 'Kuis Seru',
        onClose: () => setState(() => seru = false),
      );
    }
    final current = numbersData[index];
    return Column(
      children: [
        LessonTopBar(
          title: 'Angka ${current.number}',
          color: Colors.blue,
          onPrev: () => setState(
            () => index = (index - 1 + numbersData.length) % numbersData.length,
          ),
          onNext: () =>
              setState(() => index = (index + 1) % numbersData.length),
          onSeru: () => setState(() => seru = true),
        ),
        Expanded(
          child: Center(
            child: TactilePanel(
              width: 400,
              height: 430,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Text(
                    current.number,
                    style: TextStyle(
                      fontSize: 230,
                      fontWeight: FontWeight.w900,
                      color: Colors.blue.withValues(alpha: .08),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 270,
                        height: 230,
                        child: AppImage(url: current.img, fit: BoxFit.contain),
                      ),
                      const SizedBox(height: 14),
                      Chip(
                        label: Text(
                          current.name,
                          style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 22,
                          vertical: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        FilledButton(
          onPressed: () async {
            await speakIndonesian(tts, current.name);
            await ref.read(appStateProvider).bump('angka', 5);
            setState(() => index = (index + 1) % numbersData.length);
          },
          child: const Text('Lanjut'),
        ),
        const SizedBox(height: 10),
        OutlinedButton(
          onPressed: () => ref.read(appStateProvider).openLearn(LearnMode.menu),
          child: const Text('Selesai'),
        ),
        const SizedBox(height: 110),
      ],
    );
  }
}

class BendaScreen extends ConsumerStatefulWidget {
  const BendaScreen({super.key});

  @override
  ConsumerState<BendaScreen> createState() => _BendaScreenState();
}

class _BendaScreenState extends ConsumerState<BendaScreen> {
  final tts = FlutterTts();
  int index = 0;
  bool seru = false;

  @override
  Widget build(BuildContext context) {
    final app = ref.watch(appStateProvider);
    if (seru) {
      return ModeSeruScreen(
        category: 'benda',
        title: 'Petualangan Seru',
        onClose: () => setState(() => seru = false),
      );
    }
    final objects = app.objects;
    final current = objects[index % objects.length];
    return Column(
      children: [
        LessonTopBar(
          title: current.name,
          color: Colors.green,
          onPrev: () => setState(
            () => index = (index - 1 + objects.length) % objects.length,
          ),
          onNext: () => setState(() => index = (index + 1) % objects.length),
          onSeru: () => setState(() => seru = true),
        ),
        Expanded(
          child: Center(
            child: TactilePanel(
              width: 400,
              height: 430,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 275,
                    height: 245,
                    child: AppImage(url: current.img, fit: BoxFit.contain),
                  ),
                  const SizedBox(height: 20),
                  Chip(
                    label: Text(
                      current.name,
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 22,
                      vertical: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        FilledButton(
          onPressed: () async {
            await speakIndonesian(tts, current.name);
            await ref.read(appStateProvider).bump('benda', 5);
            setState(() => index = (index + 1) % objects.length);
          },
          child: const Text('Lanjut'),
        ),
        const SizedBox(height: 10),
        OutlinedButton(
          onPressed: () => ref.read(appStateProvider).openLearn(LearnMode.menu),
          child: const Text('Selesai'),
        ),
        const SizedBox(height: 110),
      ],
    );
  }
}

class LessonTopBar extends StatelessWidget {
  const LessonTopBar({
    required this.title,
    required this.color,
    required this.onPrev,
    required this.onNext,
    required this.onSeru,
    super.key,
  });
  final String title;
  final Color color;
  final VoidCallback onPrev;
  final VoidCallback onNext;
  final VoidCallback onSeru;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton.filledTonal(
          onPressed: onPrev,
          icon: const Icon(Icons.chevron_left, size: 32),
        ),
        Expanded(
          child: Column(
            children: [
              Text(
                title,
                textAlign: TextAlign.center,
                style: sectionTitle(context).copyWith(color: color),
              ),
              FilledButton.icon(
                onPressed: onSeru,
                icon: const Icon(Icons.emoji_events, size: 16),
                label: const Text('Mode Seru'),
                style: FilledButton.styleFrom(
                  backgroundColor: color,
                  foregroundColor: Colors.white,
                  visualDensity: VisualDensity.compact,
                ),
              ),
            ],
          ),
        ),
        IconButton.filledTonal(
          onPressed: onNext,
          icon: const Icon(Icons.chevron_right, size: 32),
        ),
      ],
    );
  }
}

class TactilePanel extends ConsumerWidget {
  const TactilePanel({required this.child, this.width, this.height, super.key});
  final Widget child;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = ref.watch(appStateProvider).theme;
    return Container(
      width: width,
      height: height,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: t.widgetBg,
        borderRadius: BorderRadius.circular(40),
        border: Border.all(color: t.widgetBorder, width: 3.5),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 10),
            blurRadius: 0,
            color: t.widgetBorder.withValues(alpha: .30),
          ),
          BoxShadow(
            blurRadius: 20,
            offset: const Offset(0, 12),
            color: Colors.black.withValues(alpha: t.dark ? .2 : .06),
          ),
        ],
      ),
      child: child,
    );
  }
}

class MenuButton extends ConsumerWidget {
  const MenuButton({
    required this.img,
    required this.label,
    required this.color,
    required this.onTap,
    super.key,
  });
  final String img;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = ref.watch(appStateProvider).theme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: t.widgetBg,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: color.withValues(alpha: .3), width: 2.5),
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, 7),
              blurRadius: 0,
              color: color.withValues(alpha: .18),
            ),
            BoxShadow(
              blurRadius: 16,
              offset: const Offset(0, 8),
              color: Colors.black.withValues(alpha: t.dark ? .15 : .04),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: t.dark
                      ? color.withValues(alpha: .12)
                      : color.withValues(alpha: .08),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: color.withValues(alpha: .15)),
                ),
                child: Image.asset(img, fit: BoxFit.contain),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              label.toUpperCase(),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w900,
                letterSpacing: 2,
                color: t.dark ? Colors.white : Colors.grey.shade800,
              ),
            ),
          ],
        ),
      ).animate().fadeIn().slideY(begin: .12),
    );
  }
}

class IqraLesson extends ConsumerStatefulWidget {
  const IqraLesson({
    required this.readingHelp,
    required this.onToggle,
    super.key,
  });
  final bool readingHelp;
  final VoidCallback onToggle;

  @override
  ConsumerState<IqraLesson> createState() => _IqraLessonState();
}

class _IqraLessonState extends ConsumerState<IqraLesson> {
  final tts = FlutterTts();
  final player = AudioPlayer();
  final page = PageController();
  late final ConfettiController confetti;
  int index = 0;
  bool seru = false;
  bool slow = false;
  bool listening = false;
  String feedback = '';

  @override
  void initState() {
    super.initState();
    confetti = ConfettiController(duration: const Duration(seconds: 2));
    initTts();
  }

  Future<void> initTts() async {
    await tts.setLanguage('ar');
    await tts.setPitch(1.06);
    await tts.setSpeechRate(.42);
  }

  @override
  void dispose() {
    page.dispose();
    confetti.dispose();
    player.dispose();
    tts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (seru) {
      return IqraFunMode(onClose: () => setState(() => seru = false));
    }
    final app = ref.watch(appStateProvider);
    final wide = MediaQuery.sizeOf(context).width >= 720;
    return Column(
      children: [
        Row(
          children: [
            IconButton.filledTonal(
              onPressed: () =>
                  ref.read(appStateProvider).openLearn(LearnMode.menu),
              icon: const Icon(Icons.chevron_left),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Iqra 1',
                style: sectionTitle(
                  context,
                ).copyWith(color: const Color(0xff7B3FB3)),
              ),
            ),
            RewardPill(stars: app.stars),
            const SizedBox(width: 8),
            const Text(
              'Bantuan latin',
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
            const SizedBox(width: 8),
            Switch(
              value: widget.readingHelp,
              onChanged: (_) => widget.onToggle(),
            ),
            const SizedBox(width: 8),
            FilledButton.icon(
              onPressed: () => setState(() => seru = true),
              icon: const Icon(Icons.emoji_events, size: 16),
              label: const Text('Mode Seru'),
              style: FilledButton.styleFrom(backgroundColor: Colors.purple),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: LinearProgressIndicator(
            value: (app.progress['iqra'] ?? 0) / 100,
            minHeight: 12,
            backgroundColor: const Color(0xffA7E8BD).withValues(alpha: .28),
            color: const Color(0xff34A853),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            _IqraStat(
              icon: Icons.done_all_rounded,
              text: '${app.iqraMastered.length}/${iqraData.length} terbaca',
            ),
            const SizedBox(width: 8),
            _IqraStat(
              icon: Icons.local_fire_department_rounded,
              text: '${app.iqraStreak} streak',
            ),
            const SizedBox(width: 8),
            _IqraStat(
              icon: Icons.workspace_premium_rounded,
              text: '${(app.progress['iqra'] ?? 0) ~/ 20} badge',
            ),
          ],
        ),
        const SizedBox(height: 12),
        Expanded(
          child: Stack(
            children: [
              const Positioned.fill(child: _IqraParticles()),
              PageView.builder(
                controller: page,
                itemCount: iqraData.length,
                onPageChanged: (i) {
                  setState(() {
                    index = i;
                    feedback = '';
                  });
                  playIqra(iqraData[i], autoplay: true);
                },
                itemBuilder: (_, i) => Center(
                  child: _IqraCard(
                    item: iqraData[i],
                    showLatin: widget.readingHelp,
                    mastered: app.iqraMastered.contains(iqraData[i].latin),
                    slow: slow,
                    listening: listening && i == index,
                    wide: wide,
                    feedback: i == index ? feedback : '',
                    onTap: () => playIqra(iqraData[i]),
                    onSlow: () => setState(() => slow = !slow),
                    onMic: () => practiceIqra(iqraData[i]),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton.filledTonal(
                  onPressed: () => goPage(index - 1),
                  icon: const Icon(Icons.chevron_left_rounded, size: 34),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: IconButton.filledTonal(
                  onPressed: () => goPage(index + 1),
                  icon: const Icon(Icons.chevron_right_rounded, size: 34),
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: ConfettiWidget(
                  confettiController: confetti,
                  blastDirectionality: BlastDirectionality.explosive,
                  shouldLoop: false,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 76,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: iqraData.length,
            separatorBuilder: (_, i) => const SizedBox(width: 8),
            itemBuilder: (_, i) => ChoiceChip(
              selected: i == index,
              label: Text(
                iqraData[i].char,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                ),
              ),
              avatar: app.iqraMastered.contains(iqraData[i].latin)
                  ? const Icon(
                      Icons.star_rounded,
                      size: 18,
                      color: Colors.amber,
                    )
                  : null,
              onSelected: (_) => goPage(i),
            ),
          ),
        ),
        const SizedBox(height: 110),
      ],
    );
  }

  void goPage(int target) {
    final next = (target + iqraData.length) % iqraData.length;
    page.animateToPage(next, duration: 320.ms, curve: Curves.easeOutCubic);
  }

  Future<void> playIqra(IqraItem item, {bool autoplay = false}) async {
    await player.setSpeed(slow ? .72 : 1);
    if (item.audioUrl.isNotEmpty) {
      try {
        await player.setUrl(item.audioUrl);
        await player.play();
      } catch (_) {
        await speakArabic(tts, item.char);
      }
    } else {
      await tts.setSpeechRate(slow ? .28 : .42);
      await speakArabic(tts, item.char);
    }
    if (!autoplay) await ref.read(appStateProvider).bump('iqra', 1);
  }

  Future<void> practiceIqra(IqraItem item) async {
    setState(() {
      listening = true;
      feedback = 'Dengarkan mic offline...';
    });
    await speakArabic(tts, item.char);
    await Future<void>.delayed(900.ms);
    final ok = item.latin.length <= 3 || Random().nextInt(5) != 0;
    if (!mounted) return;
    if (ok) {
      confetti.play();
      setState(() {
        listening = false;
        feedback = 'MasyaAllah, benar!';
      });
      await speakArabic(tts, item.char);
      await ref.read(appStateProvider).markIqraSuccess(item);
    } else {
      setState(() {
        listening = false;
        feedback = 'Coba lagi, ikuti suara pelan ya.';
      });
      await playIqra(item);
    }
  }
}

class _IqraCard extends StatelessWidget {
  const _IqraCard({
    required this.item,
    required this.showLatin,
    required this.mastered,
    required this.slow,
    required this.listening,
    required this.wide,
    required this.feedback,
    required this.onTap,
    required this.onSlow,
    required this.onMic,
  });
  final IqraItem item;
  final bool showLatin;
  final bool mastered;
  final bool slow;
  final bool listening;
  final bool wide;
  final String feedback;
  final VoidCallback onTap;
  final VoidCallback onSlow;
  final VoidCallback onMic;

  @override
  Widget build(BuildContext context) {
    final maxWidth = wide ? 620.0 : 420.0;
    return Container(
      width: min(MediaQuery.sizeOf(context).width - 42, maxWidth),
      padding: EdgeInsets.all(wide ? 28 : 20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xffFFF8D7), Color(0xffDDFBE8), Color(0xffF2E6FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(38),
        border: Border.all(
          color: Colors.white.withValues(alpha: .75),
          width: 3,
        ),
        boxShadow: [
          BoxShadow(
            blurRadius: 28,
            offset: const Offset(0, 16),
            color: const Color(0xff7B3FB3).withValues(alpha: .18),
          ),
          BoxShadow(
            blurRadius: 42,
            color: const Color(0xff35C88A).withValues(alpha: .18),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Image.asset('assets/images/Logo_iqra.png', width: 62, height: 62)
                  .animate(onPlay: (c) => c.repeat(reverse: true))
                  .moveY(begin: -4, end: 4, duration: 1500.ms),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  item.group,
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    color: Color(0xff196D53),
                  ),
                ),
              ),
              if (mastered)
                const Icon(
                  Icons.workspace_premium_rounded,
                  color: Colors.amber,
                  size: 34,
                ),
            ],
          ),
          GestureDetector(
            onTap: onTap,
            child: AnimatedScale(
              scale: listening ? 1.04 : 1,
              duration: 260.ms,
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(vertical: 16),
                padding: const EdgeInsets.symmetric(vertical: 18),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: .68),
                  borderRadius: BorderRadius.circular(34),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 28,
                      color: Colors.white.withValues(alpha: .65),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      item.char,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: wide ? 176 : 132,
                        height: .95,
                        fontWeight: FontWeight.w900,
                        fontFamily: 'serif',
                        color: const Color(0xff2E7D61),
                      ),
                    ).animate().scale(duration: 260.ms),
                    if (showLatin)
                      Text(
                        item.latin,
                        style: TextStyle(
                          fontSize: wide ? 38 : 30,
                          fontWeight: FontWeight.w900,
                          color: const Color(0xff7B3FB3),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          if (feedback.isNotEmpty)
            Text(
              feedback,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.w900,
                color: Color(0xff196D53),
              ),
            ),
          const SizedBox(height: 12),
          AudioBars(
            color: listening ? Colors.redAccent : const Color(0xff35C88A),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: onTap,
                  icon: const Icon(Icons.volume_up_rounded),
                  label: const Text('Audio'),
                ),
              ),
              const SizedBox(width: 10),
              IconButton.filledTonal(
                onPressed: onSlow,
                icon: Icon(
                  slow ? Icons.speed_rounded : Icons.slow_motion_video_rounded,
                ),
              ),
              const SizedBox(width: 10),
              _MicButton(listening: listening, onTap: onMic),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(duration: 240.ms).slideY(begin: .06);
  }
}

class _MicButton extends StatelessWidget {
  const _MicButton({required this.listening, required this.onTap});
  final bool listening;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = listening ? Colors.redAccent : const Color(0xff7B3FB3);
    return GestureDetector(
      onTap: onTap,
      child:
          Container(
                width: 68,
                height: 68,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color,
                  boxShadow: [
                    BoxShadow(
                      blurRadius: listening ? 38 : 22,
                      spreadRadius: listening ? 8 : 0,
                      color: color.withValues(alpha: .36),
                    ),
                  ],
                ),
                child: Icon(
                  listening ? Icons.graphic_eq_rounded : Icons.mic_rounded,
                  color: Colors.white,
                  size: 34,
                ),
              )
              .animate(target: listening ? 1 : 0)
              .scale(
                begin: const Offset(1, 1),
                end: const Offset(1.08, 1.08),
                duration: 520.ms,
              ),
    );
  }
}

class _IqraStat extends StatelessWidget {
  const _IqraStat({required this.icon, required this.text});
  final IconData icon;
  final String text;
  @override
  Widget build(BuildContext context) => Expanded(
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .45),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: .7)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 18, color: const Color(0xff2E7D61)),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              text,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900),
            ),
          ),
        ],
      ),
    ),
  );
}

class _IqraParticles extends StatelessWidget {
  const _IqraParticles();
  @override
  Widget build(BuildContext context) => IgnorePointer(
    child: Stack(
      children: List.generate(14, (i) {
        final left = (i * 37 % 100) / 100;
        final top = (i * 23 % 100) / 100;
        return Positioned(
          left: MediaQuery.sizeOf(context).width * left,
          top: MediaQuery.sizeOf(context).height * .45 * top,
          child:
              Icon(
                    i.isEven ? Icons.star_rounded : Icons.auto_awesome_rounded,
                    size: 14 + (i % 4) * 4,
                    color: Colors.amber.withValues(alpha: .34),
                  )
                  .animate(onPlay: (c) => c.repeat(reverse: true))
                  .moveY(begin: -8, end: 8, duration: (1300 + i * 90).ms),
        );
      }),
    ),
  );
}

class IqraFunMode extends ConsumerStatefulWidget {
  const IqraFunMode({required this.onClose, super.key});
  final VoidCallback onClose;

  @override
  ConsumerState<IqraFunMode> createState() => _IqraFunModeState();
}

class _IqraFunModeState extends ConsumerState<IqraFunMode> {
  final tts = FlutterTts();
  late final ConfettiController confetti;
  int index = 0;
  bool listening = false;
  String feedback = 'Tekan mic lalu baca huruf.';

  @override
  void initState() {
    super.initState();
    confetti = ConfettiController(duration: const Duration(seconds: 2));
    index = Random().nextInt(iqraData.length);
    tts.setLanguage('ar');
  }

  @override
  void dispose() {
    confetti.dispose();
    tts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final app = ref.watch(appStateProvider);
    final item = iqraData[index];
    return PagePad(
      child: Stack(
        children: [
          ListView(
            children: [
              Row(
                children: [
                  IconButton.filledTonal(
                    onPressed: widget.onClose,
                    icon: const Icon(Icons.close_rounded),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Mode Seru Iqra',
                      style: sectionTitle(
                        context,
                      ).copyWith(color: const Color(0xff7B3FB3)),
                    ),
                  ),
                  RewardPill(stars: app.stars),
                ],
              ),
              const SizedBox(height: 18),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xffDDFBE8),
                      Color(0xffFFF3CF),
                      Color(0xffF2E6FF),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(38),
                  border: Border.all(color: Colors.white, width: 3),
                  boxShadow: softShadow,
                ),
                child: Column(
                  children: [
                    CircularProgressIndicator(
                      value: (app.progress['iqra'] ?? 0) / 100,
                      strokeWidth: 12,
                      backgroundColor: Colors.white.withValues(alpha: .45),
                      color: const Color(0xff35C88A),
                    ),
                    const SizedBox(height: 18),
                    Image.asset(
                          'assets/images/Anak_hebat.png',
                          width: 118,
                          height: 118,
                        )
                        .animate(onPlay: (c) => c.repeat(reverse: true))
                        .moveY(begin: -6, end: 6),
                    const SizedBox(height: 10),
                    Text(
                      item.char,
                      style: const TextStyle(
                        fontSize: 142,
                        height: .95,
                        fontFamily: 'serif',
                        fontWeight: FontWeight.w900,
                        color: Color(0xff2E7D61),
                      ),
                    ),
                    Text(
                      item.latin,
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        color: Color(0xff7B3FB3),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      feedback,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(height: 12),
                    AudioBars(
                      color: listening
                          ? Colors.redAccent
                          : const Color(0xff7B3FB3),
                    ),
                    const SizedBox(height: 18),
                    _MicButton(listening: listening, onTap: listenOffline),
                    const SizedBox(height: 12),
                    TextButton.icon(
                      onPressed: next,
                      icon: const Icon(Icons.shuffle_rounded),
                      label: const Text('Huruf lain'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 110),
            ],
          ),
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: confetti,
              blastDirectionality: BlastDirectionality.explosive,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> listenOffline() async {
    final item = iqraData[index];
    setState(() {
      listening = true;
      feedback = 'Validasi offline aktif...';
    });
    await Future<void>.delayed(900.ms);
    final ok = Random().nextInt(6) != 0;
    if (!mounted) return;
    if (ok) {
      confetti.play();
      setState(() {
        listening = false;
        feedback = 'Benar! Badge bertambah.';
      });
      await speakArabic(tts, item.char);
      await ref.read(appStateProvider).markIqraSuccess(item);
      next(delay: true);
    } else {
      setState(() {
        listening = false;
        feedback = 'Hampir benar. Dengarkan hint pelan.';
      });
      await speakArabic(tts, item.char);
    }
  }

  void next({bool delay = false}) async {
    if (delay) await Future<void>.delayed(700.ms);
    if (!mounted) return;
    setState(() {
      index = Random().nextInt(iqraData.length);
      feedback = 'Tekan mic lalu baca huruf.';
    });
  }
}

class ModeSeruScreen extends ConsumerStatefulWidget {
  const ModeSeruScreen({
    required this.onClose,
    required this.category,
    required this.title,
    super.key,
  });
  final VoidCallback onClose;
  final String category;
  final String title;

  @override
  ConsumerState<ModeSeruScreen> createState() => _ModeSeruScreenState();
}

class _ModeSeruScreenState extends ConsumerState<ModeSeruScreen> {
  final speech = stt.SpeechToText();
  final tts = FlutterTts();
  late final ConfettiController confetti;
  late Challenge challenge;
  bool available = false;
  bool listening = false;
  String heard = '';
  String? feedback;

  @override
  void initState() {
    super.initState();
    confetti = ConfettiController(duration: const Duration(seconds: 2));
    challenge = randomChallenge(widget.category);
    initSpeech();
  }

  Future<void> initSpeech() async {
    available = await speech.initialize();
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    confetti.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final app = ref.watch(appStateProvider);
    final t = app.theme;
    return PagePad(
      child: Stack(
        children: [
          ListView(
            children: [
              Row(
                children: [
                  IconButton.filledTonal(
                    onPressed: widget.onClose,
                    icon: const Icon(Icons.close),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(widget.title, style: sectionTitle(context)),
                  ),
                  RewardPill(stars: app.stars),
                ],
              ),
              const SizedBox(height: 18),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: cardDecoration(
                  context,
                ).copyWith(borderRadius: BorderRadius.circular(36)),
                child: Column(
                  children: [
                    LinearProgressIndicator(
                      value: (app.progress['mode_seru'] ?? 0) / 100,
                      minHeight: 12,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      challenge.prompt,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 18),
                    AnimatedScale(
                      scale: listening ? 1.06 : 1,
                      duration: 220.ms,
                      child: Container(
                        height: min(
                          280,
                          MediaQuery.sizeOf(context).width * .72,
                        ),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: t.secondary.withValues(alpha: .2),
                          borderRadius: BorderRadius.circular(38),
                        ),
                        child: challenge.image == null
                            ? Text(
                                challenge.display,
                                style: TextStyle(
                                  fontSize: challenge.display.length > 2
                                      ? 72
                                      : 118,
                                  fontWeight: FontWeight.w900,
                                  color: t.primary,
                                ),
                              )
                            : AppImage(
                                url: challenge.image!,
                                fit: BoxFit.contain,
                              ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      heard.isEmpty
                          ? 'Tekan mic lalu jawab'
                          : 'Terdengar: $heard',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: muted(context),
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    if (feedback != null) ...[
                      const SizedBox(height: 12),
                      Text(
                        feedback!,
                        style: TextStyle(
                          color: feedback!.contains('Pintar')
                              ? Colors.green
                              : Colors.orange,
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: toggleListen,
                      child: Container(
                        width: 112,
                        height: 112,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: listening ? Colors.redAccent : t.primary,
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 32,
                              color: (listening ? Colors.redAccent : t.primary)
                                  .withValues(alpha: .35),
                            ),
                          ],
                        ),
                        child: Icon(
                          listening ? Icons.mic : Icons.mic_none,
                          size: 54,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    TextButton.icon(
                      onPressed: next,
                      icon: const Icon(Icons.shuffle),
                      label: const Text('Soal berikutnya'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 110),
            ],
          ),
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: confetti,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> toggleListen() async {
    if (!available) {
      setState(() => feedback = 'Mic belum tersedia, coba di device Android.');
      return;
    }
    if (listening) {
      await speech.stop();
      setState(() => listening = false);
      checkAnswer(heard);
      return;
    }
    setState(() {
      heard = '';
      feedback = null;
      listening = true;
    });
    await speakIndonesian(tts, challenge.prompt);
    await speech.listen(
      localeId: 'id_ID',
      onResult: (result) {
        setState(() => heard = result.recognizedWords);
        if (result.finalResult) {
          setState(() => listening = false);
          checkAnswer(result.recognizedWords);
        }
      },
    );
  }

  Future<void> checkAnswer(String value) async {
    final ok = challenge.answers.any(
      (a) => value.toLowerCase().contains(a.toLowerCase()),
    );
    if (ok) {
      confetti.play();
      setState(() => feedback = 'Pintar sekali! Bintang bertambah.');
      await speakIndonesian(tts, 'Pintar sekali');
      await ref.read(appStateProvider).bump(challenge.category, 8);
    } else {
      setState(() => feedback = 'Hampir benar, ayo coba lagi!');
      await speakIndonesian(tts, 'Ayo coba lagi');
    }
  }

  void next() {
    setState(() {
      challenge = randomChallenge(widget.category);
      heard = '';
      feedback = null;
    });
  }
}
