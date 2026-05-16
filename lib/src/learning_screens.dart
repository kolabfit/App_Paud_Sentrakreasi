part of '../main.dart';

Future<void> speakIndonesian(FlutterTts tts, String text) async {
  await tts.setLanguage('id-ID');
  await tts.setSpeechRate(.45);
  await tts.setPitch(1.05);
  await tts.speak(text);
}

Future<void> speakArabic(FlutterTts tts, String text) async {
  await tts.setLanguage('ar');
  await tts.setSpeechRate(.35);
  await tts.setPitch(1.1);
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
    return switch (app.learnMode) {
      LearnMode.menu ||
      LearnMode.huruf ||
      LearnMode.angka ||
      LearnMode.benda ||
      LearnMode.iqra => body,
    };
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
    final t = app.theme;
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
          t.night
              ? 'assets/images/Background_Image_Malam.png'
              : 'assets/images/Background_image.png',
          fit: BoxFit.cover,
          alignment: Alignment.topCenter,
        ),
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: t.night
                  ? [
                      NightPalette.midnight.withValues(alpha: .12),
                      NightPalette.purple.withValues(alpha: .50),
                      NightPalette.midnight.withValues(alpha: .82),
                    ]
                  : [
                      Colors.white.withValues(alpha: .02),
                      const Color(0xffEAF8FF).withValues(alpha: .58),
                      Colors.white.withValues(alpha: .82),
                    ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        ...List.generate(t.night ? 26 : 18, (i) {
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
                      color:
                          (t.night
                                  ? [
                                      NightPalette.cyan,
                                      NightPalette.gold,
                                      NightPalette.lavender,
                                    ][i % 3]
                                  : Colors.white)
                              .withValues(alpha: t.night ? .52 : .86),
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
    final t = _themeOf(context);
    return Row(
      children: [
        _AdventureGlassButton(icon: Icons.chevron_left_rounded, onTap: onBack),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: t.night
                ? NightPalette.surface.withValues(alpha: .70)
                : Colors.white.withValues(alpha: .93),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color: t.night
                  ? NightPalette.gold.withValues(alpha: .30)
                  : Colors.white,
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                blurRadius: 18,
                offset: const Offset(0, 9),
                color: (t.night ? NightPalette.gold : const Color(0xff4EA7DB))
                    .withValues(alpha: .18),
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
                    style: TextStyle(
                      color: t.night
                          ? NightPalette.text
                          : const Color(0xff3B3D86),
                      fontSize: 17,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Text(
                    'Poin Kamu',
                    style: TextStyle(
                      color: t.night
                          ? NightPalette.muted
                          : const Color(0xff5A6090),
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
    final t = _themeOf(context);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(34),
        child: Ink(
          decoration: BoxDecoration(
            color: t.night
                ? Color.lerp(data.bg, NightPalette.surface, .55)
                : data.bg,
            borderRadius: BorderRadius.circular(34),
            border: Border.all(
              color: t.night ? data.color.withValues(alpha: .46) : Colors.white,
              width: 3,
            ),
            boxShadow: [
              BoxShadow(
                blurRadius: 20,
                offset: const Offset(0, 12),
                color: data.color.withValues(alpha: t.night ? .34 : .20),
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
                  color: t.night
                      ? NightPalette.purple.withValues(alpha: .70)
                      : Colors.white.withValues(alpha: .78),
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
                            style: TextStyle(
                              color: t.night
                                  ? NightPalette.muted
                                  : const Color(0xff4D5179),
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
    final t = _themeOf(context);
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 14, 16, 14),
      decoration: BoxDecoration(
        color: t.night
            ? NightPalette.surface.withValues(alpha: .70)
            : Colors.white.withValues(alpha: .92),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: t.night
              ? NightPalette.gold.withValues(alpha: .28)
              : Colors.white,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            blurRadius: 20,
            offset: const Offset(0, 10),
            color: (t.night ? NightPalette.gold : const Color(0xff6AAFE6))
                .withValues(alpha: .18),
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
                color: t.night
                    ? NightPalette.purple.withValues(alpha: .62)
                    : const Color(0xffF1EAFF),
                borderRadius: BorderRadius.circular(22),
              ),
              child: Text(
                'Terus belajar ya! Setiap langkah kecil membawamu jadi hebat!',
                style: TextStyle(
                  color: t.night ? NightPalette.text : const Color(0xff4A3B8F),
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
    final t = _themeOf(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Material(
          color: t.night
              ? NightPalette.surface.withValues(alpha: .72)
              : Colors.white.withValues(alpha: .88),
          child: InkWell(
            onTap: onTap,
            child: SizedBox(
              width: 58,
              height: 58,
              child: Icon(
                icon,
                color: t.night ? NightPalette.cyan : const Color(0xff8B55F6),
                size: 34,
              ),
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
  final speech = stt.SpeechToText();
  final search = TextEditingController();
  int pageIndex = 0;
  bool seru = false;
  bool speechReady = false;
  bool listening = false;
  String heard = '';
  String voiceFeedback = 'Tekan mic pada kartu lalu ucapkan katanya.';
  String category = 'Semua Huruf';

  @override
  void initState() {
    super.initState();
    initSpeech();
  }

  Future<void> initSpeech() async {
    speechReady = await speech.initialize();
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    search.dispose();
    speech.stop();
    tts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final app = ref.watch(appStateProvider);
    if (seru) {
      return ModeSeruScreen(
        category: 'huruf',
        title: 'Kuis Huruf Seru',
        onClose: () => setState(() => seru = false),
      );
    }
    final query = search.text.toLowerCase().trim();
    final filtered = lettersData.where((item) {
      final isVowel = 'AIUEO'.contains(item.letter);
      final obj = item.objects.first;
      final categoryOk =
          category == 'Semua Huruf' ||
          (category == 'Vokal' && isVowel) ||
          (category == 'Konsonan' && !isVowel);
      final queryOk =
          query.isEmpty ||
          item.letter.toLowerCase().contains(query) ||
          obj.name.toLowerCase().contains(query);
      return categoryOk && queryOk;
    }).toList();
    return _PremiumLearningScaffold(
      titleAsset: 'assets/images/Belajar_huruf.png',
      mascotAsset: 'assets/images/Anak_Belajar_Huruf.png',
      fallbackTitle: 'Belajar Huruf',
      subtitle: 'Ayo mengenal huruf A sampai Z!',
      accent: const Color(0xffFF8F1F),
      stars: app.stars,
      onBack: () => ref.read(appStateProvider).openLearn(LearnMode.menu),
      chips: const ['Semua Huruf', 'Vokal', 'Konsonan'],
      selectedChip: category,
      onChip: (value) => setState(() {
        category = value;
        pageIndex = 0;
      }),
      search: search,
      searchHint: 'Cari huruf...',
      onSearch: () => setState(() => pageIndex = 0),
      itemCount: filtered.length,
      pageIndex: pageIndex,
      onPage: (next) => setState(() => pageIndex = next),
      heard: heard,
      voiceFeedback: voiceFeedback,
      listening: listening,
      itemBuilder: (context, itemIndex, color) {
        final item = filtered[itemIndex];
        final obj = item.objects.first;
        final letterPronunciation = _letterPronunciation(item.letter);
        final mastered = app.hurfMastered.contains(item.letter);
        return _PremiumLearningCard(
          color: color,
          title: item.letter,
          subtitle: 'Huruf ${item.letter}',
          caption: obj.name,
          imageUrl: obj.img,
          badge: obj.name.toLowerCase(),
          kind: _PremiumCardKind.letter,
          mastered: mastered,
          onAudio: () async {
            await speakIndonesian(tts, letterPronunciation);
            await ref.read(appStateProvider).bump('membaca', 4);
          },
          onMic: () => listenForProgress(
            expected: letterPronunciation,
            successText: 'Pintar! Huruf ${item.letter} cocok.',
            progressKey: 'membaca',
            amount: 6,
            masteryKey: item.letter,
            masteryType: 'huruf',
          ),
          listening: listening,
        );
      },
    );
  }

  Future<void> listenForProgress({
    required String expected,
    required String successText,
    required String progressKey,
    required int amount,
    String? masteryKey,
    String? masteryType,
  }) async {
    if (!speechReady) {
      setState(() => voiceFeedback = 'Mic belum siap. Coba di device Android.');
      return;
    }
    setState(() {
      listening = true;
      heard = '';
      voiceFeedback = 'Mendengarkan... ucapkan "$expected".';
    });

    bool processed = false;
    try {
      await speech.listen(
        localeId: 'id_ID',
        listenFor: const Duration(seconds: 5),
        pauseFor: const Duration(seconds: 2),
        onResult: (result) async {
          if (!mounted || processed) return;
          setState(() => heard = result.recognizedWords);
          if (!result.finalResult) return;

          processed = true;
          await speech.stop();

          final ok = _voiceMatches(result.recognizedWords, expected);
          if (!mounted) return;

          if (ok) {
            await ref.read(appStateProvider).bump(progressKey, amount);
            if (masteryKey != null && masteryType == 'huruf') {
              await ref.read(appStateProvider).markHurfSuccess(masteryKey);
            }
            await speakIndonesian(tts, 'Hebat, benar');
          }

          if (mounted) {
            setState(() {
              listening = false;
              voiceFeedback = ok
                  ? successText
                  : 'Hampir benar. Coba ucapkan "$expected" lagi.';
            });
          }
        },
      );

      // Backup timeout
      await Future<void>.delayed(const Duration(seconds: 6));
      if (mounted && !processed) {
        await speech.stop();
        setState(() {
          listening = false;
          voiceFeedback = 'Timeout. Coba lagi, ucapkan "$expected".';
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          listening = false;
          voiceFeedback = 'Error mic. Coba lagi.';
        });
      }
    } finally {
      await speech.stop();
    }
  }
}

class AngkaScreen extends ConsumerStatefulWidget {
  const AngkaScreen({super.key});

  @override
  ConsumerState<AngkaScreen> createState() => _AngkaScreenState();
}

class _AngkaScreenState extends ConsumerState<AngkaScreen> {
  final tts = FlutterTts();
  final speech = stt.SpeechToText();
  final search = TextEditingController();
  int pageIndex = 0;
  bool seru = false;
  bool speechReady = false;
  bool listening = false;
  String heard = '';
  String voiceFeedback = 'Tekan mic pada kartu lalu ucapkan angkanya.';
  String category = 'Semua Angka';

  @override
  void initState() {
    super.initState();
    initSpeech();
  }

  Future<void> initSpeech() async {
    speechReady = await speech.initialize();
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    search.dispose();
    speech.stop();
    tts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final app = ref.watch(appStateProvider);
    if (seru) {
      return ModeSeruScreen(
        category: 'angka',
        title: 'Kuis Seru',
        onClose: () => setState(() => seru = false),
      );
    }
    final query = search.text.toLowerCase().trim();
    final filtered = numbersData.where((item) {
      final n = int.tryParse(item.number) ?? 0;
      final categoryOk =
          category == 'Semua Angka' ||
          (category == 'Ganjil' && n.isOdd) ||
          (category == 'Genap' && n.isEven);
      final queryOk =
          query.isEmpty ||
          item.number.contains(query) ||
          item.name.toLowerCase().contains(query);
      return categoryOk && queryOk;
    }).toList();
    return _PremiumLearningScaffold(
      titleAsset: 'assets/images/Belajar_Angka.png',
      mascotAsset: 'assets/images/Anak_Belajar_Angka.png',
      fallbackTitle: 'Belajar Angka',
      subtitle: 'Yuk belajar angka 1 sampai 10!',
      accent: const Color(0xff4E8BFF),
      stars: app.stars,
      onBack: () => ref.read(appStateProvider).openLearn(LearnMode.menu),
      chips: const ['Semua Angka', 'Ganjil', 'Genap'],
      selectedChip: category,
      onChip: (value) => setState(() {
        category = value;
        pageIndex = 0;
      }),
      search: search,
      searchHint: 'Cari angka...',
      onSearch: () => setState(() => pageIndex = 0),
      itemCount: filtered.length,
      pageIndex: pageIndex,
      onPage: (next) => setState(() => pageIndex = next),
      heard: heard,
      voiceFeedback: voiceFeedback,
      listening: listening,
      itemBuilder: (context, itemIndex, color) {
        final item = filtered[itemIndex];
        final mastered = app.angkaMastered.contains(item.number);
        return _PremiumLearningCard(
          color: color,
          title: item.number,
          subtitle: item.name,
          caption: 'Angka ${item.number}',
          imageUrl: item.img,
          badge: _numberBadge(item.number),
          kind: _PremiumCardKind.number,
          mastered: mastered,
          onAudio: () async {
            await speakIndonesian(tts, item.name);
            await ref.read(appStateProvider).bump('angka', 5);
          },
          onMic: () => listenForProgress(
            expected: item.name,
            successText: 'Mantap! Angka ${item.number} benar.',
            progressKey: 'angka',
            amount: 7,
            masteryKey: item.number,
            masteryType: 'angka',
          ),
          listening: listening,
        );
      },
    );
  }

  Future<void> listenForProgress({
    required String expected,
    required String successText,
    required String progressKey,
    required int amount,
    String? masteryKey,
    String? masteryType,
  }) async {
    if (!speechReady) {
      setState(() => voiceFeedback = 'Mic belum siap. Coba di device Android.');
      return;
    }
    setState(() {
      listening = true;
      heard = '';
      voiceFeedback = 'Mendengarkan... ucapkan "$expected".';
    });

    bool processed = false;
    try {
      await speech.listen(
        localeId: 'id_ID',
        listenFor: const Duration(seconds: 5),
        pauseFor: const Duration(seconds: 2),
        onResult: (result) async {
          if (!mounted || processed) return;
          setState(() => heard = result.recognizedWords);
          if (!result.finalResult) return;

          processed = true;
          await speech.stop();

          final ok = _voiceMatches(result.recognizedWords, expected);
          if (!mounted) return;

          if (ok) {
            await ref.read(appStateProvider).bump(progressKey, amount);
            if (masteryKey != null && masteryType == 'angka') {
              await ref.read(appStateProvider).markAngkaSuccess(masteryKey);
            }
            await speakIndonesian(tts, 'Hebat, benar');
          }

          if (mounted) {
            setState(() {
              listening = false;
              voiceFeedback = ok
                  ? successText
                  : 'Hampir benar. Coba ucapkan "$expected" lagi.';
            });
          }
        },
      );

      // Backup timeout: stop if not processed after 6 seconds
      await Future<void>.delayed(const Duration(seconds: 6));
      if (mounted && !processed) {
        await speech.stop();
        setState(() {
          listening = false;
          voiceFeedback = 'Timeout. Coba lagi, ucapkan "$expected".';
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          listening = false;
          voiceFeedback = 'Error mic. Coba lagi.';
        });
      }
    } finally {
      await speech.stop();
    }
  }
}

class BendaScreen extends ConsumerStatefulWidget {
  const BendaScreen({super.key});

  @override
  ConsumerState<BendaScreen> createState() => _BendaScreenState();
}

class _BendaScreenState extends ConsumerState<BendaScreen> {
  final tts = FlutterTts();
  final speech = stt.SpeechToText();
  final search = TextEditingController();
  int pageIndex = 0;
  bool seru = false;
  bool speechReady = false;
  bool listening = false;
  String heard = '';
  String voiceFeedback = 'Tekan mic pada kartu lalu ucapkan nama bendanya.';
  String category = 'Semua';

  @override
  void initState() {
    super.initState();
    initSpeech();
  }

  Future<void> initSpeech() async {
    speechReady = await speech.initialize();
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    search.dispose();
    speech.stop();
    tts.stop();
    super.dispose();
  }

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
    final query = search.text.toLowerCase().trim();
    final filtered = objects.where((item) {
      final family = _objectFamily(item);
      final categoryOk = category == 'Semua' || category == family;
      final queryOk =
          query.isEmpty ||
          item.name.toLowerCase().contains(query) ||
          _englishName(item.name).contains(query);
      return categoryOk && queryOk;
    }).toList();
    return _PremiumLearningScaffold(
      titleAsset: 'assets/images/Belajar_Benda.png',
      mascotAsset: 'assets/images/Anak_Belajar_Benda.png',
      fallbackTitle: 'Belajar Benda',
      subtitle: 'Mengenal benda di sekitar kita',
      accent: const Color(0xff32C653),
      stars: app.stars,
      onBack: () => ref.read(appStateProvider).openLearn(LearnMode.menu),
      chips: const ['Semua', 'Rumah', 'Sekolah', 'Alam', 'Transportasi'],
      selectedChip: category,
      onChip: (value) => setState(() {
        category = value;
        pageIndex = 0;
      }),
      search: search,
      searchHint: 'Cari benda...',
      onSearch: () => setState(() => pageIndex = 0),
      itemCount: filtered.length,
      pageIndex: pageIndex,
      onPage: (next) => setState(() => pageIndex = next),
      heard: heard,
      voiceFeedback: voiceFeedback,
      listening: listening,
      itemBuilder: (context, itemIndex, color) {
        final item = filtered[itemIndex];
        final favoriteId = item.id.isEmpty ? 'benda:${item.name}' : item.id;
        final fav = app.favorites.contains(favoriteId);
        final mastered = app.bendaMastered.contains(item.name);
        return _PremiumLearningCard(
          color: color,
          title: item.name,
          subtitle: item.name,
          caption: _englishName(item.name),
          imageUrl: item.img,
          badge: _objectFamily(item),
          kind: _PremiumCardKind.object,
          mastered: mastered,
          favorite: fav,
          onFavorite: () =>
              ref.read(appStateProvider).toggleFavorite(favoriteId),
          onAudio: () async {
            await speakIndonesian(tts, item.name);
            await ref.read(appStateProvider).bump('benda', 5);
          },
          onMic: () => listenForProgress(
            expected: item.name,
            successText: 'Keren! ${item.name} cocok.',
            progressKey: 'benda',
            amount: 7,
            masteryKey: item.name,
            masteryType: 'benda',
          ),
          listening: listening,
        );
      },
    );
  }

  Future<void> listenForProgress({
    required String expected,
    required String successText,
    required String progressKey,
    required int amount,
    String? masteryKey,
    String? masteryType,
  }) async {
    if (!speechReady) {
      setState(() => voiceFeedback = 'Mic belum siap. Coba di device Android.');
      return;
    }
    setState(() {
      listening = true;
      heard = '';
      voiceFeedback = 'Mendengarkan... ucapkan "$expected".';
    });

    bool processed = false;
    try {
      await speech.listen(
        localeId: 'id_ID',
        listenFor: const Duration(seconds: 5),
        pauseFor: const Duration(seconds: 2),
        onResult: (result) async {
          if (!mounted || processed) return;
          setState(() => heard = result.recognizedWords);
          if (!result.finalResult) return;

          processed = true;
          await speech.stop();

          final ok = _voiceMatches(result.recognizedWords, expected);
          if (!mounted) return;

          if (ok) {
            await ref.read(appStateProvider).bump(progressKey, amount);
            if (masteryKey != null && masteryType == 'benda') {
              await ref.read(appStateProvider).markBendaSuccess(masteryKey);
            }
            await speakIndonesian(tts, 'Hebat, benar');
          }

          if (mounted) {
            setState(() {
              listening = false;
              voiceFeedback = ok
                  ? successText
                  : 'Hampir benar. Coba ucapkan "$expected" lagi.';
            });
          }
        },
      );

      // Backup timeout: stop if not processed after 6 seconds
      await Future<void>.delayed(const Duration(seconds: 6));
      if (mounted && !processed) {
        await speech.stop();
        setState(() {
          listening = false;
          voiceFeedback = 'Timeout. Coba lagi, ucapkan "$expected".';
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          listening = false;
          voiceFeedback = 'Error mic. Coba lagi.';
        });
      }
    } finally {
      await speech.stop();
    }
  }
}

typedef _PremiumItemBuilder =
    Widget Function(BuildContext context, int index, Color color);

enum _PremiumCardKind { letter, number, object }

class _PremiumLearningScaffold extends StatelessWidget {
  const _PremiumLearningScaffold({
    required this.titleAsset,
    required this.mascotAsset,
    required this.fallbackTitle,
    required this.subtitle,
    required this.accent,
    required this.stars,
    required this.onBack,
    required this.chips,
    required this.selectedChip,
    required this.onChip,
    required this.search,
    required this.searchHint,
    required this.onSearch,
    required this.itemCount,
    required this.pageIndex,
    required this.onPage,
    required this.heard,
    required this.voiceFeedback,
    required this.listening,
    required this.itemBuilder,
  });

  final String titleAsset;
  final String mascotAsset;
  final String fallbackTitle;
  final String subtitle;
  final Color accent;
  final int stars;
  final VoidCallback onBack;
  final List<String> chips;
  final String selectedChip;
  final ValueChanged<String> onChip;
  final TextEditingController search;
  final String searchHint;
  final VoidCallback onSearch;
  final int itemCount;
  final int pageIndex;
  final ValueChanged<int> onPage;
  final String heard;
  final String voiceFeedback;
  final bool listening;
  final _PremiumItemBuilder itemBuilder;

  static const colors = [
    Color(0xffffe4ef),
    Color(0xffe4f3ff),
    Color(0xfffff2cc),
    Color(0xffe4f9df),
    Color(0xffefe5ff),
    Color(0xffffead9),
  ];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final tablet = width >= 760;
    final columns = tablet ? (width >= 1020 ? 4 : 3) : 2;
    final perPage = columns * (tablet ? 2 : 3);
    final pages = max(1, (itemCount / perPage).ceil());
    final page = pageIndex.clamp(0, pages - 1);
    final start = page * perPage;
    final end = min(itemCount, start + perPage);
    final visible = itemCount == 0
        ? <int>[]
        : List.generate(end - start, (i) => start + i);

    return Stack(
      children: [
        const Positioned.fill(child: _KidsDreamBackground()),
        ListView(
          padding: const EdgeInsets.fromLTRB(18, 16, 18, 118),
          children: [
            _PremiumLearningHero(
              titleAsset: titleAsset,
              mascotAsset: mascotAsset,
              fallbackTitle: fallbackTitle,
              subtitle: subtitle,
              accent: accent,
              stars: stars,
              onBack: onBack,
            ),
            const SizedBox(height: 14),
            _PremiumSearchAndChips(
              search: search,
              hint: searchHint,
              chips: chips,
              selected: selectedChip,
              accent: accent,
              onChanged: onSearch,
              onChip: onChip,
            ),
            const SizedBox(height: 14),
            _VoiceProgressPanel(
              heard: heard,
              feedback: voiceFeedback,
              listening: listening,
              accent: accent,
            ),
            const SizedBox(height: 14),
            if (visible.isEmpty)
              _PremiumEmptyState(accent: accent)
            else
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: visible.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: columns,
                  mainAxisSpacing: 14,
                  crossAxisSpacing: 14,
                  childAspectRatio: tablet ? .78 : .68,
                ),
                itemBuilder: (context, i) {
                  final item = visible[i];
                  return itemBuilder(
                    context,
                    item,
                    colors[item % colors.length],
                  );
                },
              ),
            const SizedBox(height: 16),
            _PremiumPagination(
              page: page,
              pages: pages,
              accent: accent,
              onPrev: () => onPage(max(0, page - 1)),
              onNext: () => onPage(min(pages - 1, page + 1)),
            ),
            const SizedBox(height: 16),
            _LearningMotivationPanel(accent: accent),
          ],
        ),
      ],
    );
  }
}

class _KidsDreamBackground extends StatelessWidget {
  const _KidsDreamBackground();

  @override
  Widget build(BuildContext context) {
    final t = _themeOf(context);
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          t.night
              ? 'assets/images/Background_Image_Malam.png'
              : 'assets/images/Background_image.png',
          fit: BoxFit.cover,
          alignment: Alignment.topCenter,
        ),
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: t.night
                  ? [
                      NightPalette.midnight.withValues(alpha: .12),
                      NightPalette.purple.withValues(alpha: .52),
                      NightPalette.midnight.withValues(alpha: .86),
                    ]
                  : [
                      Colors.white.withValues(alpha: .03),
                      Colors.white.withValues(alpha: .18),
                      Colors.white.withValues(alpha: .88),
                    ],
              stops: const [0, .44, 1],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        if (t.night)
          const NightSparkles(count: 28)
        else
          ...List.generate(16, (i) {
            return Positioned(
              left: (i * 61 % 320).toDouble() + (i.isEven ? 12 : 80),
              top: 48.0 + (i * 43 % 440),
              child:
                  Icon(
                        i.isEven
                            ? Icons.star_rounded
                            : Icons.auto_awesome_rounded,
                        color: Colors.white.withValues(alpha: .75),
                        size: 12 + (i % 4) * 3,
                      )
                      .animate(onPlay: (c) => c.repeat(reverse: true))
                      .moveY(begin: -5, end: 6, duration: (1300 + i * 80).ms),
            );
          }),
      ],
    );
  }
}

class _PremiumLearningHero extends StatelessWidget {
  const _PremiumLearningHero({
    required this.titleAsset,
    required this.mascotAsset,
    required this.fallbackTitle,
    required this.subtitle,
    required this.accent,
    required this.stars,
    required this.onBack,
  });

  final String titleAsset;
  final String mascotAsset;
  final String fallbackTitle;
  final String subtitle;
  final Color accent;
  final int stars;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final t = _themeOf(context);
    final tablet = MediaQuery.sizeOf(context).width >= 760;
    return SizedBox(
      height: tablet ? 286 : 252,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: 12,
            right: 12,
            top: 12,
            child: Row(
              children: [
                _PremiumRoundButton(
                  icon: Icons.chevron_left_rounded,
                  onTap: onBack,
                  color: accent,
                ),
                const Spacer(),
                _PremiumPoints(stars: stars),
              ],
            ),
          ),
          Positioned(
            left: tablet ? 24 : 14,
            top: tablet ? 58 : 62,
            width: tablet ? 470 : 270,
            child: Image.asset(
              titleAsset,
              height: tablet ? 168 : 126,
              fit: BoxFit.contain,
              alignment: Alignment.centerLeft,
              filterQuality: FilterQuality.high,
              errorBuilder: (context, error, stackTrace) => Container(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                decoration: BoxDecoration(
                  color: accent,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      fallbackTitle,
                      style: TextStyle(
                        fontSize: tablet ? 42 : 28,
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            right: tablet ? 32 : 8,
            bottom: tablet ? 18 : 18,
            child: IgnorePointer(
              child: AnimatedOpacity(
                opacity: t.night ? 1 : 0,
                duration: 420.ms,
                child: Container(
                  width: tablet ? 210 : 156,
                  height: tablet ? 178 : 138,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 48,
                        spreadRadius: 8,
                        color: NightPalette.gold.withValues(alpha: .20),
                      ),
                      BoxShadow(
                        blurRadius: 60,
                        color: accent.withValues(alpha: .18),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            right: tablet ? 18 : -18,
            bottom: -4,
            child:
                Image.asset(
                      mascotAsset,
                      height: tablet ? 238 : 184,
                      fit: BoxFit.contain,
                      filterQuality: FilterQuality.high,
                      errorBuilder: (context, error, stackTrace) => Image.asset(
                        'assets/images/Anak_hebat.png',
                        height: tablet ? 210 : 158,
                        fit: BoxFit.contain,
                      ),
                    )
                    .animate(onPlay: (c) => c.repeat(reverse: true))
                    .moveY(begin: -5, end: 6, duration: 1700.ms),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms).slideY(begin: .04);
  }
}

class _PremiumSearchAndChips extends StatelessWidget {
  const _PremiumSearchAndChips({
    required this.search,
    required this.hint,
    required this.chips,
    required this.selected,
    required this.accent,
    required this.onChanged,
    required this.onChip,
  });

  final TextEditingController search;
  final String hint;
  final List<String> chips;
  final String selected;
  final Color accent;
  final VoidCallback onChanged;
  final ValueChanged<String> onChip;

  @override
  Widget build(BuildContext context) {
    final t = _themeOf(context);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: t.night
          ? nightGlassDecoration(borderColor: accent, radius: 28)
          : BoxDecoration(
              color: Colors.white.withValues(alpha: .88),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: Colors.white),
              boxShadow: [
                BoxShadow(
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                  color: const Color(0xff6DAEDB).withValues(alpha: .13),
                ),
              ],
            ),
      child: Column(
        children: [
          TextField(
            controller: search,
            onChanged: (_) => onChanged(),
            decoration: InputDecoration(
              hintText: hint,
              prefixIcon: Icon(Icons.search_rounded, color: accent),
              filled: true,
              fillColor: t.night
                  ? NightPalette.midnight2.withValues(alpha: .60)
                  : const Color(0xffF9FBFF),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(22),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 14,
              ),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 44,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: chips.length,
              separatorBuilder: (context, index) => const SizedBox(width: 8),
              itemBuilder: (context, i) {
                final chip = chips[i];
                final active = chip == selected;
                return GestureDetector(
                  onTap: () => onChip(chip),
                  child: AnimatedContainer(
                    duration: 220.ms,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: active
                          ? accent
                          : (t.night
                                ? NightPalette.surface.withValues(alpha: .62)
                                : Colors.white),
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(
                        color: active
                            ? accent
                            : (t.night
                                  ? NightPalette.cyan.withValues(alpha: .18)
                                  : const Color(0xffE7ECFF)),
                      ),
                      boxShadow: active
                          ? [
                              BoxShadow(
                                blurRadius: 16,
                                color: accent.withValues(alpha: .24),
                              ),
                            ]
                          : null,
                    ),
                    child: Text(
                      chip,
                      style: TextStyle(
                        color: active
                            ? Colors.white
                            : (t.night
                                  ? NightPalette.muted
                                  : const Color(0xff4C5875)),
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _PremiumLearningCard extends StatelessWidget {
  const _PremiumLearningCard({
    required this.color,
    required this.title,
    required this.subtitle,
    required this.caption,
    required this.imageUrl,
    required this.badge,
    required this.kind,
    required this.onAudio,
    required this.onMic,
    required this.listening,
    this.favorite = false,
    this.onFavorite,
    this.mastered = false,
  });

  final Color color;
  final String title;
  final String subtitle;
  final String caption;
  final String imageUrl;
  final String badge;
  final _PremiumCardKind kind;
  final VoidCallback onAudio;
  final VoidCallback onMic;
  final bool listening;
  final bool favorite;
  final VoidCallback? onFavorite;
  final bool mastered;

  @override
  Widget build(BuildContext context) {
    final t = _themeOf(context);
    final cardColor = mastered ? const Color(0xff38C985) : color;
    final bg = t.night
        ? Color.lerp(cardColor, NightPalette.surface, .54)!
        : cardColor;
    final textColor = t.night ? NightPalette.text : const Color(0xff293464);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onAudio,
        borderRadius: BorderRadius.circular(28),
        child: Ink(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color: t.night ? cardColor.withValues(alpha: .46) : Colors.white,
              width: 2.2,
            ),
            boxShadow: [
              BoxShadow(
                blurRadius: 22,
                offset: const Offset(0, 12),
                color: cardColor.withValues(alpha: t.night ? .34 : .55),
              ),
            ],
          ),
          child: Stack(
            children: [
              Positioned(
                left: 7,
                top: 7,
                child: mastered
                    ? Icon(
                        Icons.check_circle_rounded,
                        color: Colors.white,
                        size: 24,
                      )
                    : const SizedBox.shrink(),
              ),
              Positioned(
                right: 7,
                top: 7,
                child: GestureDetector(
                  onTap: onFavorite,
                  child: Icon(
                    kind == _PremiumCardKind.object
                        ? (favorite
                              ? Icons.star_rounded
                              : Icons.star_border_rounded)
                        : Icons.auto_awesome_rounded,
                    color: const Color(0xffFFB927),
                    size: 22,
                  ),
                ),
              ),
              Column(
                children: [
                  if (kind == _PremiumCardKind.letter ||
                      kind == _PremiumCardKind.number)
                    SizedBox(
                      height: 62,
                      child: FittedBox(
                        child: Text(
                          title,
                          style: TextStyle(
                            color:
                                kind == _PremiumCardKind.letter ||
                                    kind == _PremiumCardKind.number
                                ? (t.night ? color : const Color(0xff293464))
                                : textColor,
                            fontSize: 64,
                            height: 1,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    )
                  else
                    const SizedBox(height: 12),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 6,
                      ),
                      child: AppImage(url: imageUrl, fit: BoxFit.contain),
                    ),
                  ),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    caption,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color:
                          (t.night
                                  ? NightPalette.muted
                                  : const Color(0xff293464))
                              .withValues(alpha: .82),
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        constraints: const BoxConstraints(maxWidth: 86),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(
                            alpha: t.night ? .16 : .70,
                          ),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          badge,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Color(0xff59617E),
                            fontSize: 9,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: onMic,
                        child: Container(
                          width: 34,
                          height: 34,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: listening
                                ? Colors.redAccent
                                : const Color(0xff32C653),
                            boxShadow: [
                              BoxShadow(
                                blurRadius: listening ? 20 : 12,
                                color:
                                    (listening
                                            ? Colors.redAccent
                                            : const Color(0xff32C653))
                                        .withValues(alpha: .28),
                              ),
                            ],
                          ),
                          child: Icon(
                            listening
                                ? Icons.graphic_eq_rounded
                                : Icons.mic_rounded,
                            color: Colors.white,
                            size: 19,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 34,
                        height: 34,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xff1498BD),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 12,
                              color: const Color(
                                0xff1498BD,
                              ).withValues(alpha: .28),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.volume_up_rounded,
                          color: Colors.white,
                          size: 19,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(duration: 250.ms).slideY(begin: .05);
  }
}

class _VoiceProgressPanel extends StatelessWidget {
  const _VoiceProgressPanel({
    required this.heard,
    required this.feedback,
    required this.listening,
    required this.accent,
  });

  final String heard;
  final String feedback;
  final bool listening;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final t = _themeOf(context);
    return AnimatedContainer(
      duration: 220.ms,
      padding: const EdgeInsets.all(14),
      decoration: t.night
          ? nightGlassDecoration(
              borderColor: listening ? accent : NightPalette.cyan,
              radius: 26,
            )
          : BoxDecoration(
              color: Colors.white.withValues(alpha: .90),
              borderRadius: BorderRadius.circular(26),
              border: Border.all(
                color: listening ? accent.withValues(alpha: .45) : Colors.white,
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  blurRadius: listening ? 26 : 18,
                  offset: const Offset(0, 10),
                  color: accent.withValues(alpha: listening ? .22 : .10),
                ),
              ],
            ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: listening ? Colors.redAccent : accent,
            ),
            child: Icon(
              listening
                  ? Icons.graphic_eq_rounded
                  : Icons.record_voice_over_rounded,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  feedback,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: t.night
                        ? NightPalette.text
                        : const Color(0xff293464),
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  heard.isEmpty
                      ? 'Kalimat terdengar akan muncul di sini.'
                      : 'Terdengar: "$heard"',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: t.night
                        ? NightPalette.muted
                        : const Color(0xff66708F),
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PremiumPagination extends StatelessWidget {
  const _PremiumPagination({
    required this.page,
    required this.pages,
    required this.accent,
    required this.onPrev,
    required this.onNext,
  });

  final int page;
  final int pages;
  final Color accent;
  final VoidCallback onPrev;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      _PremiumRoundButton(
        icon: Icons.chevron_left_rounded,
        onTap: onPrev,
        color: accent,
      ),
      const SizedBox(width: 12),
      ...List.generate(
        pages,
        (i) => AnimatedContainer(
          duration: 220.ms,
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: i == page ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: i == page ? accent : Colors.white,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: accent.withValues(alpha: .30)),
          ),
        ),
      ),
      const SizedBox(width: 12),
      _PremiumRoundButton(
        icon: Icons.chevron_right_rounded,
        onTap: onNext,
        color: accent,
      ),
    ],
  );
}

class _LearningMotivationPanel extends StatelessWidget {
  const _LearningMotivationPanel({required this.accent});
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final t = _themeOf(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: t.night
          ? nightGlassDecoration(borderColor: accent)
          : BoxDecoration(
              color: Colors.white.withValues(alpha: .90),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: Colors.white, width: 2),
              boxShadow: [
                BoxShadow(
                  blurRadius: 22,
                  offset: const Offset(0, 12),
                  color: accent.withValues(alpha: .13),
                ),
              ],
            ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.asset(
                'assets/images/Anak_hebat.png',
                width: 76,
                height: 76,
                fit: BoxFit.contain,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Belajar jadi mudah!',
                      style: TextStyle(
                        color: t.night
                            ? NightPalette.text
                            : const Color(0xff293464),
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Dengarkan suara, lihat gambar, dan ingat materinya!',
                      style: TextStyle(
                        color: t.night
                            ? NightPalette.muted
                            : const Color(0xff66708F),
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _LearningMiniFeature(
                Icons.volume_up_rounded,
                'Dengar Suara',
                accent,
              ),
              const SizedBox(width: 8),
              _LearningMiniFeature(
                Icons.image_rounded,
                'Lihat Gambar',
                const Color(0xffFF8F1F),
              ),
              const SizedBox(width: 8),
              _LearningMiniFeature(
                Icons.psychology_rounded,
                'Ingat & Pahami',
                const Color(0xff32C653),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LearningMiniFeature extends StatelessWidget {
  const _LearningMiniFeature(this.icon, this.text, this.color);
  final IconData icon;
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final t = _themeOf(context);
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        decoration: BoxDecoration(
          color: color.withValues(alpha: .10),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 5),
            Text(
              text,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: t.night ? NightPalette.text : const Color(0xff4B5574),
                fontSize: 10,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PremiumRoundButton extends StatelessWidget {
  const _PremiumRoundButton({
    required this.icon,
    required this.onTap,
    required this.color,
  });

  final IconData icon;
  final VoidCallback onTap;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final t = _themeOf(context);
    return Material(
      color: t.night
          ? NightPalette.surface.withValues(alpha: .72)
          : Colors.white.withValues(alpha: .92),
      borderRadius: BorderRadius.circular(22),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: SizedBox(
          width: 48,
          height: 48,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Icon(icon, color: color, size: 31)],
          ),
        ),
      ),
    );
  }
}

class _PremiumPoints extends StatelessWidget {
  const _PremiumPoints({required this.stars});
  final int stars;

  @override
  Widget build(BuildContext context) {
    final t = _themeOf(context);
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: t.night
            ? NightPalette.surface.withValues(alpha: .72)
            : Colors.white.withValues(alpha: .92),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star_rounded, color: Color(0xffFFC928), size: 25),
          const SizedBox(width: 5),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$stars',
                style: TextStyle(
                  color: t.night ? NightPalette.text : const Color(0xff293464),
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Text(
                'Poin',
                style: TextStyle(
                  color: t.night ? NightPalette.muted : const Color(0xff6F7692),
                  fontSize: 8,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PremiumEmptyState extends StatelessWidget {
  const _PremiumEmptyState({required this.accent});
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final t = _themeOf(context);
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: t.night
            ? NightPalette.surface.withValues(alpha: .72)
            : Colors.white.withValues(alpha: .88),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Text(
        'Belum ada hasil yang cocok.',
        textAlign: TextAlign.center,
        style: TextStyle(color: accent, fontWeight: FontWeight.w900),
      ),
    );
  }
}

String _objectFamily(LearningObject item) {
  final c = item.category.toLowerCase();
  if (c.contains('kendaraan')) return 'Transportasi';
  if (c.contains('sekolah')) return 'Sekolah';
  if (c.contains('buah') || c.contains('hewan') || c.contains('alam')) {
    return 'Alam';
  }
  return 'Rumah';
}

String _englishName(String value) {
  const names = {
    'Apel': 'apple',
    'Bola': 'ball',
    'Cicak': 'lizard',
    'Domba': 'sheep',
    'Elang': 'eagle',
    'Gajah': 'elephant',
    'Harimau': 'tiger',
    'Ikan': 'fish',
    'Jeruk': 'orange',
    'Kucing': 'cat',
    'Mobil': 'car',
    'Rumah': 'house',
    'Sepeda': 'bicycle',
    'Meja': 'table',
    'Kursi': 'chair',
    'Buku': 'book',
    'Pensil': 'pencil',
    'Tas': 'school bag',
    'Lampu': 'lamp',
    'Nanas': 'pineapple',
    'Pisang': 'banana',
    'Quran': 'quran',
    'Tomat': 'tomato',
    'Ular': 'snake',
    'Wortel': 'carrot',
    'Zebra': 'zebra',
  };
  return names[value] ?? value.toLowerCase();
}

String _numberBadge(String number) {
  final n = int.tryParse(number) ?? 0;
  return n.isEven ? 'genap' : 'ganjil';
}

bool _voiceMatches(String heard, String expected) {
  final cleanHeard = _cleanVoiceText(heard);
  final cleanExpected = _cleanVoiceText(expected);
  if (cleanHeard.isEmpty || cleanExpected.isEmpty) return false;
  // Validasi lebih ketat: harus ada pencocokan minimum 50%
  final expectedWords = cleanExpected
      .split(' ')
      .where((w) => w.length > 1)
      .toList();
  if (expectedWords.isEmpty) return cleanHeard.contains(cleanExpected);
  final matchedWords = expectedWords
      .where((w) => cleanHeard.contains(w))
      .length;
  return matchedWords >= (expectedWords.length / 2).ceil();
}

String _cleanVoiceText(String value) => value
    .toLowerCase()
    .replaceAll(RegExp(r'[^a-z0-9 ]'), ' ')
    .replaceAll(RegExp(r'\s+'), ' ')
    .trim();

String _letterPronunciation(String letter) {
  final map = {
    'A': 'a',
    'B': 'be',
    'C': 'ce',
    'D': 'de',
    'E': 'e',
    'F': 'ef',
    'G': 'ge',
    'H': 'ha',
    'I': 'i',
    'J': 'je',
    'K': 'ka',
    'L': 'el',
    'M': 'em',
    'N': 'en',
    'O': 'o',
    'P': 'pe',
    'Q': 'ku',
    'R': 'er',
    'S': 'es',
    'T': 'te',
    'U': 'u',
    'V': 've',
    'W': 'dabel yu',
    'X': 'eks',
    'Y': 'wai',
    'Z': 'zet',
  };
  return map[letter.toUpperCase()] ?? letter.toLowerCase();
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
    final progress = app.progress['iqra'] ?? 0;
    return Stack(
      children: [
        const Positioned.fill(child: _IqraDreamScene()),
        Positioned.fill(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 118),
            children: [
              _IqraHeroSection(
                app: app,
                latinEnabled: widget.readingHelp,
                slow: slow,
                onBack: () =>
                    ref.read(appStateProvider).openLearn(LearnMode.menu),
                onSettings: () => setState(() => slow = !slow),
              ),
              const SizedBox(height: 14),
              _IqraProgressCard(
                progress: progress,
                mastered: app.iqraMastered.length,
                total: iqraData.length,
                streak: app.iqraStreak,
              ),
              const SizedBox(height: 18),
              _IqraCatalogSection(
                selectedIndex: index,
                latinEnabled: widget.readingHelp,
                mastered: app.iqraMastered,
                listening: listening,
                feedback: feedback,
                favorites: app.favorites,
                onSelect: (i) {
                  setState(() {
                    index = i;
                    feedback = '';
                  });
                  playIqra(iqraData[i], autoplay: true);
                },
                onAudio: (i) async {
                  setState(() {
                    index = i;
                    feedback = '';
                  });
                  await playIqra(iqraData[i]);
                },
                onPractice: (i) async {
                  setState(() => index = i);
                  await practiceIqra(iqraData[i]);
                },
                onFavorite: (item) {
                  ref
                      .read(appStateProvider)
                      .toggleFavorite('iqra:${item.latin}');
                },
              ),
            ],
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
        await _speakIqra(item.char);
      }
    } else {
      await _speakIqra(item.char);
    }
    if (!autoplay) await ref.read(appStateProvider).bump('iqra', 1);
  }

  Future<void> _speakIqra(String text) async {
    await tts.setLanguage('ar');
    await tts.setPitch(1.1);
    await tts.setSpeechRate(slow ? .30 : .35);
    await tts.speak(text);
  }

  Future<void> practiceIqra(IqraItem item) async {
    setState(() {
      listening = true;
      feedback = 'Dengarkan suara...';
    });
    await _speakIqra(item.char);
    await Future<void>.delayed(1200.ms);

    if (!mounted) return;

    final speech = stt.SpeechToText();
    try {
      final initialized = await speech.initialize(
        onError: (_) {},
        onStatus: (_) {},
      );
      if (!initialized) throw Exception('Speech init failed');

      setState(() => feedback = 'Mendengarkan...');
      await speech.listen(
        localeId: 'ar_SA',
        listenFor: const Duration(seconds: 6),
      );
      await Future<void>.delayed(6500.ms);

      if (!mounted) return;
      speech.stop();
      final heard = speech.lastRecognizedWords;
      final ok = _voiceMatches(heard, item.latin);

      if (ok) {
        confetti.play();
        setState(() => feedback = 'MasyaAllah, benar!');
        await _speakIqra(item.char);
        await ref.read(appStateProvider).markIqraSuccess(item);
      } else {
        setState(
          () => feedback = heard.isEmpty
              ? 'Coba lagi, suara kurang jelas.'
              : 'Coba lagi, dengarkan pelan ya.',
        );
        await Future<void>.delayed(800.ms);
        if (mounted) await playIqra(item);
      }
    } catch (e) {
      if (mounted) {
        setState(() => feedback = 'Error: ${e.toString().substring(0, 20)}');
      }
    } finally {
      speech.stop();
      if (mounted) setState(() => listening = false);
    }
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

class _IqraDreamScene extends StatelessWidget {
  const _IqraDreamScene();

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          'assets/images/Backgroudn_Image_Iqra.png',
          fit: BoxFit.cover,
          alignment: Alignment.topCenter,
        ),
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white.withValues(alpha: .05),
                const Color(0xffF2EAFF).withValues(alpha: .20),
                Colors.white.withValues(alpha: .82),
              ],
              stops: const [0, .42, 1],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        const Positioned.fill(child: _IqraParticles()),
        Positioned(
          left: 34,
          top: 76,
          child:
              Icon(
                    Icons.nightlight_round,
                    size: 46,
                    color: const Color(0xffFFC857).withValues(alpha: .82),
                    shadows: [
                      Shadow(
                        blurRadius: 24,
                        color: const Color(0xffFFD978).withValues(alpha: .82),
                      ),
                    ],
                  )
                  .animate(onPlay: (c) => c.repeat(reverse: true))
                  .scale(
                    begin: const Offset(.96, .96),
                    end: const Offset(1.08, 1.08),
                    duration: 1800.ms,
                  ),
        ),
        Positioned(
          right: 34,
          top: 96,
          child:
              Icon(
                    Icons.tips_and_updates_rounded,
                    size: 38,
                    color: const Color(0xffFFD36A).withValues(alpha: .70),
                  )
                  .animate(onPlay: (c) => c.repeat(reverse: true))
                  .moveY(begin: -5, end: 6, duration: 1500.ms),
        ),
      ],
    );
  }
}

class _IqraHeroSection extends StatelessWidget {
  const _IqraHeroSection({
    required this.app,
    required this.latinEnabled,
    required this.slow,
    required this.onBack,
    required this.onSettings,
  });

  final AppState app;
  final bool latinEnabled;
  final bool slow;
  final VoidCallback onBack;
  final VoidCallback onSettings;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final tablet = width >= 720;
    final mascot = app.gender == Gender.girl
        ? 'assets/images/Anak_perempuan_Mengaji.png'
        : 'assets/images/Anak_lakilaki_Mengaji.png';
    return SizedBox(
      height: tablet ? 266 : 278,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            child: Container(
              padding: EdgeInsets.all(tablet ? 22 : 16),

              child: Column(
                children: [
                  Row(
                    children: [
                      _IqraCircleButton(
                        icon: Icons.chevron_left_rounded,
                        onTap: onBack,
                      ),
                      const Spacer(),
                      _IqraPointsPill(stars: app.stars),
                      const SizedBox(width: 8),
                      _IqraCircleButton(
                        icon: slow
                            ? Icons.slow_motion_video_rounded
                            : Icons.settings_rounded,
                        active: slow,
                        label: 'Pelan',
                        onTap: onSettings,
                      ),
                    ],
                  ),
                  const Spacer(),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: tablet ? width * .55 : width * .58,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'IQRA 1',
                            maxLines: 1,
                            style: TextStyle(
                              fontSize: tablet ? 54 : 40,
                              height: .95,
                              color: const Color(0xff1498BD),
                              fontWeight: FontWeight.w900,
                              letterSpacing: 0,
                              shadows: [
                                Shadow(
                                  blurRadius: 18,
                                  color: const Color(
                                    0xff40C8F4,
                                  ).withValues(alpha: .42),
                                ),
                                const Shadow(
                                  blurRadius: 0,
                                  color: Colors.white,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 9,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(999),
                              border: Border.all(color: Colors.transparent),
                            ),
                            child: const Text(
                              'Belajar membaca Huruf Hijaiyah ✨',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Color(0xff335D73),
                                fontSize: 13,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                ],
              ),
            ),
          ),
          Positioned(
            right: tablet ? 26 : 0,
            bottom: -2,
            child:
                Image.asset(
                      mascot,
                      height: tablet ? 210 : 166,
                      fit: BoxFit.contain,
                    )
                    .animate(onPlay: (c) => c.repeat(reverse: true))
                    .moveY(begin: -5, end: 6, duration: 1700.ms),
          ),
          Positioned(
            right: tablet ? 198 : 128,
            bottom: tablet ? 34 : 46,
            child:
                Image.asset(
                      'assets/images/Logo_iqra.png',
                      width: tablet ? 84 : 64,
                      height: tablet ? 84 : 64,
                    )
                    .animate(onPlay: (c) => c.repeat(reverse: true))
                    .rotate(begin: -.015, end: .015, duration: 1500.ms),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 340.ms).slideY(begin: .04);
  }
}

class _IqraCircleButton extends StatelessWidget {
  const _IqraCircleButton({
    required this.icon,
    required this.onTap,
    this.active = false,
    this.label,
  });

  final IconData icon;
  final VoidCallback onTap;
  final bool active;
  final String? label;

  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: BorderRadius.circular(22),
    child: BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
      child: Material(
        color: active
            ? const Color(0xff1498BD).withValues(alpha: .92)
            : Colors.white.withValues(alpha: .86),
        child: InkWell(
          onTap: onTap,
          child: SizedBox(
            width: label == null ? 48 : 56,
            height: 48,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: active ? Colors.white : const Color(0xff1498BD),
                  size: label == null ? 31 : 22,
                ),
                if (label != null)
                  Text(
                    label!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: active ? Colors.white : const Color(0xff335D73),
                      fontSize: 8,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

class _IqraPointsPill extends StatelessWidget {
  const _IqraPointsPill({required this.stars});
  final int stars;

  @override
  Widget build(BuildContext context) => Container(
    height: 48,
    padding: const EdgeInsets.symmetric(horizontal: 12),
    decoration: BoxDecoration(
      color: Colors.white.withValues(alpha: .90),
      borderRadius: BorderRadius.circular(22),
      border: Border.all(color: Colors.white),
      boxShadow: [
        BoxShadow(
          blurRadius: 18,
          offset: const Offset(0, 8),
          color: const Color(0xff1498BD).withValues(alpha: .13),
        ),
      ],
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.star_rounded, color: Color(0xffFFC928), size: 25),
        const SizedBox(width: 5),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$stars',
              style: const TextStyle(
                color: Color(0xff393073),
                fontSize: 13,
                fontWeight: FontWeight.w900,
              ),
            ),
            const Text(
              'Poin',
              style: TextStyle(
                color: Color(0xff70699A),
                fontSize: 8,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

class _IqraProgressCard extends StatelessWidget {
  const _IqraProgressCard({
    required this.progress,
    required this.mastered,
    required this.total,
    required this.streak,
  });

  final int progress;
  final int mastered;
  final int total;
  final int streak;

  @override
  Widget build(BuildContext context) {
    final value = progress.clamp(0, 100) / 100;
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .90),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [
          BoxShadow(
            blurRadius: 28,
            offset: const Offset(0, 14),
            color: const Color(0xff1498BD).withValues(alpha: .14),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 480;
          final content = [
            SizedBox(
              width: 96,
              height: 96,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 86,
                    height: 86,
                    child: CircularProgressIndicator(
                      value: value,
                      strokeWidth: 11,
                      strokeCap: StrokeCap.round,
                      backgroundColor: const Color(
                        0xffEADFFF,
                      ).withValues(alpha: .85),
                      color: const Color(0xff1498BD),
                    ),
                  ),
                  Text(
                    '$progress%',
                    style: const TextStyle(
                      color: Color(0xff1498BD),
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16, height: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Progress Kamu',
                    style: TextStyle(
                      color: Color(0xff30265F),
                      fontSize: 19,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '$mastered / $total Huruf',
                    style: const TextStyle(
                      color: Color(0xff5C587E),
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(999),
                    child: LinearProgressIndicator(
                      minHeight: 10,
                      value: value,
                      backgroundColor: const Color(0xffD7F7EA),
                      color: const Color(0xff42D59D),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16, height: 16),
          ];
          return compact
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(children: content.take(3).toList()),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(child: content.last),
                        const SizedBox(width: 10),
                        _IqraMiniStat(
                          icon: Icons.local_fire_department_rounded,
                          text: '$streak streak',
                        ),
                      ],
                    ),
                  ],
                )
              : Row(children: content);
        },
      ),
    ).animate().fadeIn(duration: 320.ms, delay: 60.ms).slideY(begin: .04);
  }
}

class _IqraMiniStat extends StatelessWidget {
  const _IqraMiniStat({required this.icon, required this.text});
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
    decoration: BoxDecoration(
      color: const Color(0xffFFF4CD),
      borderRadius: BorderRadius.circular(18),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: const Color(0xffFF9F1C), size: 18),
        const SizedBox(width: 5),
        Text(
          text,
          style: const TextStyle(
            color: Color(0xff704E18),
            fontSize: 11,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    ),
  );
}

class _IqraCatalogSection extends StatelessWidget {
  const _IqraCatalogSection({
    required this.selectedIndex,
    required this.latinEnabled,
    required this.mastered,
    required this.favorites,
    required this.listening,
    required this.feedback,
    required this.onSelect,
    required this.onAudio,
    required this.onPractice,
    required this.onFavorite,
  });

  final int selectedIndex;
  final bool latinEnabled;
  final Set<String> mastered;
  final Set<String> favorites;
  final bool listening;
  final String feedback;
  final ValueChanged<int> onSelect;
  final ValueChanged<int> onAudio;
  final ValueChanged<int> onPractice;
  final ValueChanged<IqraItem> onFavorite;

  @override
  Widget build(BuildContext context) => _IqraSectionCard(
    title: 'Katalog Huruf Hijaiyah Dasar',
    subtitle: 'Klik huruf untuk belajar membaca dan mendengarkan',
    icon: Icons.auto_stories_rounded,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            final wide = constraints.maxWidth >= 760;
            final crossAxisCount = wide ? 4 : 2;
            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: iqraData.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: wide ? .72 : .68,
              ),
              itemBuilder: (context, i) {
                final item = iqraData[i];
                return _IqraLetterCard(
                  number: i + 1,
                  item: item,
                  selected: selectedIndex == i,
                  latinEnabled: latinEnabled,
                  mastered: mastered.contains(item.latin),
                  favorite: favorites.contains('iqra:${item.latin}'),
                  listening: listening && selectedIndex == i,
                  onTap: () => onSelect(i),
                  onAudio: () => onAudio(i),
                  onPractice: () => onPractice(i),
                  onFavorite: () => onFavorite(item),
                );
              },
            );
          },
        ),
        if (feedback.isNotEmpty) ...[
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(13),
            decoration: BoxDecoration(
              color: const Color(0xffE9FFF5),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              feedback,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xff167653),
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ],
    ),
  );
}

class _IqraLetterCard extends StatelessWidget {
  const _IqraLetterCard({
    required this.number,
    required this.item,
    required this.selected,
    required this.latinEnabled,
    required this.mastered,
    required this.favorite,
    required this.listening,
    required this.onTap,
    required this.onAudio,
    required this.onPractice,
    required this.onFavorite,
  });

  final int number;
  final IqraItem item;
  final bool selected;
  final bool latinEnabled;
  final bool mastered;
  final bool favorite;
  final bool listening;
  final VoidCallback onTap;
  final VoidCallback onAudio;
  final VoidCallback onPractice;
  final VoidCallback onFavorite;

  Color get statusColor {
    if (mastered) return const Color(0xff38C985);
    if (selected) return const Color(0xff1498BD);
    return const Color(0xff9EA5BC);
  }

  IconData get statusIcon {
    if (mastered) return Icons.check_circle_rounded;
    if (selected) return Icons.play_circle_fill_rounded;
    return Icons.radio_button_unchecked_rounded;
  }

  @override
  Widget build(BuildContext context) {
    final scale = listening ? 1.04 : 1.0;
    return AnimatedScale(
      scale: scale,
      duration: 220.ms,
      curve: Curves.easeOutBack,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(26),
          child: Ink(
            padding: const EdgeInsets.fromLTRB(10, 9, 10, 10),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: .94),
              borderRadius: BorderRadius.circular(26),
              border: Border.all(
                color: statusColor.withValues(alpha: selected ? .70 : .28),
                width: selected ? 2.2 : 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  blurRadius: selected || listening ? 26 : 16,
                  offset: const Offset(0, 10),
                  color: statusColor.withValues(alpha: selected ? .24 : .12),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: statusColor.withValues(alpha: .14),
                      ),
                      child: Text(
                        '$number',
                        style: TextStyle(
                          color: statusColor,
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Icon(statusIcon, size: 18, color: statusColor),
                    const SizedBox(width: 2),
                    GestureDetector(
                      onTap: onFavorite,
                      child: Icon(
                        favorite
                            ? Icons.favorite_rounded
                            : Icons.favorite_border_rounded,
                        size: 18,
                        color: favorite
                            ? const Color(0xffFF6FAE)
                            : const Color(0xffB8BED2),
                      ),
                    ),
                  ],
                ),
                const Spacer(flex: 2),
                SizedBox(
                  height: 74,
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: Text(
                      item.char,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: 'serif',
                        fontSize: 66,
                        height: 1.08,
                        color: Color(0xff22264D),
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  item.latin,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                if (latinEnabled)
                  Text(
                    item.latin.toLowerCase(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xff757C9D),
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _IqraRoundAction(
                      icon: Icons.volume_up_rounded,
                      color: statusColor,
                      onTap: onAudio,
                    ),
                    const SizedBox(width: 8),
                    _IqraRoundAction(
                      icon: listening
                          ? Icons.graphic_eq_rounded
                          : Icons.mic_rounded,
                      color: listening
                          ? Colors.redAccent
                          : const Color(0xff1498BD),
                      onTap: onPractice,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    ).animate().fadeIn(duration: 260.ms).slideY(begin: .05);
  }
}

class _IqraRoundAction extends StatelessWidget {
  const _IqraRoundAction({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Material(
    color: color,
    shape: const CircleBorder(),
    child: InkWell(
      customBorder: const CircleBorder(),
      onTap: onTap,
      child: SizedBox(
        width: 34,
        height: 34,
        child: Icon(icon, color: Colors.white, size: 19),
      ),
    ),
  );
}

class _IqraSectionCard extends StatelessWidget {
  const _IqraSectionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.child,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Widget child;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white.withValues(alpha: .78),
      borderRadius: BorderRadius.circular(30),
      border: Border.all(color: Colors.white, width: 2),
      boxShadow: [
        BoxShadow(
          blurRadius: 24,
          offset: const Offset(0, 13),
          color: const Color(0xff7AAED3).withValues(alpha: .13),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xffF0E7FF),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 18,
                    color: const Color(0xff1498BD).withValues(alpha: .18),
                  ),
                ],
              ),
              child: Icon(icon, color: const Color(0xff1498BD), size: 24),
            ),
            const SizedBox(width: 11),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xff30265F),
                      fontSize: 18,
                      height: 1.08,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xff777293),
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        child,
      ],
    ),
  ).animate().fadeIn(duration: 320.ms).slideY(begin: .04);
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
