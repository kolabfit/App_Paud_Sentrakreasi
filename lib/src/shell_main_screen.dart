part of '../main.dart';

class ShellScreen extends ConsumerWidget {
  const ShellScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final app = ref.watch(appStateProvider);
    final t = app.theme;
    final teacherHome = app.role == Role.teacher;
    Widget body;
    if (teacherHome && app.tab == TabItem.akun) {
      body = const TeacherDashboard();
    } else {
      body = switch (app.tab) {
        TabItem.main => const MainMenuScreen(),
        TabItem.belajar => const BelajarScreen(),
        TabItem.lagu => const SongsScreen(),
        TabItem.akun => const AccountScreen(),
      };
    }
    return Scaffold(
      extendBody: true,
      body: ThemedBackground(
        child: SafeArea(
          child: AnimatedSwitcher(
            duration: 220.ms,
            transitionBuilder: (child, anim) => FadeTransition(
              opacity: anim,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0.03, 0),
                  end: Offset.zero,
                ).animate(anim),
                child: child,
              ),
            ),
            child: KeyedSubtree(
              key: ValueKey('${app.tab}-${app.learnMode}-${app.themeId}'),
              child: body,
            ),
          ),
        ),
      ),
      bottomNavigationBar: _FancyBottomNav(app: app, t: t),
    );
  }
}

class _FancyBottomNav extends ConsumerWidget {
  const _FancyBottomNav({required this.app, required this.t});
  final AppState app;
  final AppThemeData t;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIdx = TabItem.values.indexOf(app.tab);
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      decoration: BoxDecoration(
        color: t.widgetBg.withValues(alpha: .96),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(
          color: t.widgetBorder.withValues(alpha: .22),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            blurRadius: 30,
            offset: const Offset(0, 12),
            color: Colors.black.withValues(alpha: t.dark ? .35 : .10),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(4, (i) {
            final isActive = selectedIdx == i;
            final icons = [
              Icons.grid_view_rounded,
              Icons.menu_book_rounded,
              Icons.music_note_rounded,
              Icons.person_rounded,
            ];
            final labels = ['Main', 'Belajar', 'Lagu', 'Akun'];
            return _NavItem(
              icon: icons[i],
              label: labels[i],
              isActive: isActive,
              theme: t,
              onTap: () => ref.read(appStateProvider).go(TabItem.values[i]),
            );
          }),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.theme,
    required this.onTap,
  });
  final IconData icon;
  final String label;
  final bool isActive;
  final AppThemeData theme;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final activeColor = theme.dark ? theme.accent : theme.primary;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOutCubic,
        padding: EdgeInsets.symmetric(
          horizontal: isActive ? 18 : 14,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: isActive ? activeColor.withValues(alpha: .14) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedScale(
              scale: isActive ? 1.15 : 1.0,
              duration: const Duration(milliseconds: 240),
              child: Icon(
                icon,
                size: 26,
                color: isActive
                    ? activeColor
                    : (theme.dark ? Colors.white38 : Colors.grey.shade400),
              ),
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 200),
              child: isActive
                  ? Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        label.toUpperCase(),
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.5,
                          color: activeColor,
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  MAIN MENU SCREEN – vibrant child-friendly home
// ═══════════════════════════════════════════════════════════════

class MainMenuScreen extends ConsumerWidget {
  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final app = ref.watch(appStateProvider);
    final t = app.theme;
    return PagePad(
      child: ListView(
        children: [
          // ─── Hero welcome banner ──────────────
          _WelcomeBanner(name: app.childName, theme: t),
          const SizedBox(height: 20),

          // ─── Section: Pusat Belajar ──────────────
          _SectionLabel(
            label: 'PUSAT BELAJAR',
            icon: Icons.auto_stories_rounded,
            color: t.dark ? const Color(0xffA29BFE) : t.primary,
          ),
          const SizedBox(height: 12),
          _LearningGrid(ref: ref, theme: t),
          const SizedBox(height: 20),

          // ─── Section: Lagu Anak ──────────────
          _SongBanner(
            theme: t,
            onTap: () => ref.read(appStateProvider).go(TabItem.lagu),
          ),
          const SizedBox(height: 20),

          // ─── Progress Overview ──────────────
          _SectionLabel(
            label: 'PROGRESS BELAJAR',
            icon: Icons.trending_up_rounded,
            color: t.dark ? Colors.tealAccent : const Color(0xff27AE60),
          ),
          const SizedBox(height: 12),
          ProgressOverview(progress: app.progress, compact: false),
          const SizedBox(height: 110),
        ],
      ),
    );
  }
}

class _WelcomeBanner extends StatelessWidget {
  const _WelcomeBanner({required this.name, required this.theme});
  final String name;
  final AppThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 160),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(34),
        color: theme.widgetBg,
        border: Border.all(color: theme.widgetBorder, width: 2),
        image: DecorationImage(
          image: AssetImage(theme.asset),
          fit: BoxFit.cover,
          opacity: theme.dark ? .12 : .18,
        ),
        boxShadow: [
          BoxShadow(
            blurRadius: 20,
            offset: const Offset(0, 10),
            color: theme.widgetBorder.withValues(alpha: .18),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Halo, $name! 👋',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                    color: theme.dark ? Colors.white : const Color(0xff263238),
                    letterSpacing: -.5,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Ayo, petualangan belajar dimulai!',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: theme.dark ? Colors.white54 : Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              color: theme.widgetBorder.withValues(alpha: .12),
              border: Border.all(
                color: theme.widgetBorder.withValues(alpha: .3),
                width: 2,
              ),
            ),
            child: Image.asset('assets/images/Anak_hebat.png', fit: BoxFit.contain),
          )
              .animate(onPlay: (c) => c.repeat(reverse: true))
              .moveY(begin: -6, end: 6, duration: 2000.ms),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms).slideY(begin: .06);
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.label, required this.icon, required this.color});
  final String label;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: .12),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, size: 20, color: color),
        ),
        const SizedBox(width: 10),
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w900,
            letterSpacing: 3,
            color: color,
          ),
        ),
      ],
    );
  }
}

class _LearningGrid extends StatelessWidget {
  const _LearningGrid({required this.ref, required this.theme});
  final WidgetRef ref;
  final AppThemeData theme;

  @override
  Widget build(BuildContext context) {
    final items = [
      _LItem('Huruf', 'A sampai Z', 'assets/images/Logo_Membaca.png', const Color(0xffE74C3C), const Color(0xffFDE8E8), LearnMode.huruf),
      _LItem('Angka', '1 sampai 10', 'assets/images/Logo_123.png', const Color(0xff3498DB), const Color(0xffE8F4FD), LearnMode.angka),
      _LItem('Benda', 'Mengenal benda', 'assets/images/Logo_Benda.png', const Color(0xff27AE60), const Color(0xffE8F8EE), LearnMode.benda),
      _LItem('Iqra 1', 'Hijaiyah dasar', 'assets/images/Logo_iqra.png', const Color(0xff9B59B6), const Color(0xffF3E8FD), LearnMode.iqra),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: MediaQuery.sizeOf(context).width > 600 ? 4 : 2,
        mainAxisSpacing: 14,
        crossAxisSpacing: 14,
        childAspectRatio: .88,
      ),
      itemCount: items.length,
      itemBuilder: (_, i) {
        final item = items[i];
        return _LearningTile(
          item: item,
          theme: theme,
          delay: i * 80,
          onTap: () => ref.read(appStateProvider).openLearn(item.mode),
        );
      },
    );
  }
}

class _LItem {
  const _LItem(this.title, this.subtitle, this.asset, this.color, this.lightColor, this.mode);
  final String title;
  final String subtitle;
  final String asset;
  final Color color;
  final Color lightColor;
  final LearnMode mode;
}

class _LearningTile extends StatelessWidget {
  const _LearningTile({
    required this.item,
    required this.theme,
    required this.onTap,
    required this.delay,
  });
  final _LItem item;
  final AppThemeData theme;
  final VoidCallback onTap;
  final int delay;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.widgetBg,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: item.color.withValues(alpha: .25), width: 2),
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, 6),
              blurRadius: 0,
              color: item.color.withValues(alpha: .15),
            ),
            BoxShadow(
              blurRadius: 16,
              offset: const Offset(0, 8),
              color: Colors.black.withValues(alpha: theme.dark ? .15 : .04),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.dark
                      ? item.color.withValues(alpha: .15)
                      : item.lightColor,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: item.color.withValues(alpha: .2),
                    width: 1.5,
                  ),
                ),
                child: Image.asset(item.asset, fit: BoxFit.contain),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              item.title.toUpperCase(),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w900,
                letterSpacing: 2,
                color: theme.dark ? Colors.white : Colors.grey.shade800,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              item.subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: theme.dark ? Colors.white38 : Colors.grey.shade500,
              ),
            ),
          ],
        ),
      ).animate().fadeIn(
        duration: 350.ms,
        delay: Duration(milliseconds: delay),
      ).slideY(begin: .12, delay: Duration(milliseconds: delay)),
    );
  }
}

class _SongBanner extends StatelessWidget {
  const _SongBanner({required this.theme, required this.onTap});
  final AppThemeData theme;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final songColor = theme.dark ? const Color(0xffF1C40F) : const Color(0xffE91E63);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        decoration: BoxDecoration(
          color: theme.widgetBg,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: songColor.withValues(alpha: .25), width: 2),
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, 8),
              blurRadius: 0,
              color: songColor.withValues(alpha: .12),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'LAGU ANAK',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 3,
                      color: songColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Bernyanyi bersama koleksi lagu populer!',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: theme.dark ? Colors.white38 : Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: songColor.withValues(alpha: .12),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: songColor.withValues(alpha: .25), width: 2),
              ),
              child: Image.asset('assets/images/Logo_Lagu.png', fit: BoxFit.contain),
            ),
          ],
        ),
      ).animate().fadeIn(duration: 350.ms, delay: 250.ms).slideY(begin: .1, delay: 250.ms),
    );
  }
}
