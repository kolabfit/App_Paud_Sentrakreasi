part of '../main.dart';

// ═══════════════════════════════════════════════════════════════
//  BADGE COLLECTION PAGE
// ═══════════════════════════════════════════════════════════════

class BadgeCollectionScreen extends ConsumerStatefulWidget {
  const BadgeCollectionScreen({super.key});
  @override
  ConsumerState<BadgeCollectionScreen> createState() =>
      _BadgeCollectionScreenState();
}

class _BadgeCollectionScreenState extends ConsumerState<BadgeCollectionScreen> {
  final _confetti = ConfettiController(duration: const Duration(seconds: 3));
  List<String> _pendingUnlocks = [];
  bool _showingPopup = false;

  @override
  void initState() {
    super.initState();
    _checkNewBadges();
  }

  @override
  void dispose() {
    _confetti.dispose();
    super.dispose();
  }

  Future<void> _checkNewBadges() async {
    final app = ref.read(appStateProvider);
    if (app.email == null) return;
    final newIds = await BadgeService.instance.checkNewUnlocks(
      username: app.email!,
      progress: app.progress,
    );
    if (newIds.isNotEmpty && mounted) {
      setState(() => _pendingUnlocks = newIds);
      _showNextUnlock();
    }
  }

  void _showNextUnlock() {
    if (_pendingUnlocks.isEmpty || _showingPopup) return;
    final id = _pendingUnlocks.removeAt(0);
    final badge = BadgeService.instance.allBadges.firstWhere((b) => b.id == id);
    _showingPopup = true;
    _confetti.play();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => _BadgeUnlockPopup(
        badge: badge,
        confetti: _confetti,
        onDone: () {
          Navigator.of(context).pop();
          _showingPopup = false;
          if (_pendingUnlocks.isNotEmpty) {
            Future.delayed(400.ms, _showNextUnlock);
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final app = ref.watch(appStateProvider);
    final svc = BadgeService.instance;
    final badges = svc.allBadges;
    final tablet = MediaQuery.sizeOf(context).width >= 700;
    final cols = tablet ? 3 : 2;
    final unlocked = svc.unlockedCount(app.progress);

    return Scaffold(
      backgroundColor: const Color(0xffF4F0FF),
      body: Stack(
        children: [
          // Background decorations
          ..._bgDecorations(),
          SafeArea(
            child: Column(
              children: [
                // App bar
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 8, 18, 0),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 12,
                                color: const Color(
                                  0xff8B55F6,
                                ).withValues(alpha: .15),
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.arrow_back_rounded,
                            color: Color(0xff8B55F6),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Koleksi Badge 🏆',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w900,
                                color: Color(0xff2F2D72),
                              ),
                            ),
                            Text(
                              '$unlocked / ${badges.length} Badge Terbuka',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                                color: Color(0xff7A7E9B),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Overall badge counter
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xff8B55F6), Color(0xffFF7CBD)],
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.star_rounded,
                              color: Color(0xffFFD84D),
                              size: 20,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${app.stars}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                // Overall progress bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 22),
                  child: _OverallBadgeProgress(
                    unlocked: unlocked,
                    total: badges.length,
                  ),
                ),
                const SizedBox(height: 14),
                // Badge grid
                Expanded(
                  child: GridView.builder(
                    padding: EdgeInsets.fromLTRB(
                      tablet ? 24 : 14,
                      4,
                      tablet ? 24 : 14,
                      100,
                    ),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: cols,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: tablet ? 0.72 : 0.68,
                    ),
                    itemCount: badges.length,
                    itemBuilder: (_, i) => _BadgeCard(
                      badge: badges[i],
                      progress: app.progress,
                      index: i,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Confetti overlay
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confetti,
              blastDirectionality: BlastDirectionality.explosive,
              maxBlastForce: 30,
              minBlastForce: 10,
              numberOfParticles: 25,
              colors: const [
                Color(0xffFFD700),
                Color(0xff8B55F6),
                Color(0xffFF7CBD),
                Color(0xff42A5F5),
                Color(0xff66BB6A),
                Color(0xffFF9800),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _bgDecorations() => [
    Positioned(
      right: -40,
      top: -40,
      child: Container(
        width: 180,
        height: 180,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: const Color(0xff8B55F6).withValues(alpha: .08),
        ),
      ),
    ),
    Positioned(
      left: -30,
      bottom: 60,
      child: Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: const Color(0xffFF7CBD).withValues(alpha: .08),
        ),
      ),
    ),
  ];
}

// ═══════════════════════════════════════════════════════════════
//  OVERALL BADGE PROGRESS
// ═══════════════════════════════════════════════════════════════

class _OverallBadgeProgress extends StatelessWidget {
  const _OverallBadgeProgress({required this.unlocked, required this.total});
  final int unlocked;
  final int total;

  @override
  Widget build(BuildContext context) {
    final pct = total == 0 ? 0.0 : unlocked / total;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .92),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [
          BoxShadow(
            blurRadius: 16,
            offset: const Offset(0, 8),
            color: const Color(0xff8B55F6).withValues(alpha: .12),
          ),
        ],
      ),
      child: Row(
        children: [
          SizedBox(
            width: 48,
            height: 48,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                  value: pct,
                  strokeWidth: 5,
                  strokeCap: StrokeCap.round,
                  color: const Color(0xff8B55F6),
                  backgroundColor: const Color(0xffEBE7FF),
                ),
                Text(
                  '${(pct * 100).round()}%',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                    color: Color(0xff8B55F6),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Progress Koleksi Badge',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                    color: Color(0xff2F2D72),
                  ),
                ),
                const SizedBox(height: 4),
                ClipRRect(
                  borderRadius: BorderRadius.circular(99),
                  child: TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0, end: pct),
                    duration: 800.ms,
                    curve: Curves.easeOutCubic,
                    builder: (_, v, child) => LinearProgressIndicator(
                      value: v,
                      minHeight: 8,
                      backgroundColor: const Color(0xffEBE7FF),
                      color: const Color(0xff8B55F6),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Text(
            '$unlocked/$total',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w900,
              color: Color(0xff8B55F6),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms).slideY(begin: .05);
  }
}

// ═══════════════════════════════════════════════════════════════
//  BADGE CARD
// ═══════════════════════════════════════════════════════════════

class _BadgeCard extends StatelessWidget {
  const _BadgeCard({
    required this.badge,
    required this.progress,
    required this.index,
  });
  final BadgeData badge;
  final Map<String, int> progress;
  final int index;

  @override
  Widget build(BuildContext context) {
    final svc = BadgeService.instance;
    final unlocked = svc.isUnlocked(badge, progress);
    final cur = svc.currentProgress(badge, progress);
    final pct = cur / badge.requiredProgress;
    final rColor = rarityColor(badge.rarity);

    return Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: unlocked ? .96 : .80),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color: unlocked
                  ? badge.glowColor.withValues(alpha: .6)
                  : const Color(0xffE0E0E0),
              width: unlocked ? 2.5 : 1.5,
            ),
            boxShadow: [
              if (unlocked)
                BoxShadow(
                  blurRadius: 24,
                  offset: const Offset(0, 10),
                  color: badge.glowColor.withValues(alpha: .25),
                )
              else
                BoxShadow(
                  blurRadius: 14,
                  offset: const Offset(0, 6),
                  color: Colors.black.withValues(alpha: .06),
                ),
            ],
          ),
          child: Stack(
            children: [
              // Glow effect for unlocked
              if (unlocked)
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(28),
                      gradient: RadialGradient(
                        colors: [
                          badge.glowColor.withValues(alpha: .10),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
              // Card content
              Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  children: [
                    // Rarity label
                    Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: rColor.withValues(alpha: .14),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          rarityLabel(badge.rarity),
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w900,
                            color: rColor,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Badge image
                    Expanded(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          if (unlocked)
                            // Sparkle decorations
                            ...List.generate(6, (i) {
                              final a = (2 * pi * i / 6) - pi / 2;
                              final r = 42.0;
                              return Positioned(
                                left: 50 + cos(a) * r - 4,
                                top: 40 + sin(a) * r - 4,
                                child:
                                    Icon(
                                          Icons.auto_awesome_rounded,
                                          size: 8,
                                          color: badge.glowColor.withValues(
                                            alpha: .6,
                                          ),
                                        )
                                        .animate(
                                          onPlay: (c) =>
                                              c.repeat(reverse: true),
                                        )
                                        .scale(
                                          begin: const Offset(.6, .6),
                                          end: const Offset(1.2, 1.2),
                                          duration: (800 + i * 120).ms,
                                        ),
                              );
                            }),
                          // The badge image
                          Image.asset(
                            unlocked ? badge.assetUnlocked : badge.assetLocked,
                            width: 90,
                            height: 90,
                            fit: BoxFit.contain,
                          ),
                          // Lock icon overlay
                          if (!unlocked)
                            Positioned(
                              right: 20,
                              bottom: 2,
                              child: Container(
                                width: 26,
                                height: 26,
                                decoration: BoxDecoration(
                                  color: const Color(
                                    0xff7A7E9B,
                                  ).withValues(alpha: .85),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                ),
                                child: const Icon(
                                  Icons.lock_rounded,
                                  color: Colors.white,
                                  size: 13,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 6),
                    // Title
                    Text(
                      badge.title,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                        color: unlocked
                            ? const Color(0xff2F2D72)
                            : const Color(0xff9E9E9E),
                      ),
                    ),
                    const SizedBox(height: 2),
                    // Description
                    Text(
                      badge.description,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        color: unlocked
                            ? const Color(0xff7A7E9B)
                            : const Color(0xffBDBDBD),
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Progress bar
                    ClipRRect(
                      borderRadius: BorderRadius.circular(99),
                      child: TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0, end: pct.clamp(0, 1).toDouble()),
                        duration: 700.ms,
                        curve: Curves.easeOutCubic,
                        builder: (_, v, child) => LinearProgressIndicator(
                          value: v,
                          minHeight: 6,
                          backgroundColor: unlocked
                              ? badge.glowColor.withValues(alpha: .15)
                              : const Color(0xffE0E0E0),
                          color: unlocked
                              ? badge.glowColor
                              : const Color(0xffBDBDBD),
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      unlocked
                          ? '✅ Terbuka!'
                          : '$cur / ${badge.requiredProgress}%',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: unlocked
                            ? const Color(0xff4CAF50)
                            : const Color(0xff9E9E9E),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
        .animate(delay: (index * 80).ms)
        .fadeIn(duration: 320.ms)
        .slideY(begin: .08);
  }
}

// ═══════════════════════════════════════════════════════════════
//  BADGE UNLOCK POPUP
// ═══════════════════════════════════════════════════════════════

class _BadgeUnlockPopup extends StatelessWidget {
  const _BadgeUnlockPopup({
    required this.badge,
    required this.confetti,
    required this.onDone,
  });
  final BadgeData badge;
  final ConfettiController confetti;
  final VoidCallback onDone;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(24),
      child:
          Container(
                constraints: const BoxConstraints(maxWidth: 380),
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(36),
                  border: Border.all(
                    color: badge.glowColor.withValues(alpha: .4),
                    width: 3,
                  ),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 40,
                      offset: const Offset(0, 20),
                      color: badge.glowColor.withValues(alpha: .30),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Sparkle stars row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        5,
                        (i) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child:
                              Icon(
                                    Icons.star_rounded,
                                    size: i == 2 ? 28 : 18,
                                    color: const Color(0xffFFD700),
                                  )
                                  .animate(
                                    onPlay: (c) => c.repeat(reverse: true),
                                  )
                                  .scale(
                                    begin: const Offset(.7, .7),
                                    end: const Offset(1.2, 1.2),
                                    duration: (700 + i * 100).ms,
                                  ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      '🎉 Yeay! 🎉',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        color: Color(0xff2F2D72),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Kamu mendapatkan Badge baru!',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: Color(0xff7A7E9B),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Badge image with glow
                    Container(
                      width: 140,
                      height: 140,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 40,
                            color: badge.glowColor.withValues(alpha: .35),
                          ),
                        ],
                      ),
                      child: Image.asset(
                        badge.assetUnlocked,
                        fit: BoxFit.contain,
                      ),
                    ).animate().scale(
                      begin: const Offset(.3, .3),
                      duration: 600.ms,
                      curve: Curves.elasticOut,
                    ),
                    const SizedBox(height: 16),
                    // Badge title
                    Text(
                      badge.title,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: Color(0xff2F2D72),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: rarityColor(badge.rarity).withValues(alpha: .12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        rarityLabel(badge.rarity),
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w900,
                          color: rarityColor(badge.rarity),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      badge.description,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Color(0xff7A7E9B),
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Collect button
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: FilledButton(
                        onPressed: onDone,
                        style: FilledButton.styleFrom(
                          backgroundColor: badge.glowColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                          textStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        child: const Text('Keren! Ambil Badge! 🌟'),
                      ),
                    ),
                  ],
                ),
              )
              .animate()
              .fadeIn(duration: 300.ms)
              .scale(
                begin: const Offset(.8, .8),
                duration: 400.ms,
                curve: Curves.easeOutBack,
              ),
    );
  }
}
