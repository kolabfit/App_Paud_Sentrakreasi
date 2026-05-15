part of '../main.dart';

class SongsScreen extends ConsumerStatefulWidget {
  const SongsScreen({super.key});
  @override
  ConsumerState<SongsScreen> createState() => _SongsScreenState();
}

class _SongsScreenState extends ConsumerState<SongsScreen> {
  SongItem? selected;
  String query = '';
  String category = 'Semua';

  @override
  Widget build(BuildContext context) {
    final app = ref.watch(appStateProvider);
    final t = app.theme;
    final songs = app.songs;
    if (selected == null && songs.isNotEmpty) selected = songs.first;
    if (selected != null && !songs.any((s) => s.id == selected!.id)) {
      selected = songs.isEmpty ? null : songs.first;
    }

    final tablet = MediaQuery.sizeOf(context).width >= 760;
    final visibleSongs = songs.where((song) {
      final matchesQuery =
          query.trim().isEmpty ||
          song.title.toLowerCase().contains(query.trim().toLowerCase()) ||
          (song.fileName ?? '').toLowerCase().contains(
            query.trim().toLowerCase(),
          );
      final matchesCategory =
          category == 'Semua' ||
          (category == 'Favorit' && app.favorites.contains(song.id)) ||
          category == 'Populer' ||
          category == 'Terbaru';
      return matchesQuery && matchesCategory;
    }).toList();

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
                      NightPalette.midnight.withValues(alpha: .08),
                      NightPalette.purple.withValues(alpha: .55),
                      NightPalette.midnight.withValues(alpha: .86),
                    ]
                  : [
                      Colors.white.withValues(alpha: .04),
                      const Color(0xffF7EAFF).withValues(alpha: .62),
                      Colors.white.withValues(alpha: .88),
                    ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        ...List.generate(20, (i) {
          final width = MediaQuery.sizeOf(context).width;
          final left = (i * 61 % max(1, width.toInt())).toDouble();
          final top = 34.0 + (i * 49 % 680);
          return Positioned(
            left: left,
            top: top,
            child: Icon(
              i.isEven ? Icons.music_note_rounded : Icons.auto_awesome_rounded,
              color: [
                const Color(0xffFF70B7),
                t.night ? NightPalette.lavender : const Color(0xff8B55F6),
                NightPalette.gold,
                NightPalette.cyan,
              ][i % 4].withValues(alpha: t.night ? .55 : .70),
              size: i.isEven ? 22 : 13,
            ),
          );
        }),
        SafeArea(
          child: Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: tablet ? 1040 : 560),
              child: ListView(
                padding: EdgeInsets.fromLTRB(
                  tablet ? 28 : 18,
                  18,
                  tablet ? 28 : 18,
                  selected == null ? 126 : 250,
                ),
                children: [
                  _SongsHero(app: app),
                  const SizedBox(height: 16),
                  _SongSearchAndFilters(
                    query: query,
                    category: category,
                    onQuery: (v) => setState(() => query = v),
                    onCategory: (v) => setState(() => category = v),
                  ),
                  const SizedBox(height: 16),
                  _SingModeCard(onTap: () => Feedback.forTap(context)),
                  if (selected != null) ...[
                    const SizedBox(height: 16),
                    _NowPlayingVideo(song: selected!),
                  ],
                  const SizedBox(height: 18),
                  _SongSectionHeader(count: visibleSongs.length),
                  const SizedBox(height: 12),
                  if (visibleSongs.isEmpty)
                    _SongEmptyState(hasSongs: songs.isNotEmpty)
                  else if (tablet)
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 14,
                            crossAxisSpacing: 14,
                            childAspectRatio: 3.35,
                          ),
                      itemCount: visibleSongs.length,
                      itemBuilder: (_, i) => _PremiumSongCard(
                        song: visibleSongs[i],
                        active: selected?.id == visibleSongs[i].id,
                        favorite: app.favorites.contains(visibleSongs[i].id),
                        delay: i * 55,
                        onTap: () => setState(() => selected = visibleSongs[i]),
                        onFav: () => ref
                            .read(appStateProvider)
                            .toggleFavorite(visibleSongs[i].id),
                      ),
                    )
                  else
                    ...visibleSongs.asMap().entries.map(
                      (entry) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _PremiumSongCard(
                          song: entry.value,
                          active: selected?.id == entry.value.id,
                          favorite: app.favorites.contains(entry.value.id),
                          delay: entry.key * 55,
                          onTap: () => setState(() => selected = entry.value),
                          onFav: () => ref
                              .read(appStateProvider)
                              .toggleFavorite(entry.value.id),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
        if (selected != null)
          Positioned(
            left: tablet ? 28 : 18,
            right: tablet ? 28 : 18,
            bottom: 106,
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: tablet ? 980 : 520),
                child: _MiniMusicPlayer(song: selected!),
              ),
            ),
          ),
      ],
    );
  }
}

class _SongsHero extends StatelessWidget {
  const _SongsHero({required this.app});
  final AppState app;

  @override
  Widget build(BuildContext context) {
    final tablet = MediaQuery.sizeOf(context).width >= 760;
    return SizedBox(
      height: tablet ? 286 : 258,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: 18,
            top: 16,
            child: _SongRoundButton(
              icon: Icons.chevron_left_rounded,
              onTap: () => ProviderScope.containerOf(
                context,
              ).read(appStateProvider).go(TabItem.main),
            ),
          ),
          Positioned(
            right: 18,
            top: 16,
            child: Row(
              children: [
                _SongPointPill(stars: app.stars),
                const SizedBox(width: 10),
                const _SongNotifyButton(),
              ],
            ),
          ),
          Positioned(
            left: tablet ? 34 : 18,
            top: tablet ? 70 : 72,
            right: tablet ? 390 : 118,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: tablet ? 136 : 108,
                maxWidth: tablet ? 500 : 280,
              ),
              child: FittedBox(
                fit: BoxFit.contain,
                alignment: Alignment.centerLeft,
                child: Image.asset('assets/images/lagu_anak.png', width: 520),
              ),
            ),
          ),
          Positioned(
            right: tablet ? 42 : -12,
            bottom: tablet ? -14 : -8,
            child: Image.asset(
              'assets/images/Anak_Anak_Bernyanyi.png',
              height: tablet ? 210 : 154,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 340.ms).slideY(begin: .04);
  }
}

class _SongSearchAndFilters extends StatelessWidget {
  const _SongSearchAndFilters({
    required this.query,
    required this.category,
    required this.onQuery,
    required this.onCategory,
  });
  final String query;
  final String category;
  final ValueChanged<String> onQuery;
  final ValueChanged<String> onCategory;

  @override
  Widget build(BuildContext context) {
    final t = _themeOf(context);
    final cats = ['Semua', 'Populer', 'Terbaru', 'Favorit'];
    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth >= 760;
        final search = _SongSearchBar(query: query, onChanged: onQuery);
        final chips = SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: cats
                .map(
                  (cat) => Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: _SongFilterChip(
                      label: cat,
                      active: category == cat,
                      onTap: () => onCategory(cat),
                    ),
                  ),
                )
                .toList(),
          ),
        );
        if (wide) {
          return Container(
            padding: const EdgeInsets.all(10),
            decoration: t.night
                ? nightGlassDecoration(
                    borderColor: NightPalette.cyan,
                    radius: 34,
                  )
                : BoxDecoration(
                    color: Colors.white.withValues(alpha: .92),
                    borderRadius: BorderRadius.circular(34),
                    border: Border.all(color: Colors.white, width: 1.5),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 18,
                        offset: const Offset(0, 10),
                        color: const Color(0xff7AAED3).withValues(alpha: .16),
                      ),
                    ],
                  ),
            child: Row(
              children: [
                Expanded(flex: 4, child: search),
                const SizedBox(width: 14),
                Expanded(flex: 6, child: chips),
              ],
            ),
          );
        }
        return Column(children: [search, const SizedBox(height: 12), chips]);
      },
    );
  }
}

class _SingModeCard extends StatelessWidget {
  const _SingModeCard({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        constraints: const BoxConstraints(minHeight: 150),
        padding: const EdgeInsets.fromLTRB(18, 18, 16, 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          gradient: const LinearGradient(
            colors: [Color(0xffB26DFF), Color(0xffFF87D2)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          border: Border.all(color: Colors.white, width: 2),
          boxShadow: [
            BoxShadow(
              blurRadius: 22,
              offset: const Offset(0, 12),
              color: const Color(0xffB26DFF).withValues(alpha: .24),
            ),
          ],
        ),
        child: Row(
          children: [
            Image.asset(
              'assets/images/Mic.png',
              width: 88,
              fit: BoxFit.contain,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Mode Nyanyi Seru',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 7),
                  const Text(
                    'Belajar lebih menyenangkan dengan suara!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      const _MusicWave(color: Colors.white),
                      const SizedBox(width: 14),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Ayo Coba',
                              style: TextStyle(
                                color: Color(0xffB14DDF),
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            Icon(
                              Icons.chevron_right_rounded,
                              color: Color(0xffB14DDF),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 6),
            Image.asset(
              'assets/images/box_musik.png',
              width: 116,
              height: 104,
              fit: BoxFit.contain,
            ),
          ],
        ),
      ).animate().fadeIn(duration: 330.ms).slideY(begin: .06),
    );
  }
}

class _NowPlayingVideo extends StatelessWidget {
  const _NowPlayingVideo({required this.song});
  final SongItem song;

  @override
  Widget build(BuildContext context) {
    final t = _themeOf(context);
    return Container(
      decoration: t.night
          ? nightGlassDecoration(borderColor: NightPalette.lavender)
          : BoxDecoration(
              color: Colors.white.withValues(alpha: .92),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: Colors.white, width: 2),
              boxShadow: [
                BoxShadow(
                  blurRadius: 22,
                  offset: const Offset(0, 12),
                  color: const Color(0xff8B55F6).withValues(alpha: .14),
                ),
              ],
            ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: SongPlayer(song: song),
      ),
    );
  }
}

class _PremiumSongCard extends StatelessWidget {
  const _PremiumSongCard({
    required this.song,
    required this.active,
    required this.favorite,
    required this.delay,
    required this.onTap,
    required this.onFav,
  });
  final SongItem song;
  final bool active;
  final bool favorite;
  final int delay;
  final VoidCallback onTap;
  final VoidCallback onFav;

  @override
  Widget build(BuildContext context) {
    final thumb = youtubeThumb(song.videoUrl);
    final t = _themeOf(context);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(28),
        child: Ink(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: t.night
                ? NightPalette.surface.withValues(alpha: active ? .82 : .66)
                : Colors.white.withValues(alpha: active ? 1 : .94),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color: active
                  ? (t.night ? NightPalette.cyan : const Color(0xff8B55F6))
                  : (t.night
                        ? NightPalette.lavender.withValues(alpha: .20)
                        : Colors.white),
              width: active ? 2.5 : 1.5,
            ),
            boxShadow: [
              BoxShadow(
                blurRadius: active ? 22 : 14,
                offset: const Offset(0, 9),
                color: (t.night ? NightPalette.cyan : const Color(0xff8B55F6))
                    .withValues(alpha: active ? .26 : .10),
              ),
            ],
          ),
          child: Row(
            children: [
              _SongThumb(url: thumb),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      song.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: t.night
                            ? NightPalette.text
                            : const Color(0xff252A70),
                        fontSize: 17,
                        fontWeight: FontWeight.w900,
                        height: 1.05,
                      ),
                    ),
                    const SizedBox(height: 7),
                    Text(
                      song.fileName ?? 'Lagu Anak',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: t.night
                            ? NightPalette.muted
                            : const Color(0xff74799E),
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 9),
                    const _DurationPill(text: '02:45'),
                  ],
                ),
              ),
              IconButton(
                onPressed: onFav,
                icon: Icon(
                  favorite
                      ? Icons.favorite_rounded
                      : Icons.favorite_border_rounded,
                  color: const Color(0xffFF6E9E),
                  size: 30,
                ),
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(delay: Duration(milliseconds: delay)).slideY(begin: .05);
  }
}

class _MiniMusicPlayer extends StatelessWidget {
  const _MiniMusicPlayer({required this.song});
  final SongItem song;

  @override
  Widget build(BuildContext context) {
    final thumb = youtubeThumb(song.videoUrl);
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xff6B75FF).withValues(alpha: .90),
                const Color(0xffB76DFF).withValues(alpha: .90),
              ],
            ),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: Colors.white.withValues(alpha: .45)),
            boxShadow: [
              BoxShadow(
                blurRadius: 24,
                offset: const Offset(0, 12),
                color: const Color(0xff765BFF).withValues(alpha: .28),
              ),
            ],
          ),
          child: Row(
            children: [
              _SongThumb(url: thumb, small: true),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      song.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Text(
                      song.fileName ?? 'Lagu Anak',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: .86),
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Text(
                          '01:20',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(99),
                            child: LinearProgressIndicator(
                              value: .48,
                              minHeight: 7,
                              backgroundColor: Colors.white.withValues(
                                alpha: .35,
                              ),
                              color: const Color(0xffFFD34D),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          '02:45',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              const _MiniControl(icon: Icons.skip_previous_rounded),
              const SizedBox(width: 8),
              const _MiniControl(icon: Icons.pause_rounded, main: true),
              const SizedBox(width: 8),
              const _MiniControl(icon: Icons.skip_next_rounded),
              const SizedBox(width: 8),
              const _MiniControl(icon: Icons.queue_music_rounded),
            ],
          ),
        ),
      ),
    );
  }
}

class _SongSearchBar extends StatelessWidget {
  const _SongSearchBar({required this.query, required this.onChanged});
  final String query;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final t = _themeOf(context);
    return Container(
      decoration: BoxDecoration(
        color: t.night
            ? NightPalette.surface.withValues(alpha: .72)
            : Colors.white.withValues(alpha: .94),
        borderRadius: BorderRadius.circular(999),
        boxShadow: [
          BoxShadow(
            blurRadius: 16,
            offset: const Offset(0, 8),
            color: (t.night ? NightPalette.cyan : const Color(0xff7AAED3))
                .withValues(alpha: .16),
          ),
        ],
      ),
      child: TextField(
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: 'Cari lagu anak...',
          prefixIcon: Icon(
            Icons.search_rounded,
            color: t.night ? NightPalette.cyan : const Color(0xff6D6F98),
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 18, vertical: 15),
        ),
      ),
    );
  }
}

class _SongFilterChip extends StatelessWidget {
  const _SongFilterChip({
    required this.label,
    required this.active,
    required this.onTap,
  });
  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final t = _themeOf(context);
    final icon = switch (label) {
      'Populer' => Icons.star_rounded,
      'Terbaru' => Icons.schedule_rounded,
      'Favorit' => Icons.favorite_rounded,
      _ => Icons.music_note_rounded,
    };
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: 220.ms,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        decoration: BoxDecoration(
          color: active
              ? (t.night ? NightPalette.lavender : const Color(0xff9B5CF6))
              : (t.night
                    ? NightPalette.surface.withValues(alpha: .68)
                    : Colors.white.withValues(alpha: .94)),
          borderRadius: BorderRadius.circular(999),
          boxShadow: [
            BoxShadow(
              blurRadius: active ? 18 : 10,
              offset: const Offset(0, 8),
              color:
                  (active
                          ? (t.night
                                ? NightPalette.cyan
                                : const Color(0xff9B5CF6))
                          : (t.night
                                ? NightPalette.lavender
                                : const Color(0xff7AAED3)))
                      .withValues(alpha: active ? .28 : .12),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: active
                  ? Colors.white
                  : (t.night ? NightPalette.cyan : const Color(0xff8B55F6)),
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: active
                    ? Colors.white
                    : (t.night ? NightPalette.text : const Color(0xff353877)),
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SongThumb extends StatelessWidget {
  const _SongThumb({required this.url, this.small = false});
  final String? url;
  final bool small;

  @override
  Widget build(BuildContext context) {
    final size = small ? 58.0 : 92.0;
    return SizedBox(
      width: size,
      height: size,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(small ? 18 : 24),
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (url != null)
              CachedNetworkImage(imageUrl: url!, fit: BoxFit.cover)
            else
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xffB26DFF), Color(0xff6FD8FF)],
                  ),
                ),
                child: Image.asset(
                  'assets/images/Bernyanyi.png',
                  fit: BoxFit.cover,
                ),
              ),
            Positioned(
              right: 5,
              bottom: 5,
              child: Container(
                width: small ? 24 : 34,
                height: small ? 24 : 34,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: Icon(
                  Icons.play_arrow_rounded,
                  color: const Color(0xff8B55F6),
                  size: small ? 18 : 25,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SongSectionHeader extends StatelessWidget {
  const _SongSectionHeader({required this.count});
  final int count;

  @override
  Widget build(BuildContext context) {
    final t = _themeOf(context);
    return Row(
      children: [
        const Icon(
          Icons.music_note_rounded,
          color: Color(0xff9B55F6),
          size: 28,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            'Daftar Lagu Populer',
            style: TextStyle(
              color: t.night ? NightPalette.text : const Color(0xff272B6F),
              fontSize: 21,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        Text(
          count == 0 ? '' : 'Lihat Semua',
          style: const TextStyle(
            color: Color(0xff9B55F6),
            fontSize: 13,
            fontWeight: FontWeight.w900,
          ),
        ),
        if (count > 0)
          const Icon(Icons.chevron_right_rounded, color: Color(0xff9B55F6)),
      ],
    );
  }
}

class _SongEmptyState extends StatelessWidget {
  const _SongEmptyState({required this.hasSongs});
  final bool hasSongs;

  @override
  Widget build(BuildContext context) {
    final t = _themeOf(context);
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: t.night
            ? NightPalette.surface.withValues(alpha: .72)
            : Colors.white.withValues(alpha: .94),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        children: [
          Image.asset('assets/images/Bernyanyi.png', height: 110),
          const SizedBox(height: 12),
          Text(
            hasSongs
                ? 'Lagu tidak ditemukan.'
                : 'Belum ada video lagu. Pengajar bisa upload dari dashboard.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: t.night ? NightPalette.text : const Color(0xff4D5179),
              fontSize: 14,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _DurationPill extends StatelessWidget {
  const _DurationPill({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xffEEE8FF),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.music_note_rounded,
            color: Color(0xff8B55F6),
            size: 15,
          ),
          const SizedBox(width: 4),
          Text(
            text,
            style: const TextStyle(
              color: Color(0xff5F4CC8),
              fontSize: 11,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniControl extends StatelessWidget {
  const _MiniControl({required this.icon, this.main = false});
  final IconData icon;
  final bool main;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: main ? 54 : 40,
      height: main ? 54 : 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: main ? Colors.white : Colors.white.withValues(alpha: .18),
        boxShadow: main
            ? [
                BoxShadow(
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                  color: Colors.black.withValues(alpha: .16),
                ),
              ]
            : null,
      ),
      child: Icon(
        icon,
        color: main ? const Color(0xffFFB020) : Colors.white,
        size: main ? 32 : 24,
      ),
    );
  }
}

class _MusicWave extends StatelessWidget {
  const _MusicWave({required this.color});
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
        5,
        (i) => Container(
          width: 6,
          height: 14 + (i % 3) * 8,
          margin: const EdgeInsets.only(right: 4),
          decoration: BoxDecoration(
            color: color.withValues(alpha: .82),
            borderRadius: BorderRadius.circular(99),
          ),
        ),
      ),
    );
  }
}

class _SongRoundButton extends StatelessWidget {
  const _SongRoundButton({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Material(
          color: Colors.white.withValues(alpha: .88),
          child: InkWell(
            onTap: onTap,
            child: SizedBox(
              width: 56,
              height: 56,
              child: Icon(icon, color: const Color(0xff8B55F6), size: 34),
            ),
          ),
        ),
      ),
    );
  }
}

class _SongPointPill extends StatelessWidget {
  const _SongPointPill({required this.stars});
  final int stars;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .92),
        borderRadius: BorderRadius.circular(999),
        boxShadow: [
          BoxShadow(
            blurRadius: 18,
            offset: const Offset(0, 8),
            color: const Color(0xff7AAED3).withValues(alpha: .18),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.star_rounded, color: Color(0xffFFC928), size: 28),
          const SizedBox(width: 7),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$stars',
                style: const TextStyle(
                  color: Color(0xff3B3D86),
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const Text(
                'Poin Kamu',
                style: TextStyle(
                  color: Color(0xff5A6090),
                  fontSize: 9,
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

class _SongNotifyButton extends StatelessWidget {
  const _SongNotifyButton();

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        _SongRoundButton(icon: Icons.notifications_rounded, onTap: () {}),
        Positioned(
          right: -3,
          top: -5,
          child: Container(
            padding: const EdgeInsets.all(5),
            decoration: const BoxDecoration(
              color: Color(0xffFF334B),
              shape: BoxShape.circle,
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
