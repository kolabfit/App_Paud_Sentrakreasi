part of '../main.dart';

class SongsScreen extends ConsumerStatefulWidget {
  const SongsScreen({super.key});
  @override
  ConsumerState<SongsScreen> createState() => _SongsScreenState();
}

class _SongsScreenState extends ConsumerState<SongsScreen> {
  SongItem? selected;
  VideoPlayerController? video;

  @override
  void dispose() { video?.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final app = ref.watch(appStateProvider);
    final t = app.theme;
    final songs = app.songs;
    selected ??= songs.firstOrNull;
    final songColor = t.dark ? const Color(0xffF1C40F) : const Color(0xffE91E63);
    return PagePad(
      child: ListView(
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: songColor.withValues(alpha: .12),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(Icons.music_note_rounded, size: 24, color: songColor),
              ),
              const SizedBox(width: 12),
              Text(
                'LAGU ANAK',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 3,
                  color: songColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (selected != null) SongPlayer(song: selected!),
          const SizedBox(height: 16),
          Text(
            'Pilih Lagu',
            style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 15,
              color: t.dark ? Colors.white70 : Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 10),
          ...songs.map(
            (song) => SongTile(
              song: song,
              active: selected?.id == song.id,
              favorite: app.favorites.contains(song.id),
              onTap: () => setState(() => selected = song),
              onFav: () => ref.read(appStateProvider).toggleFavorite(song.id),
            ),
          ),
          const SizedBox(height: 110),
        ],
      ),
    );
  }
}
