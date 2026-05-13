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
  void dispose() {
    video?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final app = ref.watch(appStateProvider);
    final t = app.theme;
    final songs = app.songs;
    if (selected == null && songs.isNotEmpty) selected = songs.first;
    if (selected != null && !songs.any((s) => s.id == selected!.id)) {
      selected = songs.isEmpty ? null : songs.first;
    }
    final songColor = t.dark
        ? const Color(0xffF1C40F)
        : const Color(0xffE91E63);
    return PagePad(
      child: ListView(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: tactileCard(context, radius: 28),
            child: Row(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: songColor.withValues(alpha: .12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Image.asset('assets/images/Logo_Lagu.png'),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Lagu Anak',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          color: songColor,
                        ),
                      ),
                      Text(
                        '${songs.length} video dari pengajar',
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          color: muted(context),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          if (selected != null)
            SongPlayer(song: selected!)
          else
            const EmptyState(
              text:
                  'Belum ada video lagu. Pengajar bisa upload dari dashboard.',
            ),
          const SizedBox(height: 16),
          if (songs.isNotEmpty) ...[
            Text(
              'Koleksi Video',
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
          ],
          const SizedBox(height: 110),
        ],
      ),
    );
  }
}
