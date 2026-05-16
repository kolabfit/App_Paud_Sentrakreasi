part of '../main.dart';

class SongPlayer extends StatelessWidget {
  const SongPlayer({required this.song, super.key});
  final SongItem song;

  @override
  Widget build(BuildContext context) {
    final t = _themeOf(context);
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: tactileCard(
        context,
        border: t.dark ? const Color(0xffF1C40F) : Colors.pink.shade200,
        radius: 30,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(22),
              child: Stack(
                fit: StackFit.expand,
                children: [DirectVideo(url: song.videoUrl)],
              ),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            song.title,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
          ),
          AudioBars(color: Theme.of(context).colorScheme.primary),
          if (song.fileName != null) ...[
            const SizedBox(height: 8),
            Chip(
              avatar: const Icon(Icons.video_file_rounded, size: 18),
              label: Text(song.fileName!),
              backgroundColor: t.dark ? Colors.white10 : Colors.grey.shade100,
              side: BorderSide.none,
            ),
          ],
        ],
      ),
    );
  }
}

class DirectVideo extends StatefulWidget {
  const DirectVideo({required this.url, super.key});
  final String url;
  @override
  State<DirectVideo> createState() => _DirectVideoState();
}

class _DirectVideoState extends State<DirectVideo> {
  VideoPlayerController? controller;
  @override
  void initState() {
    super.initState();
    _initController();
  }

  Future<void> _initController() async {
    final source = widget.url.trim();
    if (source.isEmpty) return;
    if (MediaSourceHelper.isDataUri(source)) {
      final persisted = await LocalStorageService.instance.persistDataUri(
        source,
        bucket: StorageBucket.songVideos,
        fileName: 'legacy_song_${DateTime.now().millisecondsSinceEpoch}.mp4',
      );
      if (!mounted || persisted == null) return;
      controller = VideoPlayerController.file(File(persisted));
    } else if (MediaSourceHelper.isLocalFilePath(source)) {
      controller = VideoPlayerController.file(File(source));
    } else if (MediaSourceHelper.isAssetPath(source)) {
      controller = VideoPlayerController.asset(source);
    } else {
      controller = VideoPlayerController.networkUrl(Uri.parse(source));
    }
    await controller?.initialize();
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = controller;
    if (c == null || !c.value.isInitialized) {
      return Container(
        color: Colors.black12,
        child: const Center(child: Icon(Icons.video_library, size: 64)),
      );
    }
    return GestureDetector(
      onTap: () {
        c.value.isPlaying ? c.pause() : c.play();
        setState(() {});
      },
      child: Stack(
        fit: StackFit.expand,
        children: [
          FittedBox(
            fit: BoxFit.cover,
            child: SizedBox(
              width: c.value.size.width,
              height: c.value.size.height,
              child: VideoPlayer(c),
            ),
          ),
          AnimatedOpacity(
            opacity: c.value.isPlaying ? 0 : 1,
            duration: 180.ms,
            child: Container(
              color: Colors.black.withValues(alpha: .18),
              child: const Center(
                child: CircleAvatar(
                  radius: 34,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.play_arrow_rounded, size: 46),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SongTile extends StatelessWidget {
  const SongTile({
    required this.song,
    required this.active,
    required this.favorite,
    required this.onTap,
    required this.onFav,
    super.key,
  });
  final SongItem song;
  final bool active;
  final bool favorite;
  final VoidCallback onTap;
  final VoidCallback onFav;

  @override
  Widget build(BuildContext context) {
    final t = _themeOf(context);
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: 220.ms,
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: active ? t.widgetBorder.withValues(alpha: .1) : t.widgetBg,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: active
                ? t.widgetBorder
                : t.widgetBorder.withValues(alpha: .15),
            width: active ? 2.5 : 1,
          ),
          boxShadow: active
              ? [
                  BoxShadow(
                    blurRadius: 12,
                    color: t.widgetBorder.withValues(alpha: .15),
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: t.primary.withValues(alpha: .12),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(Icons.music_note_rounded, color: t.primary),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    song.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 15,
                    ),
                  ),
                  Text(
                    song.fileName ?? 'Video upload pengajar',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 12, color: muted(context)),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: onFav,
              icon: Icon(
                favorite ? Icons.favorite : Icons.favorite_border,
                color: favorite ? Colors.redAccent : muted(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LessonCard extends StatelessWidget {
  const LessonCard({
    required this.title,
    required this.subtitle,
    required this.onSpeak,
    this.image,
    this.footer,
    super.key,
  });
  final String title;
  final String subtitle;
  final String? image;
  final Widget? footer;
  final VoidCallback onSpeak;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      child: Container(
        padding: const EdgeInsets.all(22),
        decoration: tactileCard(context, radius: 38),
        child: Column(
          children: [
            Expanded(
              child: image == null
                  ? const EmptyState(text: 'Gambar belum diupload pengajar.')
                  : AppImage(url: image!, fit: BoxFit.contain),
            ),
            Text(
              title,
              style: TextStyle(
                fontSize: 84,
                height: .92,
                fontWeight: FontWeight.w900,
                color: Theme.of(context).colorScheme.primary,
              ),
            ).animate().scale(duration: 260.ms),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 10),
            FilledButton.icon(
              onPressed: onSpeak,
              icon: const Icon(Icons.volume_up),
              label: const Text('Dengarkan'),
            ),
            if (footer != null) ...[const SizedBox(height: 10), footer!],
          ],
        ),
      ),
    );
  }
}

class LessonMiniCard extends StatelessWidget {
  const LessonMiniCard({
    required this.title,
    required this.subtitle,
    this.image,
    this.badge,
    super.key,
  });
  final String title;
  final String subtitle;
  final String? image;
  final List<Widget>? badge;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: cardDecoration(context),
      child: Column(
        children: [
          Expanded(
            child: image == null
                ? const Icon(Icons.image_not_supported, size: 48)
                : AppImage(url: image!, fit: BoxFit.contain),
          ),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: title.length <= 2 ? 48 : 24,
              fontWeight: FontWeight.w900,
            ),
          ),
          Text(
            subtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: muted(context),
              fontWeight: FontWeight.w800,
            ),
          ),
          if (badge != null)
            Wrap(alignment: WrapAlignment.center, spacing: 4, children: badge!),
        ],
      ),
    );
  }
}

class FeatureTile extends StatelessWidget {
  const FeatureTile({
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
    this.asset,
    this.icon,
    super.key,
  });
  final String title;
  final String subtitle;
  final String? asset;
  final IconData? icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final t = _themeOf(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: t.widgetBg,
          borderRadius: BorderRadius.circular(26),
          border: Border.all(color: color.withValues(alpha: .22), width: 2),
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, 5),
              blurRadius: 0,
              color: color.withValues(alpha: .12),
            ),
            BoxShadow(
              blurRadius: 14,
              offset: const Offset(0, 6),
              color: Colors.black.withValues(alpha: t.dark ? .12 : .04),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 68,
              height: 68,
              decoration: BoxDecoration(
                color: t.dark
                    ? color.withValues(alpha: .15)
                    : color.withValues(alpha: .1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: color.withValues(alpha: .2),
                  width: 1.5,
                ),
              ),
              child: asset != null
                  ? Padding(
                      padding: const EdgeInsets.all(10),
                      child: Image.asset(asset!, fit: BoxFit.contain),
                    )
                  : Icon(icon, size: 36, color: color),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: t.dark ? Colors.white : Colors.grey.shade800,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: muted(context),
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: color.withValues(alpha: .1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.arrow_forward_ios_rounded,
                color: color,
                size: 16,
              ),
            ),
          ],
        ),
      ).animate().fadeIn(duration: 240.ms).slideY(begin: .08),
    );
  }
}

class ProgressOverview extends StatelessWidget {
  const ProgressOverview({
    required this.progress,
    required this.compact,
    super.key,
  });
  final Map<String, int> progress;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final t = _themeOf(context);
    // Ignore mode_seru if it still exists in old state
    final entries = progress.entries
        .where((e) => e.key != 'mode_seru')
        .toList();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: tactileCard(context, radius: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: entries.map((e) {
          final cat = e.key;
          final color = colorForCategory(cat);
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: t.dark
                            ? color.withValues(alpha: .2)
                            : color.withValues(alpha: .1),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: color.withValues(alpha: .3)),
                      ),
                      child: Image.asset(
                        _assetForCategory(cat),
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            labelForProgress(cat).toUpperCase(),
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 14,
                              letterSpacing: 1.5,
                              color: t.dark
                                  ? Colors.white
                                  : Colors.grey.shade800,
                            ),
                          ),
                          const SizedBox(height: 6),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(999),
                            child: LinearProgressIndicator(
                              value: e.value / 100,
                              minHeight: 12,
                              backgroundColor: color.withValues(alpha: .15),
                              color: color,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 14),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            offset: const Offset(0, 4),
                            blurRadius: 0,
                            color: color.withValues(alpha: .4),
                          ),
                        ],
                      ),
                      child: Text(
                        '${e.value}%',
                        style: const TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  String _assetForCategory(String cat) => switch (cat) {
    'membaca' => 'assets/images/Logo_membaca.png',
    'angka' => 'assets/images/Logo_123.png',
    'benda' => 'assets/images/Logo_Benda.png',
    'iqra' => 'assets/images/Logo_iqra.png',
    _ => 'assets/images/Anak_hebat.png',
  };
}

class HeroPanel extends ConsumerWidget {
  const HeroPanel({
    required this.title,
    required this.subtitle,
    required this.asset,
    super.key,
  });
  final String title;
  final String subtitle;
  final String asset;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = ref.watch(appStateProvider).theme;
    return Container(
      constraints: const BoxConstraints(minHeight: 160),
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(34),
        color: t.widgetBg,
        border: Border.all(color: t.widgetBorder, width: 2),
        image: DecorationImage(
          image: AssetImage(asset),
          fit: BoxFit.cover,
          opacity: t.dark ? .1 : .18,
        ),
        boxShadow: [
          BoxShadow(
            blurRadius: 20,
            offset: const Offset(0, 10),
            color: t.widgetBorder.withValues(alpha: .15),
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
                  title,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    color: t.dark ? Colors.white : const Color(0xff263238),
                    letterSpacing: -.5,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: muted(context),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  color: t.widgetBorder.withValues(alpha: .1),
                ),
                child: Image.asset(asset, fit: BoxFit.contain),
              )
              .animate(onPlay: (c) => c.repeat(reverse: true))
              .moveY(begin: -5, end: 5, duration: 1800.ms),
        ],
      ),
    );
  }
}

class AppField extends StatelessWidget {
  const AppField({
    required this.controller,
    required this.label,
    required this.icon,
    this.hint,
    this.obscure = false,
    this.readOnly = false,
    this.suffix,
    super.key,
  });
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final String? hint;
  final bool obscure;
  final bool readOnly;
  final Widget? suffix;

  @override
  Widget build(BuildContext context) {
    final t = _themeOf(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        readOnly: readOnly,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: Icon(icon),
          suffixIcon: suffix,
          filled: true,
          fillColor: t.widgetBg,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(22),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(22),
            borderSide: BorderSide(color: t.widgetBorder.withValues(alpha: .2)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(22),
            borderSide: BorderSide(color: t.widgetBorder, width: 2),
          ),
        ),
      ),
    );
  }
}

class AppImage extends StatelessWidget {
  const AppImage({required this.url, this.fit = BoxFit.cover, super.key});
  final String url;
  final BoxFit fit;
  @override
  Widget build(BuildContext context) {
    if (url.trim().isEmpty) {
      return const EmptyState(text: 'Gambar belum tersedia.');
    }
    if (MediaSourceHelper.isAssetPath(url)) {
      return Image.asset(
        url,
        fit: fit,
        errorBuilder: (context, error, stackTrace) =>
            const EmptyState(text: 'Gambar belum tersedia.'),
      );
    }
    if (MediaSourceHelper.isLocalFilePath(url)) {
      return Image.file(
        File(url),
        fit: fit,
        errorBuilder: (context, error, stackTrace) =>
            const EmptyState(text: 'Gambar belum tersedia.'),
      );
    }
    return CachedNetworkImage(
      imageUrl: url,
      fit: fit,
      placeholder: (context, url) =>
          const Center(child: CircularProgressIndicator()),
      errorWidget: (context, url, error) =>
          const EmptyState(text: 'Gambar belum tersedia.'),
    );
  }
}

class ThemedBackground extends ConsumerWidget {
  const ThemedBackground({required this.child, super.key});
  final Widget child;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = ref.watch(appStateProvider).theme;
    return AnimatedContainer(
      duration: 520.ms,
      curve: Curves.easeOutCubic,
      decoration: BoxDecoration(
        color: t.bg,
        gradient: LinearGradient(
          colors: t.night
              ? [
                  NightPalette.midnight.withValues(alpha: .96),
                  NightPalette.midnight2.withValues(alpha: .94),
                  NightPalette.purple.withValues(alpha: .95),
                ]
              : [
                  t.gradientStart.withValues(alpha: .88),
                  t.gradientEnd.withValues(alpha: .88),
                ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (t.backgroundAsset != null)
            AnimatedOpacity(
              opacity: t.night ? .42 : .42,
              duration: 520.ms,
              child: Image.asset(
                t.backgroundAsset!,
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
              ),
            ),
          if (t.night) ...[
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: const Alignment(.35, -.72),
                  radius: 1.18,
                  colors: [
                    NightPalette.lavender.withValues(alpha: .22),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
            const NightSparkles(count: 26),
          ],
          child,
        ],
      ),
    );
  }
}

class PagePad extends StatelessWidget {
  const PagePad({required this.child, super.key});
  final Widget child;
  @override
  Widget build(BuildContext context) =>
      Padding(padding: const EdgeInsets.fromLTRB(18, 18, 18, 0), child: child);
}

class ResponsiveGrid extends StatelessWidget {
  const ResponsiveGrid({required this.children, super.key});
  final List<Widget> children;
  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width >= 720;
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: wide ? 2 : 1,
      mainAxisSpacing: 14,
      crossAxisSpacing: 14,
      childAspectRatio: wide ? 3.3 : 3.1,
      children: children,
    );
  }
}

class SmallMode extends StatelessWidget {
  const SmallMode(this.title, this.icon, this.onTap, {super.key});
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(28),
      onTap: onTap,
      child: Container(
        decoration: cardDecoration(context),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 10),
            Text(title, style: const TextStyle(fontWeight: FontWeight.w900)),
          ],
        ),
      ),
    );
  }
}

class HeroMascot extends StatelessWidget {
  const HeroMascot({required this.asset, required this.color, super.key});
  final String asset;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Center(
      child:
          Container(
                width: 132,
                height: 132,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: cardColor(context),
                  borderRadius: BorderRadius.circular(34),
                  border: Border.all(color: color, width: 4),
                  boxShadow: [
                    BoxShadow(
                      offset: const Offset(0, 8),
                      blurRadius: 0,
                      color: color.withValues(alpha: .3),
                    ),
                    BoxShadow(
                      blurRadius: 24,
                      offset: const Offset(0, 12),
                      color: Colors.black.withValues(alpha: .08),
                    ),
                  ],
                ),
                child: Image.asset(asset, fit: BoxFit.contain),
              )
              .animate(onPlay: (c) => c.repeat(reverse: true))
              .moveY(begin: -7, end: 7),
    );
  }
}

class EmptyState extends StatelessWidget {
  const EmptyState({required this.text, super.key});
  final String text;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.cloud_upload_outlined, size: 52, color: muted(context)),
          const SizedBox(height: 8),
          Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: muted(context),
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class RewardPill extends StatelessWidget {
  const RewardPill({required this.stars, super.key});
  final int stars;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: tactileCard(context, radius: 20),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star_rounded, color: Colors.amber, size: 22),
          Text(' $stars', style: const TextStyle(fontWeight: FontWeight.w900)),
        ],
      ),
    );
  }
}

class AdminForm extends StatelessWidget {
  const AdminForm({required this.title, required this.children, super.key});
  final String title;
  final List<Widget> children;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: tactileCard(context, radius: 26),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 14),
          ...children,
        ],
      ),
    );
  }
}

class AdminRow extends StatelessWidget {
  const AdminRow({
    required this.title,
    required this.subtitle,
    required this.onDelete,
    this.image,
    this.icon,
    super.key,
  });
  final String title;
  final String subtitle;
  final String? image;
  final IconData? icon;
  final VoidCallback onDelete;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: image == null
            ? CircleAvatar(child: Icon(icon ?? Icons.image))
            : ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: SizedBox(
                  width: 54,
                  height: 54,
                  child: AppImage(url: image!),
                ),
              ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w900)),
        subtitle: Text(subtitle, maxLines: 1, overflow: TextOverflow.ellipsis),
        trailing: IconButton(
          onPressed: onDelete,
          icon: const Icon(Icons.delete_outline),
        ),
      ),
    );
  }
}

class AudioBars extends StatelessWidget {
  const AudioBars({required this.color, super.key});
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
        18,
        (i) => Expanded(
          child:
              Container(
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    height: 12 + (i % 5) * 5,
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: .2 + (i % 4) * .14),
                      borderRadius: BorderRadius.circular(99),
                    ),
                  )
                  .animate(onPlay: (c) => c.repeat(reverse: true))
                  .scaleY(begin: .45, end: 1, duration: (420 + i * 30).ms),
        ),
      ),
    );
  }
}
