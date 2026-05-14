part of '../main.dart';

class ShellScreen extends ConsumerWidget {
  const ShellScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final app = ref.watch(appStateProvider);
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
      backgroundColor: const Color(0xffF7FBFF),
      extendBody: false,
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
      bottomNavigationBar: _FancyBottomNav(app: app),
    );
  }
}

class _FancyBottomNav extends ConsumerWidget {
  const _FancyBottomNav({required this.app});
  final AppState app;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIdx = TabItem.values.indexOf(app.tab);
    return Container(
      margin: const EdgeInsets.fromLTRB(18, 0, 18, 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(34),
        border: Border.all(color: const Color(0xffEEF2FF)),
        boxShadow: [
          BoxShadow(
            blurRadius: 28,
            offset: const Offset(0, 14),
            color: const Color(0xff5D6B9A).withValues(alpha: .16),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Row(
          children: List.generate(4, (i) {
            final icons = [
              Icons.home_rounded,
              Icons.menu_book_rounded,
              Icons.music_note_rounded,
              Icons.person_rounded,
            ];
            final labels = ['Main', 'Belajar', 'Lagu Anak', 'Akun'];
            return Expanded(
              child: _NavItem(
                icon: icons[i],
                label: labels[i],
                isActive: selectedIdx == i,
                onTap: () => ref.read(appStateProvider).go(TabItem.values[i]),
              ),
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
    required this.onTap,
  });
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    const activeColor = Color(0xff1498BD);
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 260),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 9),
        decoration: BoxDecoration(
          gradient: isActive
              ? LinearGradient(
                  colors: [
                    activeColor.withValues(alpha: .18),
                    const Color(0xff68E2C2).withValues(alpha: .14),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          borderRadius: BorderRadius.circular(24),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    blurRadius: 18,
                    color: activeColor.withValues(alpha: .22),
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedScale(
              scale: isActive ? 1.14 : 1,
              duration: const Duration(milliseconds: 220),
              child: Container(
                width: 34,
                height: 30,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isActive
                      ? Colors.white.withValues(alpha: .86)
                      : Colors.transparent,
                ),
                child: Icon(
                  icon,
                  size: 24,
                  color: isActive ? activeColor : const Color(0xff6F7495),
                ),
              ),
            ),
            const SizedBox(height: 3),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w900,
                color: isActive ? activeColor : const Color(0xff59607F),
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              margin: const EdgeInsets.only(top: 4),
              width: isActive ? 18 : 4,
              height: 4,
              decoration: BoxDecoration(
                color: isActive ? activeColor : Colors.transparent,
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MainMenuScreen extends ConsumerWidget {
  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final app = ref.watch(appStateProvider);
    final tablet = MediaQuery.sizeOf(context).width >= 700;
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: tablet ? 980 : 520),
        child: ListView(
          padding: EdgeInsets.fromLTRB(
            tablet ? 28 : 18,
            14,
            tablet ? 28 : 18,
            126,
          ),
          children: [
            _HomeHero(
              app: app,
              onTap: () => ref.read(appStateProvider).go(TabItem.belajar),
            ),
            const SizedBox(height: 18),
            _LearningGrid(
              onOpen: (mode) => ref.read(appStateProvider).openLearn(mode),
            ),
            const SizedBox(height: 18),
            if (tablet)
              Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 6,
                        child: _HomeProgressPanel(progress: app.progress),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        flex: 5,
                        child: _ModeFunCard(
                          onTap: () =>
                              ref.read(appStateProvider).go(TabItem.belajar),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  SizedBox(
                    height: 172,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: _SongHomeCard(
                            onTap: () =>
                                ref.read(appStateProvider).go(TabItem.lagu),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _BadgeHomeCard(
                            onTap: () =>
                                ref.read(appStateProvider).go(TabItem.akun),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            else ...[
              _HomeProgressPanel(progress: app.progress),
              const SizedBox(height: 18),
              _ModeFunCard(
                onTap: () => ref.read(appStateProvider).go(TabItem.belajar),
              ),
              const SizedBox(height: 18),
              _SongHomeCard(
                onTap: () => ref.read(appStateProvider).go(TabItem.lagu),
              ),
              const SizedBox(height: 18),
              _BadgeHomeCard(
                onTap: () => ref.read(appStateProvider).go(TabItem.akun),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _HomeHero extends StatelessWidget {
  const _HomeHero({required this.app, required this.onTap});
  final AppState app;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tablet = MediaQuery.sizeOf(context).width >= 700;
    final name = app.childName.trim().isEmpty || app.childName == 'Teman'
        ? 'Google User'
        : app.childName.trim();
    final avatar = app.gender == Gender.girl
        ? 'assets/images/profil_perempuan.png'
        : 'assets/images/profil_lakilaki.png';
    final mascot = app.gender == Gender.girl
        ? 'assets/images/Anak_Perempuan_Menu.png'
        : 'assets/images/Anak_LakiLaki_Menu.png';
    return SizedBox(
      height: tablet ? 260 : 238,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(34),
              child: Stack(fit: StackFit.expand),
            ),
          ),
          Positioned(
            left: 16,
            top: 16,
            right: 16,
            child: Row(
              children: [
                _AvatarBubble(asset: avatar),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              'Halo, $name!',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: tablet ? 28 : 21,
                                height: 1.04,
                                fontWeight: FontWeight.w900,
                                color: Color(0xff3A268A),
                                shadows: const [
                                  Shadow(
                                    blurRadius: 8,
                                    color: Colors.white,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(
                            Icons.waving_hand_rounded,
                            color: Color(0xffFFBE45),
                            size: 20,
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Ayo, petualangan belajar dimulai!',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Color(0xff595A78),
                          fontSize: tablet ? 15 : 12,
                          fontWeight: FontWeight.w800,
                          shadows: const [
                            Shadow(
                              blurRadius: 7,
                              color: Colors.white,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                _PointPill(stars: app.stars),
                const SizedBox(width: 8),
                const _NotifyButton(),
              ],
            ),
          ),
          Positioned(
            right: tablet ? 20 : 8,
            bottom: tablet ? -8 : -4,
            child:
                Image.asset(
                      mascot,
                      height: tablet ? 176 : 142,
                      fit: BoxFit.contain,
                    )
                    .animate(onPlay: (c) => c.repeat(reverse: true))
                    .moveY(begin: -5, end: 5, duration: 1800.ms),
          ),
          Positioned(
            left: tablet ? 24 : 18,
            right: tablet ? 250 : 132,
            bottom: tablet ? 28 : 18,
            child: _LearningCenterCard(onTap: onTap, compact: !tablet),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 360.ms).slideY(begin: .05);
  }
}

class _AvatarBubble extends StatelessWidget {
  const _AvatarBubble({required this.asset});
  final String asset;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 62,
      height: 62,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            blurRadius: 16,
            offset: const Offset(0, 8),
            color: const Color(0xff269BD8).withValues(alpha: .22),
          ),
        ],
      ),
      child: ClipOval(child: Image.asset(asset, fit: BoxFit.cover)),
    );
  }
}

class _PointPill extends StatelessWidget {
  const _PointPill({required this.stars});
  final int stars;

  @override
  Widget build(BuildContext context) {
    return _Glass(
      radius: 24,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star_rounded, color: Color(0xffFFC928), size: 24),
          const SizedBox(width: 5),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$stars',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                  color: Color(0xff25305E),
                ),
              ),
              const Text(
                'Poin',
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w800,
                  color: Color(0xff6A6D8E),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _NotifyButton extends StatelessWidget {
  const _NotifyButton();

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        const _Glass(
          radius: 20,
          padding: EdgeInsets.all(10),
          child: Icon(
            Icons.notifications_none_rounded,
            color: Color(0xffFF8A00),
            size: 25,
          ),
        ),
        Positioned(
          right: -2,
          top: -4,
          child: Container(
            padding: const EdgeInsets.all(5),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xffFF3B48),
            ),
            child: const Text(
              '3',
              style: TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _LearningCenterCard extends StatelessWidget {
  const _LearningCenterCard({required this.onTap, this.compact = false});
  final VoidCallback onTap;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final tiny = compact || constraints.maxWidth < 310;
          return Container(
            padding: EdgeInsets.all(tiny ? 12 : 17),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(tiny ? 26 : 32),
              gradient: const LinearGradient(
                colors: [Color(0xff96EE31), Color(0xff21C94A)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  blurRadius: 24,
                  offset: const Offset(0, 12),
                  color: const Color(0xff30C957).withValues(alpha: .28),
                ),
              ],
            ),
            child: Row(
              children: [
                _RoundIcon(
                  icon: Icons.menu_book_rounded,
                  color: const Color(0xff20B447),
                  bg: Colors.white,
                  size: tiny ? 42 : 52,
                  iconSize: tiny ? 26 : 31,
                ),
                SizedBox(width: tiny ? 9 : 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Pusat Belajar',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: tiny ? 17 : 22,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        'Pilih materi belajar favoritmu',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: tiny ? 11 : 13,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: tiny ? 6 : 10),
                Container(
                  width: tiny ? 38 : 46,
                  height: tiny ? 38 : 46,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 12,
                        offset: const Offset(0, 5),
                        color: Colors.black.withValues(alpha: .12),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: const Color(0xff1FBA48),
                    size: tiny ? 17 : 20,
                  ),
                ),
              ],
            ),
          );
        },
      ).animate().fadeIn(duration: 350.ms, delay: 80.ms).slideY(begin: .06),
    );
  }
}

class _LearningGrid extends StatelessWidget {
  const _LearningGrid({required this.onOpen});
  final void Function(LearnMode mode) onOpen;

  @override
  Widget build(BuildContext context) {
    final tablet = MediaQuery.sizeOf(context).width >= 700;
    final items = [
      _LearningHomeItem(
        'HURUF',
        'A sampai Z',
        'assets/images/Logo_membaca.png',
        const Color(0xffFDE4F0),
        const Color(0xffF44F91),
        LearnMode.huruf,
      ),
      _LearningHomeItem(
        'ANGKA',
        '1 sampai 10',
        'assets/images/Logo_123.png',
        const Color(0xffDCF4FF),
        const Color(0xff2196F3),
        LearnMode.angka,
      ),
      _LearningHomeItem(
        'BENDA',
        'Mengenal benda',
        'assets/images/Logo_Benda.png',
        const Color(0xffE6F9D8),
        const Color(0xff1BB86F),
        LearnMode.benda,
      ),
      _LearningHomeItem(
        'IQRA 1',
        'Hijaiyah dasar',
        'assets/images/Logo_iqra.png',
        const Color(0xffEBDDFF),
        const Color(0xff8D55F6),
        LearnMode.iqra,
      ),
    ];
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: tablet ? 4 : 2,
        mainAxisSpacing: 14,
        crossAxisSpacing: 14,
        childAspectRatio: tablet ? .92 : .86,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) => _LearningHomeTile(
        item: items[index],
        delay: 90 * index,
        onTap: () => onOpen(items[index].mode),
      ),
    );
  }
}

class _LearningHomeItem {
  const _LearningHomeItem(
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

class _LearningHomeTile extends StatelessWidget {
  const _LearningHomeTile({
    required this.item,
    required this.delay,
    required this.onTap,
  });
  final _LearningHomeItem item;
  final int delay;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child:
          Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: item.bg,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.white, width: 3),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                      color: item.color.withValues(alpha: .16),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: .28),
                          borderRadius: BorderRadius.circular(22),
                        ),
                        child: Image.asset(item.asset, fit: BoxFit.contain),
                      ),
                    ),
                    const SizedBox(height: 9),
                    Container(
                      padding: const EdgeInsets.fromLTRB(12, 9, 8, 9),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: .74),
                        borderRadius: BorderRadius.circular(23),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: item.color,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  item.subtitle,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: Color(0xff464B72),
                                    fontSize: 11,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 33,
                            height: 33,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: item.color,
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 10,
                                  offset: const Offset(0, 5),
                                  color: item.color.withValues(alpha: .28),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.chevron_right_rounded,
                              color: Colors.white,
                              size: 27,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
              .animate()
              .fadeIn(
                duration: 340.ms,
                delay: Duration(milliseconds: delay),
              )
              .slideY(begin: .08, delay: Duration(milliseconds: delay)),
    );
  }
}

class _HomeProgressPanel extends StatelessWidget {
  const _HomeProgressPanel({required this.progress});
  final Map<String, int> progress;

  @override
  Widget build(BuildContext context) {
    final entries = [
      _ProgressHomeItem(
        'Huruf',
        progress['membaca'] ?? 0,
        const Color(0xffFF6AA4),
      ),
      _ProgressHomeItem(
        'Angka',
        progress['angka'] ?? 0,
        const Color(0xff1E95F2),
      ),
      _ProgressHomeItem(
        'Benda',
        progress['benda'] ?? 0,
        const Color(0xff1DBD68),
      ),
      _ProgressHomeItem(
        'Iqra 1',
        progress['iqra'] ?? 0,
        const Color(0xff8B55F6),
      ),
    ];
    return _SoftCard(
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.bar_chart_rounded, color: Color(0xff42C869), size: 24),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Progress Belajarmu',
                  style: TextStyle(
                    color: Color(0xff303163),
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: entries
                .map((e) => Expanded(child: _CircularProgressMini(item: e)))
                .toList(),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 350.ms, delay: 260.ms).slideY(begin: .06);
  }
}

class _ProgressHomeItem {
  const _ProgressHomeItem(this.label, this.value, this.color);
  final String label;
  final int value;
  final Color color;
}

class _CircularProgressMini extends StatelessWidget {
  const _CircularProgressMini({required this.item});
  final _ProgressHomeItem item;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: 62,
          height: 62,
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 58,
                height: 58,
                child: CircularProgressIndicator(
                  value: item.value.clamp(0, 100) / 100,
                  strokeWidth: 6,
                  strokeCap: StrokeCap.round,
                  backgroundColor: item.color.withValues(alpha: .13),
                  color: item.color,
                ),
              ),
              Text(
                '${item.value}%',
                style: TextStyle(
                  color: item.color,
                  fontSize: 15,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 7),
        Text(
          item.label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Color(0xff42496E),
            fontSize: 11,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

class _ModeFunCard extends StatelessWidget {
  const _ModeFunCard({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return _ActionIllustrationCard(
      title: 'Mode Seru',
      subtitle: 'Belajar dengan lebih',
      asset: 'assets/images/Mic.png',
      icon: Icons.mic_rounded,
      colors: const [Color(0xffFFF5C9), Color(0xffFFE1E8)],
      titleColor: const Color(0xff9B4B19),
      buttonColor: const Color(0xffFF8A1F),
      buttonText: 'Ayo Mulai',
      onTap: onTap,
    );
  }
}

class _SongHomeCard extends StatelessWidget {
  const _SongHomeCard({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return _ActionIllustrationCard(
      title: 'Lagu Anak',
      subtitle: 'Ayo bernyanyi bersama!',
      asset: 'assets/images/Bernyanyi.png',
      icon: Icons.play_arrow_rounded,
      colors: const [Color(0xff9F55FF), Color(0xffF19CFF)],
      titleColor: Colors.white,
      textColor: Colors.white,
      buttonColor: Colors.white,
      buttonIconColor: const Color(0xff8B55F6),
      buttonText: 'Putar',
      imageHeight: 128,
      imageWidth: 166,
      imageRight: -24,
      contentRightPadding: 220,
      onTap: onTap,
    );
  }
}

class _BadgeHomeCard extends StatelessWidget {
  const _BadgeHomeCard({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return _ActionIllustrationCard(
      title: 'Dapatkan Poin & Badge',
      subtitle: 'Dapatkan badge keren!',
      asset: 'assets/images/Badge.png',
      icon: Icons.workspace_premium_rounded,
      colors: const [Color(0xff19C6B3), Color(0xff20A59B)],
      titleColor: Colors.white,
      textColor: Colors.white,
      buttonColor: Colors.white,
      buttonIconColor: const Color(0xff11A796),
      buttonText: 'Badge',
      imageHeight: 128,
      imageWidth: 168,
      imageRight: -34,
      contentRightPadding: 152,
      onTap: onTap,
    );
  }
}

class _ActionIllustrationCard extends StatelessWidget {
  const _ActionIllustrationCard({
    required this.title,
    required this.subtitle,
    required this.asset,
    required this.icon,
    required this.colors,
    required this.titleColor,
    required this.buttonColor,
    required this.buttonText,
    required this.onTap,
    this.textColor = const Color(0xff4D5275),
    this.buttonIconColor = Colors.white,
    this.imageHeight = 82,
    this.imageWidth = 132,
    this.imageRight = -12,
    this.contentRightPadding = 118,
  });

  final String title;
  final String subtitle;
  final String asset;
  final IconData icon;
  final List<Color> colors;
  final Color titleColor;
  final Color textColor;
  final Color buttonColor;
  final Color buttonIconColor;
  final String buttonText;
  final double imageHeight;
  final double imageWidth;
  final double imageRight;
  final double contentRightPadding;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final whiteButton = buttonColor == Colors.white;
    return GestureDetector(
      onTap: onTap,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final mobile = constraints.maxWidth < 520;
          final reserve = mobile
              ? min(contentRightPadding, constraints.maxWidth * .42)
              : contentRightPadding;
          final nextImageWidth =
              (mobile
                      ? min(imageWidth, constraints.maxWidth * .36)
                      : imageWidth)
                  .toDouble();
          final nextImageHeight = (mobile ? min(imageHeight, 118) : imageHeight)
              .toDouble();
          return Padding(
                padding: EdgeInsets.only(top: 16, right: mobile ? 0 : 10),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: double.infinity,
                      constraints: const BoxConstraints(minHeight: 126),
                      padding: EdgeInsets.fromLTRB(18, 16, reserve + 8, 14),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        gradient: LinearGradient(
                          colors: colors,
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        border: Border.all(color: Colors.white, width: 2),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 18,
                            offset: const Offset(0, 10),
                            color: colors.last.withValues(alpha: .22),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: titleColor,
                              fontSize: mobile ? 20 : 19,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(height: 7),
                          Text(
                            subtitle,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: textColor,
                              fontSize: mobile ? 14 : 13,
                              fontWeight: FontWeight.w900,
                              height: 1.25,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: buttonColor,
                              borderRadius: BorderRadius.circular(999),
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 10,
                                  offset: const Offset(0, 5),
                                  color: Colors.black.withValues(alpha: .10),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  icon,
                                  color: whiteButton
                                      ? buttonIconColor
                                      : Colors.white,
                                  size: 15,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  buttonText,
                                  style: TextStyle(
                                    color: whiteButton
                                        ? buttonIconColor
                                        : Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      right: mobile ? max(imageRight, -14) : imageRight,
                      top: -14,
                      bottom: -8,
                      child: Image.asset(
                        asset,
                        height: nextImageHeight,
                        width: nextImageWidth,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ],
                ),
              )
              .animate()
              .fadeIn(duration: 330.ms, delay: 300.ms)
              .slideY(begin: .06);
        },
      ),
    );
  }
}

class _SoftCard extends StatelessWidget {
  const _SoftCard({required this.child, required this.padding});
  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .92),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white, width: 1.6),
        boxShadow: [
          BoxShadow(
            blurRadius: 24,
            offset: const Offset(0, 12),
            color: const Color(0xff7AAED3).withValues(alpha: .18),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _Glass extends StatelessWidget {
  const _Glass({
    required this.child,
    required this.padding,
    required this.radius,
  });
  final Widget child;
  final EdgeInsetsGeometry padding;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: .72),
            borderRadius: BorderRadius.circular(radius),
            border: Border.all(color: Colors.white.withValues(alpha: .84)),
          ),
          child: child,
        ),
      ),
    );
  }
}

class _RoundIcon extends StatelessWidget {
  const _RoundIcon({
    required this.icon,
    required this.color,
    required this.bg,
    this.size = 52,
    this.iconSize = 31,
  });
  final IconData icon;
  final Color color;
  final Color bg;
  final double size;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: bg),
      child: Icon(icon, color: color, size: iconSize),
    );
  }
}
