part of '../main.dart';

class AccountScreen extends ConsumerWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final app = ref.watch(appStateProvider);
    final t = app.theme;
    return PagePad(
      child: ListView(
        children: [
          // Profile card
          Container(
            padding: const EdgeInsets.all(24),
            decoration: tactileCard(context, radius: 34),
            child: Row(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [t.primary, t.accent],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(26),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                        color: t.primary.withValues(alpha: .25),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      app.childName.isNotEmpty
                          ? app.childName[0].toUpperCase()
                          : '?',
                      style: const TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 18),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        app.childName,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          color: t.dark
                              ? Colors.white
                              : const Color(0xff263238),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        app.email == null ? '' : '@${app.email}',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: muted(context),
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: app.role == Role.teacher
                              ? Colors.deepPurple.withValues(alpha: .12)
                              : Colors.green.withValues(alpha: .12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          app.role == Role.teacher
                              ? '👩‍🏫 Pengajar'
                              : '👶 Anak',
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 11,
                            color: app.role == Role.teacher
                                ? Colors.deepPurple
                                : Colors.green.shade700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Rewards
          RewardPill(stars: app.stars),
          const SizedBox(height: 16),

          // Progress
          ProgressOverview(progress: app.progress, compact: false),
          const SizedBox(height: 20),

          // Theme selector
          Container(
            padding: const EdgeInsets.all(20),
            decoration: tactileCard(context, radius: 26),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.purple.withValues(alpha: .12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.palette_rounded,
                        size: 20,
                        color: Colors.purple,
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'TEMA APLIKASI',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 3,
                        color: Colors.purple,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                ThemeWheel(app: app),
              ],
            ),
          ),
          const SizedBox(height: 18),

          if (app.role == Role.teacher)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: FilledButton.icon(
                onPressed: () => ref.read(appStateProvider).go(TabItem.akun),
                icon: const Icon(Icons.dashboard_rounded),
                label: const Text('Dashboard Pengajar'),
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(54),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
          OutlinedButton.icon(
            onPressed: () => ref.read(appStateProvider).logout(),
            icon: const Icon(Icons.logout_rounded),
            label: const Text('Keluar'),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(54),
              foregroundColor: Colors.redAccent,
              side: const BorderSide(color: Colors.redAccent),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          const SizedBox(height: 110),
        ],
      ),
    );
  }
}

class ThemeWheel extends ConsumerWidget {
  const ThemeWheel({required this.app, super.key});
  final AppState app;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = max(
      0,
      appThemes.indexWhere((e) => e.id == app.themeId),
    );
    final selected = appThemes[selectedIndex];
    final wide = MediaQuery.sizeOf(context).width > 520;
    final radius = wide ? 142.0 : 116.0;
    final size = radius * 2 + 86;

    return Column(
      children: [
        SizedBox(
          height: size,
          child: Center(
            child: TweenAnimationBuilder<double>(
              tween: Tween(
                begin: 0,
                end: -selectedIndex * 2 * pi / appThemes.length,
              ),
              duration: 520.ms,
              curve: Curves.easeOutBack,
              builder: (context, spin, child) {
                return SizedBox(
                  width: size,
                  height: size,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: radius * 2.02,
                        height: radius * 2.02,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: .78),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 28,
                              offset: const Offset(0, 14),
                              color: selected.primary.withValues(alpha: .22),
                            ),
                          ],
                        ),
                      ),
                      Transform.rotate(
                        angle: spin,
                        child: Container(
                          width: radius * 1.86,
                          height: radius * 1.86,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: SweepGradient(
                              colors: appThemes.map((e) => e.primary).toList(),
                            ),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: .85),
                              width: 8,
                            ),
                          ),
                        ),
                      ),
                      ...List.generate(18, (i) {
                        final a = (2 * pi * i / 18) - pi / 2;
                        return Transform.translate(
                          offset: Offset(
                            cos(a) * radius * .68,
                            sin(a) * radius * .68,
                          ),
                          child: Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: const Color(0xfffff1a8),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 8,
                                  color: Colors.amber.withValues(alpha: .55),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                      ...List.generate(appThemes.length, (i) {
                        final theme = appThemes[i];
                        final angle =
                            (2 * pi * i / appThemes.length) - pi / 2 + spin;
                        final picked = theme.id == app.themeId;
                        return Transform.translate(
                          offset: Offset(
                            cos(angle) * radius,
                            sin(angle) * radius,
                          ),
                          child: _WheelThemeBadge(
                            theme: theme,
                            picked: picked,
                            onTap: () {
                              Feedback.forTap(context);
                              ref.read(appStateProvider).setTheme(theme.id);
                            },
                          ),
                        );
                      }),
                      Container(
                        width: radius * .98,
                        height: radius * .98,
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: selected.dark
                              ? const Color(0xff212433)
                              : Colors.white.withValues(alpha: .94),
                          border: Border.all(
                            color: selected.accent.withValues(alpha: .9),
                            width: 5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 26,
                              color: selected.primary.withValues(alpha: .28),
                            ),
                            BoxShadow(
                              blurRadius: 0,
                              spreadRadius: 8,
                              color: selected.primary.withValues(alpha: .09),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Image.asset(
                                selected.asset,
                                fit: BoxFit.contain,
                              ),
                            ),
                            Text(
                              selected.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w900,
                                color: selected.dark
                                    ? Colors.white
                                    : const Color(0xff42309a),
                              ),
                            ),
                            Text(
                              'Pratinjau aktif',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                color: selected.dark
                                    ? Colors.white60
                                    : const Color(0xff6c59ba),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        bottom: 28,
                        child: Container(
                          width: 54,
                          height: 54,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [selected.primary, selected.accent],
                            ),
                            border: Border.all(color: Colors.white, width: 4),
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 16,
                                color: selected.primary.withValues(alpha: .35),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.check_rounded,
                            color: Colors.white,
                            size: 32,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class _WheelThemeBadge extends StatelessWidget {
  const _WheelThemeBadge({
    required this.theme,
    required this.picked,
    required this.onTap,
  });
  final AppThemeData theme;
  final bool picked;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedScale(
        duration: 220.ms,
        scale: picked ? 1.12 : 1,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: picked ? 82 : 70,
              height: picked ? 82 : 70,
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(
                  color: picked ? theme.accent : theme.primary,
                  width: picked ? 5 : 3,
                ),
                boxShadow: [
                  BoxShadow(
                    blurRadius: picked ? 22 : 10,
                    offset: const Offset(0, 8),
                    color: theme.primary.withValues(alpha: picked ? .42 : .22),
                  ),
                ],
              ),
              child: ClipOval(
                child: Image.asset(theme.asset, fit: BoxFit.cover),
              ),
            ),
            Transform.translate(
              offset: const Offset(0, -8),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 11,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(
                    color: theme.primary.withValues(alpha: .55),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 8,
                      color: theme.primary.withValues(alpha: .18),
                    ),
                  ],
                ),
                child: Text(
                  theme.name,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                    color: theme.primary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ignore: unused_element
class _ThemeCardStrip extends ConsumerWidget {
  const _ThemeCardStrip({required this.app});
  final AppState app;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .72),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white.withValues(alpha: .8), width: 2),
        boxShadow: softShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: const Color(0xff6c5ce7).withValues(alpha: .14),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.palette_rounded,
                  color: Color(0xff6c5ce7),
                  size: 20,
                ),
              ),
              const SizedBox(width: 10),
              const Text(
                'Pilih Tema',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: Color(0xff42309a),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 142,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: appThemes.length,
              separatorBuilder: (context, index) => const SizedBox(width: 12),
              itemBuilder: (_, i) {
                final theme = appThemes[i];
                final picked = app.themeId == theme.id;
                return GestureDetector(
                  onTap: () {
                    Feedback.forTap(context);
                    ref.read(appStateProvider).setTheme(theme.id);
                  },
                  child: AnimatedContainer(
                    duration: 220.ms,
                    width: 104,
                    padding: const EdgeInsets.all(9),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: picked ? 1 : .82),
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(
                        color: picked ? theme.primary : Colors.white,
                        width: picked ? 3 : 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: picked ? 18 : 8,
                          offset: const Offset(0, 8),
                          color: theme.primary.withValues(
                            alpha: picked ? .3 : .08,
                          ),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Container(
                              width: double.infinity,
                              color: theme.primary.withValues(alpha: .12),
                              child: Image.asset(
                                theme.asset,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 7),
                        Text(
                          theme.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w900,
                            color: picked
                                ? theme.primary
                                : const Color(0xff172554),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Icon(
                          picked
                              ? Icons.check_circle_rounded
                              : Icons.circle_outlined,
                          size: 20,
                          color: picked ? theme.primary : Colors.grey.shade400,
                        ),
                      ],
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
