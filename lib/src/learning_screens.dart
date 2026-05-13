part of '../main.dart';

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
    return PagePad(child: modeBody(app));
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
    final t = ref.watch(appStateProvider).theme;
    final cross = MediaQuery.sizeOf(context).width >= 760 ? 4 : 2;
    return Column(
      children: [
        Text(
          'Pusat Petualangan',
          textAlign: TextAlign.center,
          style: sectionTitle(context).copyWith(
            fontSize: MediaQuery.sizeOf(context).width >= 760 ? 48 : 36,
            color: t.dark
                ? t.secondary
                : Theme.of(context).colorScheme.secondary,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          width: 128,
          height: 8,
          decoration: BoxDecoration(
            color: t.secondary.withValues(alpha: .25),
            borderRadius: BorderRadius.circular(999),
          ),
        ),
        const SizedBox(height: 28),
        Expanded(
          child: GridView.count(
            crossAxisCount: cross,
            mainAxisSpacing: 20,
            crossAxisSpacing: 20,
            children: [
              MenuButton(
                img: 'assets/images/Logo_Membaca.png',
                label: 'Membaca',
                color: Colors.redAccent,
                onTap: () =>
                    ref.read(appStateProvider).openLearn(LearnMode.huruf),
              ),
              MenuButton(
                img: 'assets/images/Logo_123.png',
                label: 'Angka',
                color: Colors.blueAccent,
                onTap: () =>
                    ref.read(appStateProvider).openLearn(LearnMode.angka),
              ),
              MenuButton(
                img: 'assets/images/Logo_Benda.png',
                label: 'Benda',
                color: Colors.green,
                onTap: () =>
                    ref.read(appStateProvider).openLearn(LearnMode.benda),
              ),
              MenuButton(
                img: 'assets/images/Logo_iqra.png',
                label: 'Iqra',
                color: Colors.purple,
                onTap: () =>
                    ref.read(appStateProvider).openLearn(LearnMode.iqra),
              ),
            ],
          ),
        ),
        OutlinedButton(
          onPressed: () => ref.read(appStateProvider).go(TabItem.main),
          child: const Text('Kembali ke Menu Utama'),
        ),
        const SizedBox(height: 110),
      ],
    );
  }
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
            await tts.speak('${data.letter}. ${obj.name}');
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
            await tts.speak(current.name);
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
            await tts.speak(current.name);
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
  bool seru = false;

  @override
  Widget build(BuildContext context) {
    if (seru) {
      return ModeSeruScreen(
        category: 'iqra',
        title: 'Kuis Arab Seru',
        onClose: () => setState(() => seru = false),
      );
    }
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
                style: sectionTitle(context).copyWith(color: Colors.purple),
              ),
            ),
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
        Expanded(
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: MediaQuery.sizeOf(context).width > 700 ? 5 : 3,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
            ),
            itemCount: iqraData.length,
            itemBuilder: (_, i) {
              final item = iqraData[i];
              return InkWell(
                borderRadius: BorderRadius.circular(28),
                onTap: () async {
                  await tts.speak(item.latin);
                  await ref.read(appStateProvider).bump('iqra', 3);
                },
                child: Container(
                  decoration: cardDecoration(context),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        item.char,
                        style: const TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.w900,
                          fontFamily: 'serif',
                        ),
                      ),
                      if (widget.readingHelp)
                        Text(
                          item.latin,
                          style: const TextStyle(fontWeight: FontWeight.w800),
                        ),
                      const SizedBox(height: 6),
                      const Icon(Icons.volume_up, size: 20),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
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
    await tts.speak(challenge.prompt);
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
      await tts.speak('Pintar sekali');
      await ref.read(appStateProvider).bump(challenge.category, 8);
    } else {
      setState(() => feedback = 'Hampir benar, ayo coba lagi!');
      await tts.speak('Ayo coba lagi');
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
