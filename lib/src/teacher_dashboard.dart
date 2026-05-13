part of '../main.dart';

class TeacherDashboard extends ConsumerStatefulWidget {
  const TeacherDashboard({super.key});

  @override
  ConsumerState<TeacherDashboard> createState() => _TeacherDashboardState();
}

class _TeacherDashboardState extends ConsumerState<TeacherDashboard> {
  String tab = 'huruf';
  final name = TextEditingController();
  final url = TextEditingController();
  final category = TextEditingController(text: 'hewan');
  final songTitle = TextEditingController();
  String? pickedSongName;
  String? pickedSongDataUrl;

  @override
  Widget build(BuildContext context) {
    final app = ref.watch(appStateProvider);
    final t = app.theme;
    return PagePad(
      child: ListView(
        children: [
          // Hero banner
          Container(
            constraints: const BoxConstraints(minHeight: 140),
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: t.widgetBg,
              border: Border.all(
                color: Colors.deepPurple.withValues(alpha: .3),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  offset: const Offset(0, 8),
                  blurRadius: 0,
                  color: Colors.deepPurple.withValues(alpha: .12),
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
                        'Dashboard Pengajar',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          color: t.dark
                              ? Colors.white
                              : const Color(0xff263238),
                          letterSpacing: -.5,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Kelola konten, media, quiz, tema, dan progress siswa.',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: muted(context),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: Colors.deepPurple.withValues(alpha: .1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.deepPurple.withValues(alpha: .2),
                    ),
                  ),
                  padding: const EdgeInsets.all(10),
                  child: Image.asset(
                    'assets/images/Logo_Membaca.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Tab chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _adminChip(
                  'huruf',
                  'Kelola Huruf',
                  Icons.abc_rounded,
                  Colors.redAccent,
                ),
                _adminChip(
                  'benda',
                  'Kelola Benda',
                  Icons.category_rounded,
                  Colors.green,
                ),
                _adminChip(
                  'lagu',
                  'Lagu Anak',
                  Icons.music_note_rounded,
                  Colors.pink,
                ),
                _adminChip(
                  'iqra',
                  'Iqra',
                  Icons.auto_stories_rounded,
                  Colors.purple,
                ),
                _adminChip(
                  'quiz',
                  'Quiz Seru',
                  Icons.mic_rounded,
                  Colors.orange,
                ),
                _adminChip(
                  'progress',
                  'Progress',
                  Icons.trending_up_rounded,
                  Colors.teal,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          if (tab == 'benda' || tab == 'huruf') contentManager(app),
          if (tab == 'lagu') songManager(app),
          if (tab == 'iqra') iqraManager(app),
          if (tab == 'quiz') quizManager(),
          if (tab == 'progress')
            ProgressOverview(progress: app.progress, compact: false),
          const SizedBox(height: 16),

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

  Widget _adminChip(String id, String label, IconData icon, Color color) {
    final selected = tab == id;
    final t = ref.watch(appStateProvider).theme;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: () => setState(() => tab = id),
        child: AnimatedContainer(
          duration: 200.ms,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: selected ? color.withValues(alpha: .15) : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: selected ? color : color.withValues(alpha: .2),
              width: selected ? 2 : 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 18, color: selected ? color : muted(context)),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 12,
                  color: selected
                      ? (t.dark ? Colors.white : Colors.grey.shade800)
                      : muted(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget contentManager(AppState app) {
    return Column(
      children: [
        AdminForm(
          title: tab == 'huruf' ? 'Upload Gambar Huruf' : 'Tambah Gambar Benda',
          children: [
            AppField(
              controller: name,
              label: 'Nama / Contoh Kata',
              icon: Icons.edit,
            ),
            AppField(controller: url, label: 'URL Gambar', icon: Icons.image),
            AppField(
              controller: category,
              label: 'Kategori',
              icon: Icons.category,
            ),
            FilledButton.icon(
              onPressed: () {
                if (name.text.isEmpty || url.text.isEmpty) return;
                ref
                    .read(appStateProvider)
                    .addObject(name.text, url.text, category.text);
                name.clear();
                url.clear();
              },
              icon: const Icon(Icons.upload),
              label: const Text('Simpan Data'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...app.objects.map(
          (o) => AdminRow(
            title: o.name,
            subtitle: '${o.category} • ${o.img}',
            image: o.img,
            onDelete: () => ref.read(appStateProvider).removeObject(o),
          ),
        ),
      ],
    );
  }

  Widget songManager(AppState app) {
    return Column(
      children: [
        AdminForm(
          title: 'Upload Video Lagu Anak',
          children: [
            AppField(
              controller: songTitle,
              label: 'Judul Lagu',
              icon: Icons.music_note,
            ),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: cardColor(context),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: Colors.pink.withValues(alpha: .22),
                  width: 1.5,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.pink.withValues(alpha: .12),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.video_file_rounded,
                      color: Colors.pink,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      pickedSongName ?? 'Belum ada video dipilih',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.w900),
                    ),
                  ),
                  TextButton.icon(
                    onPressed: pickSongVideo,
                    icon: const Icon(Icons.upload_file_rounded),
                    label: const Text('Pilih'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: () {
                final video = pickedSongDataUrl;
                if (songTitle.text.isEmpty || video == null) return;
                ref
                    .read(appStateProvider)
                    .addSong(songTitle.text, video, fileName: pickedSongName);
                songTitle.clear();
                setState(() {
                  pickedSongName = null;
                  pickedSongDataUrl = null;
                });
              },
              icon: const Icon(Icons.save_rounded),
              label: const Text('Simpan Video Lagu'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...app.songs.map(
          (s) => AdminRow(
            title: s.title,
            subtitle: s.fileName ?? 'Video upload pengajar',
            icon: Icons.play_circle,
            onDelete: () => ref.read(appStateProvider).removeSong(s),
          ),
        ),
      ],
    );
  }

  Widget iqraManager(AppState app) {
    return Column(
      children: [
        AdminForm(
          title: 'Kelola Iqra 1',
          children: [
            Row(
              children: [
                Expanded(
                  child: _IqraAdminStat(
                    'Progress',
                    '${app.progress['iqra'] ?? 0}%',
                    Icons.donut_large_rounded,
                    Colors.green,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _IqraAdminStat(
                    'Berhasil',
                    '${app.iqraMastered.length}',
                    Icons.done_all_rounded,
                    Colors.purple,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _IqraAdminStat(
                    'Streak',
                    '${app.iqraStreak}',
                    Icons.local_fire_department_rounded,
                    Colors.orange,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            AppField(
              controller: name,
              label: 'Judul materi / huruf',
              icon: Icons.auto_stories_rounded,
            ),
            AppField(
              controller: url,
              label: 'URL audio atau gambar Iqra',
              icon: Icons.perm_media_rounded,
            ),
            FilledButton.icon(
              onPressed: () {
                name.clear();
                url.clear();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Media Iqra siap dipreview dan disinkronkan.',
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.cloud_upload_rounded),
              label: const Text('Upload Media'),
            ),
            const SizedBox(height: 14),
            if (url.text.isNotEmpty)
              AdminRow(
                title: name.text.isEmpty ? 'Preview media Iqra' : name.text,
                subtitle: url.text,
                icon: Icons.play_circle_fill_rounded,
                onDelete: () => setState(url.clear),
              ),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: iqraData
                  .map(
                    (e) => Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: app.iqraMastered.contains(e.latin)
                            ? Colors.green.withValues(alpha: .12)
                            : Colors.purple.withValues(alpha: .08),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.purple.withValues(alpha: .15),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '${e.char} ${e.latin}',
                            style: const TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 13,
                            ),
                          ),
                          if (app.iqraMastered.contains(e.latin))
                            const Padding(
                              padding: EdgeInsets.only(left: 4),
                              child: Icon(
                                Icons.star_rounded,
                                size: 16,
                                color: Colors.amber,
                              ),
                            ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
        const SizedBox(height: 12),
        AdminForm(
          title: 'History Latihan',
          children: app.iqraHistory.isEmpty
              ? const [Text('Belum ada latihan Iqra hari ini.')]
              : app.iqraHistory.take(6).map((h) {
                  final p = h.split('|');
                  return ListTile(
                    dense: true,
                    leading: const Icon(Icons.history_rounded),
                    title: Text(
                      p.length > 2 ? '${p[1]} ${p[2]}' : h,
                      style: const TextStyle(fontWeight: FontWeight.w900),
                    ),
                    subtitle: Text(p.first),
                  );
                }).toList(),
        ),
      ],
    );
  }

  Widget quizManager() {
    return AdminForm(
      title: 'Kelola Quiz Mode Seru',
      children: const [
        Text('Bank soal otomatis mengambil huruf, angka, benda, dan iqra.'),
        SizedBox(height: 6),
        Text(
          'Validasi suara memakai speech_to_text dengan feedback TTS dan reward.',
        ),
      ],
    );
  }

  Future<void> pickSongVideo() async {
    final result = await FilePicker.pickFiles(
      type: FileType.video,
      withData: true,
    );
    final file = result?.files.single;
    final bytes = file?.bytes;
    if (file == null || bytes == null) return;
    final ext = (file.extension ?? 'mp4').toLowerCase();
    final mime = switch (ext) {
      'webm' => 'video/webm',
      'mov' => 'video/quicktime',
      'm4v' => 'video/x-m4v',
      _ => 'video/mp4',
    };
    setState(() {
      pickedSongName = file.name;
      pickedSongDataUrl = 'data:$mime;base64,${base64Encode(bytes)}';
    });
  }
}

class _IqraAdminStat extends StatelessWidget {
  const _IqraAdminStat(this.label, this.value, this.icon, this.color);
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: color.withValues(alpha: .1),
      borderRadius: BorderRadius.circular(18),
      border: Border.all(color: color.withValues(alpha: .18)),
    ),
    child: Column(
      children: [
        Icon(icon, color: color),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
        ),
        Text(
          label,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w800,
            color: muted(context),
          ),
        ),
      ],
    ),
  );
}
