part of '../main.dart';

enum _TeacherSection {
  dashboard,
  huruf,
  angka,
  benda,
  lagu,
  storage,
  settings,
}

enum _TeacherCategory { huruf, angka, benda, lagu }

extension on _TeacherCategory {
  String get label => switch (this) {
    _TeacherCategory.huruf => 'Abjad',
    _TeacherCategory.angka => 'Bilangan',
    _TeacherCategory.benda => 'Benda',
    _TeacherCategory.lagu => 'Lagu Anak',
  };

  String get emptyLabel => switch (this) {
    _TeacherCategory.huruf => 'Belum ada data abjad yang siap ditampilkan.',
    _TeacherCategory.angka => 'Belum ada data bilangan yang siap ditampilkan.',
    _TeacherCategory.benda => 'Belum ada benda yang tersimpan.',
    _TeacherCategory.lagu => 'Belum ada lagu anak yang tersimpan.',
  };

  IconData get icon => switch (this) {
    _TeacherCategory.huruf => Icons.sort_by_alpha_rounded,
    _TeacherCategory.angka => Icons.numbers_rounded,
    _TeacherCategory.benda => Icons.category_rounded,
    _TeacherCategory.lagu => Icons.music_note_rounded,
  };

  Color get color => switch (this) {
    _TeacherCategory.huruf => const Color(0xff8B5CF6),
    _TeacherCategory.angka => const Color(0xff38BDF8),
    _TeacherCategory.benda => const Color(0xff34D399),
    _TeacherCategory.lagu => const Color(0xffFB923C),
  };

  Color get lightColor => switch (this) {
    _TeacherCategory.huruf => const Color(0xffF3EEFF),
    _TeacherCategory.angka => const Color(0xffEAF8FF),
    _TeacherCategory.benda => const Color(0xffEBFFF6),
    _TeacherCategory.lagu => const Color(0xffFFF3E7),
  };

  String get asset => switch (this) {
    _TeacherCategory.huruf => 'assets/images/Belajar_huruf.png',
    _TeacherCategory.angka => 'assets/images/Belajar_Angka.png',
    _TeacherCategory.benda => 'assets/images/Belajar_Benda.png',
    _TeacherCategory.lagu => 'assets/images/Bernyanyi.png',
  };

}

extension on _TeacherSection {
  String get label => switch (this) {
    _TeacherSection.dashboard => 'Dashboard',
    _TeacherSection.huruf => 'Abjad',
    _TeacherSection.angka => 'Bilangan',
    _TeacherSection.benda => 'Benda',
    _TeacherSection.lagu => 'Lagu Anak',
    _TeacherSection.storage => 'Penyimpanan',
    _TeacherSection.settings => 'Pengaturan',
  };

  IconData get icon => switch (this) {
    _TeacherSection.dashboard => Icons.grid_view_rounded,
    _TeacherSection.huruf => Icons.sort_by_alpha_rounded,
    _TeacherSection.angka => Icons.numbers_rounded,
    _TeacherSection.benda => Icons.category_rounded,
    _TeacherSection.lagu => Icons.music_note_rounded,
    _TeacherSection.storage => Icons.save_rounded,
    _TeacherSection.settings => Icons.settings_rounded,
  };

  Color get color => switch (this) {
    _TeacherSection.dashboard => const Color(0xff7C3AED),
    _TeacherSection.huruf => _TeacherCategory.huruf.color,
    _TeacherSection.angka => _TeacherCategory.angka.color,
    _TeacherSection.benda => _TeacherCategory.benda.color,
    _TeacherSection.lagu => _TeacherCategory.lagu.color,
    _TeacherSection.storage => const Color(0xffF59E0B),
    _TeacherSection.settings => const Color(0xff64748B),
  };

  _TeacherCategory? get category => switch (this) {
    _TeacherSection.huruf => _TeacherCategory.huruf,
    _TeacherSection.angka => _TeacherCategory.angka,
    _TeacherSection.benda => _TeacherCategory.benda,
    _TeacherSection.lagu => _TeacherCategory.lagu,
    _ => null,
  };
}

class TeacherDashboard extends ConsumerStatefulWidget {
  const TeacherDashboard({super.key});

  @override
  ConsumerState<TeacherDashboard> createState() => _TeacherDashboardState();
}

class _TeacherDashboardState extends ConsumerState<TeacherDashboard> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  _TeacherSection _section = _TeacherSection.dashboard;
  _TeacherCategory _category = _TeacherCategory.benda;
  String _selectedFilter = 'Semua';
  String _sortMode = 'Terbaru';
  bool _sidebarCollapsed = false;
  Future<_TeacherStorageData>? _storageFuture;
  Future<int>? _userCountFuture;
  final List<_TeacherActivity> _activities = [];

  @override
  void initState() {
    super.initState();
    _storageFuture = _loadStorage();
    _userCountFuture = LocalDatabase.instance.countAccounts();
  }

  @override
  void dispose() => super.dispose();

  @override
  Widget build(BuildContext context) {
    final app = ref.watch(appStateProvider);
    final width = MediaQuery.sizeOf(context).width;
    final mobile = width < 720;
    final tablet = width >= 720 && width < 1180;
    final desktop = width >= 1180;
    final activeCategory = _section.category ?? _category;
    final notificationCount = _activityFeed(app).take(5).length;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xffF7F6FF),
      drawer: mobile
          ? Drawer(
              backgroundColor: Colors.transparent,
              elevation: 0,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 12, 12, 18),
                  child: _TeacherSidebar(
                    app: app,
                    section: _section,
                    collapsed: false,
                    onToggleCollapse: null,
                    onSelected: (section) {
                      Navigator.of(context).pop();
                      _selectSection(section);
                    },
                  ),
                ),
              ),
            )
          : null,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xffFCFBFF),
              Color(0xffF5F4FF),
              Color(0xffEFF8FF),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Row(
            children: [
              if (!mobile)
                Padding(
                  padding: const EdgeInsets.fromLTRB(18, 18, 0, 18),
                  child: _TeacherSidebar(
                    app: app,
                    section: _section,
                    collapsed: _sidebarCollapsed,
                    onToggleCollapse: () => setState(
                      () => _sidebarCollapsed = !_sidebarCollapsed,
                    ),
                    onSelected: _selectSection,
                  ),
                ),
              Expanded(
                child: Column(
                  children: [
                    _TeacherTopbar(
                      app: app,
                      mobile: mobile,
                      notificationCount: notificationCount,
                      activeCategory: activeCategory,
                      onMenuTap: () => _scaffoldKey.currentState?.openDrawer(),
                      onCollapseTap: mobile
                          ? null
                          : () => setState(
                                () => _sidebarCollapsed = !_sidebarCollapsed,
                              ),
                      onQuickUpload: () => _openUploadDialog(activeCategory),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.fromLTRB(
                          mobile ? 16 : 20,
                          6,
                          mobile ? 16 : 24,
                          24,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (_section == _TeacherSection.dashboard ||
                                _section.category != null)
                              _buildSummarySection(
                                app: app,
                                mobile: mobile,
                                desktop: desktop,
                              ),
                            if (_section == _TeacherSection.dashboard ||
                                _section.category != null) ...[
                              const SizedBox(height: 18),
                              _buildContentSection(
                                app: app,
                                activeCategory: activeCategory,
                                mobile: mobile,
                                tablet: tablet,
                                desktop: desktop,
                              ),
                              const SizedBox(height: 18),
                              desktop
                                  ? Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          flex: 7,
                                          child: _buildActivityPanel(app),
                                        ),
                                        const SizedBox(width: 18),
                                        Expanded(
                                          flex: 6,
                                          child: _buildStoragePanel(app),
                                        ),
                                      ],
                                    )
                                  : Column(
                                      children: [
                                        _buildActivityPanel(app),
                                        const SizedBox(height: 18),
                                        _buildStoragePanel(app),
                                      ],
                                    ),
                            ] else if (_section == _TeacherSection.storage) ...[
                              _buildStoragePanel(app, expanded: true),
                              const SizedBox(height: 18),
                              _buildActivityPanel(app),
                            ] else ...[
                              _buildSettingsPanel(app, mobile: mobile),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: mobile &&
              activeCategory != _TeacherCategory.huruf &&
              activeCategory != _TeacherCategory.angka
          ? FloatingActionButton.extended(
              onPressed: () => _openUploadDialog(activeCategory),
              backgroundColor: activeCategory.color,
              foregroundColor: Colors.white,
              elevation: 10,
              icon: const Icon(Icons.add_rounded),
              label: const Text(
                'Upload',
                style: TextStyle(fontWeight: FontWeight.w900),
              ),
            )
          : null,
    );
  }

  void _selectSection(_TeacherSection section) {
    setState(() {
      _section = section;
      final category = section.category;
      if (category != null) {
        _category = category;
        _selectedFilter = 'Semua';
      }
    });
  }

  List<_TeacherContentData> _itemsForCategory(
    AppState app,
    _TeacherCategory category,
  ) {
    return switch (category) {
      _TeacherCategory.huruf => app.letters
          .map(
            (group) => _TeacherContentData(
              id: group.id.isEmpty ? group.letter : group.id,
              title: group.letter,
              subtitle: group.objects.isEmpty
                  ? 'Contoh belum diisi'
                  : group.objects.first.name,
              category: 'Abjad',
              statusLabel: 'Aktif',
              mediaPath: group.objects.isEmpty
                  ? DefaultLearningCatalog.hurufPlaceholderAsset
                  : group.objects.first.img,
              color: category.color,
              icon: category.icon,
              badgeText: '',
              actionLabel: 'Edit Gambar',
              editable: true,
              letter: group,
            ),
          )
          .toList(),
      _TeacherCategory.angka => app.numbers
          .map(
            (item) => _TeacherContentData(
              id: item.id.isEmpty ? item.number : item.id,
              title: item.number,
              subtitle: item.name,
              category: 'Bilangan',
              statusLabel: 'Aktif',
              mediaPath: item.img,
              color: category.color,
              icon: category.icon,
              badgeText: '',
              actionLabel: 'Edit Gambar',
              editable: true,
              number: item,
            ),
          )
          .toList(),
      _TeacherCategory.benda => app.objects
          .map(
            (item) => _TeacherContentData(
              id: item.id.isEmpty ? item.name : item.id,
              title: item.name,
              subtitle: item.category,
              category: 'Benda',
              statusLabel: 'Aktif',
              mediaPath: item.img,
              color: category.color,
              icon: category.icon,
              badgeText: item.category,
              actionLabel: MediaSourceHelper.isLocalFilePath(item.img)
                  ? 'Lokal'
                  : 'Default',
              editable: true,
              object: item,
            ),
          )
          .toList(),
      _TeacherCategory.lagu => app.songs
          .map(
            (item) => _TeacherContentData(
              id: item.id,
              title: item.title,
              subtitle: item.fileName ?? 'Video lagu offline',
              category: 'Lagu Anak',
              statusLabel: 'Aktif',
              mediaPath: DefaultLearningCatalog.laguPlaceholderAsset,
              color: category.color,
              icon: category.icon,
              badgeText: 'Video',
              actionLabel: item.fileName ?? 'Lokal',
              editable: true,
              song: item,
            ),
          )
          .toList(),
    };
  }

  List<_TeacherContentData> _filteredItems(
    AppState app,
    _TeacherCategory category,
  ) {
    final items = _itemsForCategory(app, category).where((item) {
      final matchesFilter =
          _selectedFilter == 'Semua' ||
          item.badgeText.toLowerCase() == _selectedFilter.toLowerCase();
      return matchesFilter;
    }).toList();

    switch (_sortMode) {
      case 'A-Z':
        items.sort((a, b) => a.title.compareTo(b.title));
      case 'Kategori':
        items.sort((a, b) => a.badgeText.compareTo(b.badgeText));
      default:
        break;
    }
    return items;
  }

  List<String> _filterOptionsForCategory(
    AppState app,
    _TeacherCategory category,
  ) {
    final values = _itemsForCategory(app, category)
        .map((item) => item.badgeText)
        .where((value) => value.trim().isNotEmpty)
        .toSet()
        .toList()
      ..sort();
    return ['Semua', ...values];
  }

  Widget _buildSummarySection({
    required AppState app,
    required bool mobile,
    required bool desktop,
  }) {
    final stats = [
      _TeacherSummaryCardData(
        title: 'Total Konten',
        value:
            '${app.letters.length + app.numbers.length + app.objects.length + app.songs.length}',
        subtitle: 'Abjad, bilangan, benda, lagu',
        icon: Icons.dashboard_customize_rounded,
        color: const Color(0xff8B5CF6),
        background: const [Color(0xffF3ECFF), Color(0xffFFF7FF)],
      ),
      _TeacherSummaryCardData(
        title: 'Abjad Aktif',
        value: '${app.letters.length}',
        subtitle: 'Materi offline siap',
        icon: Icons.sort_by_alpha_rounded,
        color: const Color(0xffA855F7),
        background: const [Color(0xffF4ECFF), Color(0xffF8F4FF)],
      ),
      _TeacherSummaryCardData(
        title: 'Bilangan Aktif',
        value: '${app.numbers.length}',
        subtitle: 'Materi berhitung dasar',
        icon: Icons.numbers_rounded,
        color: const Color(0xff38BDF8),
        background: const [Color(0xffEAF9FF), Color(0xffF5FCFF)],
      ),
      _TeacherSummaryCardData(
        title: 'Benda Aktif',
        value: '${app.objects.length}',
        subtitle: 'Konten lokal tersimpan',
        icon: Icons.category_rounded,
        color: const Color(0xff34D399),
        background: const [Color(0xffECFFF6), Color(0xffF6FFFB)],
      ),
      _TeacherSummaryCardData(
        title: 'Lagu Anak',
        value: '${app.songs.length}',
        subtitle: 'Video lokal tersedia',
        icon: Icons.music_video_rounded,
        color: const Color(0xffFB923C),
        background: const [Color(0xffFFF1E8), Color(0xffFFF8F1)],
      ),
      _TeacherSummaryCardData(
        title: 'Total User',
        valueFuture: _userCountFuture,
        subtitle: 'Akun lokal terdaftar',
        icon: Icons.groups_rounded,
        color: const Color(0xffFBBF24),
        background: const [Color(0xffFFF9E7), Color(0xffFFFDF3)],
      ),
    ];

    if (mobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _TeacherSectionTitle(
            title: 'Ringkasan Dashboard',
            subtitle: 'Pantau status konten utama secara cepat.',
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 164,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: stats.length,
              separatorBuilder: (_, index) => const SizedBox(width: 12),
              itemBuilder: (_, i) => SizedBox(
                width: 230,
                child: _TeacherSummaryCard(data: stats[i]),
              ),
            ),
          ),
        ],
      );
    }

    final columns = desktop ? 3 : 2;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _TeacherSectionTitle(
          title: 'Ringkasan Dashboard',
          subtitle: 'Pantau status konten utama secara cepat.',
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
            childAspectRatio: desktop ? 2.25 : 1.95,
          ),
          itemCount: stats.length,
          itemBuilder: (_, i) => _TeacherSummaryCard(data: stats[i]),
        ),
      ],
    );
  }

  Widget _buildContentSection({
    required AppState app,
    required _TeacherCategory activeCategory,
    required bool mobile,
    required bool tablet,
    required bool desktop,
  }) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final filters = _filterOptionsForCategory(app, activeCategory);
    if (!filters.contains(_selectedFilter)) {
      _selectedFilter = 'Semua';
    }
    final items = _filteredItems(app, activeCategory);
    final columns = desktop
        ? 5
        : tablet
        ? 3
        : screenWidth < 430
        ? 1
        : 2;

    return _TeacherSurfaceCard(
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _TeacherSectionTitle(
                  title: 'Kelola Konten Pembelajaran',
                  subtitle:
                      'Fokus pada materi inti yang sudah aktif di Khoir Quest.',
                ),
              ),
              if (!mobile)
                FilledButton.icon(
                  onPressed: () => _openUploadDialog(activeCategory),
                  style: FilledButton.styleFrom(
                    backgroundColor: activeCategory.color,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  icon: const Icon(Icons.add_rounded),
                  label: const Text('Tambah Konten'),
                ),
            ],
          ),
          const SizedBox(height: 18),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _TeacherCategory.values.map((category) {
                final selected = category == activeCategory;
                return Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: _TeacherCategoryChip(
                    category: category,
                    selected: selected,
                    onTap: () {
                      setState(() {
                        _category = category;
                        if (_section != _TeacherSection.dashboard) {
                          _section = switch (category) {
                            _TeacherCategory.huruf => _TeacherSection.huruf,
                            _TeacherCategory.angka => _TeacherSection.angka,
                            _TeacherCategory.benda => _TeacherSection.benda,
                            _TeacherCategory.lagu => _TeacherSection.lagu,
                          };
                        }
                        _selectedFilter = 'Semua';
                      });
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 18),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              _TeacherDropdownField(
                label: _selectedFilter,
                icon: Icons.tune_rounded,
                items: filters,
                onSelected: (value) => setState(() => _selectedFilter = value),
              ),
              _TeacherDropdownField(
                label: _sortMode,
                icon: Icons.swap_vert_rounded,
                items: const ['Terbaru', 'A-Z', 'Kategori'],
                onSelected: (value) => setState(() => _sortMode = value),
              ),
            ],
          ),
          const SizedBox(height: 18),
          if (items.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(26),
              decoration: BoxDecoration(
                color: const Color(0xffFCFBFF),
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: const Color(0xffE8E2FF)),
              ),
              child: Column(
                children: [
                  Icon(
                    activeCategory.icon,
                    size: 48,
                    color: activeCategory.color,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    activeCategory.emptyLabel,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 16,
                      color: Color(0xff322A64),
                    ),
                  ),
                ],
              ),
            )
          else
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: columns,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                mainAxisExtent: desktop
                    ? 470
                    : tablet
                    ? 450
                    : columns == 1
                    ? 500
                    : 430,
              ),
              itemCount: items.length,
              itemBuilder: (_, i) => _TeacherContentCard(
                item: items[i],
                onEdit: items[i].editable
                    ? () => _openUploadDialog(activeCategory, existing: items[i])
                    : null,
                onUpload: items[i].editable
                    ? () => _openUploadDialog(activeCategory, existing: items[i])
                    : null,
                onDelete: items[i].editable ? () => _deleteContent(items[i]) : null,
                onReadOnlyTap: () => _showReadOnlyMessage(activeCategory),
              ).animate().fadeIn(
                    duration: 260.ms,
                    delay: Duration(milliseconds: i * 35),
                  ),
            ),
        ],
      ),
    );
  }

  Widget _buildActivityPanel(AppState app) {
    final entries = _activityFeed(app);
    return _TeacherSurfaceCard(
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _TeacherSectionTitle(
            title: 'Aktivitas Terbaru',
            subtitle: 'Perubahan konten dan progres yang baru terjadi.',
          ),
          const SizedBox(height: 10),
          ...entries.take(6).map(
            (activity) => _TeacherActivityTile(activity: activity),
          ),
        ],
      ),
    );
  }

  Widget _buildStoragePanel(AppState app, {bool expanded = false}) {
    return FutureBuilder<_TeacherStorageData>(
      future: _storageFuture,
      builder: (context, snapshot) {
        final data = snapshot.data ?? const _TeacherStorageData.loading();
        final maxSegment = data.segments.fold<int>(
          1,
          (value, item) => max(value, item.bytes),
        );
        return _TeacherSurfaceCard(
          padding: const EdgeInsets.all(22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _TeacherSectionTitle(
                title: 'Penyimpanan',
                subtitle: 'Semua media disimpan lokal agar dashboard tetap offline.',
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '${_formatBytes(data.totalBytes)} / ${_formatBytes(data.capacityBytes)}',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: Color(0xff2F2A66),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xffFFF7E8),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      '${(data.usage * 100).round()}%',
                      style: const TextStyle(
                        color: Color(0xffB7791F),
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(999),
                child: LinearProgressIndicator(
                  value: data.usage,
                  minHeight: 12,
                  backgroundColor: const Color(0xffEEE8FF),
                  color: const Color(0xff8B5CF6),
                ),
              ),
              const SizedBox(height: 18),
              if (expanded)
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: data.segments.map((segment) {
                    return _TeacherStorageChip(segment: segment);
                  }).toList(),
                )
              else
                Column(
                  children: data.segments
                      .map(
                        (segment) => _TeacherStorageRow(
                          segment: segment,
                          maxBytes: maxSegment,
                        ),
                      )
                      .toList(),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSettingsPanel(AppState app, {required bool mobile}) {
    return _TeacherSurfaceCard(
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _TeacherSectionTitle(
            title: 'Pengaturan Dashboard',
            subtitle:
                'Atur tampilan, mode kerja pengajar, dan akses keluar akun.',
          ),
          const SizedBox(height: 16),
          _TeacherSurfaceCard(
            padding: const EdgeInsets.all(18),
            inner: true,
            child: Wrap(
              spacing: 14,
              runSpacing: 14,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Container(
                  width: 64,
                  height: 64,
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: const Color(0xffEEE8FF),
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: Image.asset(
                      app.gender == Gender.girl
                          ? 'assets/images/profil_perempuan.png'
                          : 'assets/images/profil_lakilaki.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(
                  width: mobile ? 180 : 260,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        app.childName.trim().isEmpty ? 'Pengajar' : app.childName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          color: Color(0xff2E2963),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        app.email ?? 'akun lokal',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Color(0xff6F6A95),
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
                const _TeacherRolePill(),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Tema Cepat',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: const Color(0xff2E2963),
                  fontWeight: FontWeight.w900,
                ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: appThemes.take(mobile ? 4 : appThemes.length).map((theme) {
              final selected = theme.id == app.themeId;
              return GestureDetector(
                onTap: () => ref.read(appStateProvider).setTheme(theme.id),
                child: AnimatedContainer(
                  duration: 220.ms,
                  width: mobile ? 142 : 168,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: selected
                        ? theme.primary.withValues(alpha: .12)
                        : Colors.white.withValues(alpha: .72),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: selected
                          ? theme.primary
                          : const Color(0xffE7E2FF),
                      width: selected ? 2 : 1.2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 16,
                        offset: const Offset(0, 10),
                        color: theme.primary.withValues(alpha: .10),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: Image.asset(
                          theme.asset,
                          height: 76,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        theme.name,
                        style: TextStyle(
                          color: selected
                              ? theme.primary
                              : const Color(0xff302B64),
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          OutlinedButton.icon(
            onPressed: () => ref.read(appStateProvider).logout(),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(56),
              side: const BorderSide(color: Color(0xffFF6B81)),
              foregroundColor: const Color(0xffFF4D6D),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
            ),
            icon: const Icon(Icons.logout_rounded),
            label: const Text('Keluar dari Dashboard Pengajar'),
          ),
        ],
      ),
    );
  }

  Future<void> _openUploadDialog(
    _TeacherCategory category, {
    _TeacherContentData? existing,
  }) async {
    if ((category == _TeacherCategory.huruf ||
            category == _TeacherCategory.angka) &&
        existing == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: category.color,
          content: Text(
            '${category.label} bawaan hanya bisa diganti gambarnya, bukan tambah simbol baru.',
          ),
        ),
      );
      return;
    }

    final result = await showDialog<_TeacherDraftResult>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: .18),
      builder: (_) => _TeacherUploadDialog(
        category: category,
        existing: existing,
      ),
    );
    if (result == null || !mounted) return;

    final appState = ref.read(appStateProvider);
    if (category == _TeacherCategory.huruf) {
      final previousPath = existing?.letter?.objects.isNotEmpty == true
          ? existing!.letter!.objects.first.img
          : null;
      await appState.saveLetter(
        letter: existing?.letter?.letter ?? result.title,
        example: result.subtitle,
        imagePath: result.mediaPath,
        existingId: existing?.letter?.id,
      );
      if (previousPath != null &&
          previousPath != result.mediaPath &&
          MediaSourceHelper.isLocalFilePath(previousPath)) {
        await LocalDatabase.instance.deleteFile(previousPath);
      }
      _pushActivity(
        title: existing == null
            ? 'Menambahkan huruf baru: ${result.title}'
            : 'Memperbarui huruf: ${result.title}',
        subtitle: result.subtitle,
        icon: Icons.sort_by_alpha_rounded,
        color: _TeacherCategory.huruf.color,
      );
    } else if (category == _TeacherCategory.angka) {
      final previousPath = existing?.number?.img;
      await appState.saveNumber(
        number: existing?.number?.number ?? result.title,
        name: result.subtitle,
        imagePath: result.mediaPath,
        existingId: existing?.number?.id,
      );
      if (previousPath != null &&
          previousPath != result.mediaPath &&
          MediaSourceHelper.isLocalFilePath(previousPath)) {
        await LocalDatabase.instance.deleteFile(previousPath);
      }
      _pushActivity(
        title: existing == null
            ? 'Menambahkan angka baru: ${result.title}'
            : 'Memperbarui angka: ${result.title}',
        subtitle: result.subtitle,
        icon: Icons.numbers_rounded,
        color: _TeacherCategory.angka.color,
      );
    } else if (category == _TeacherCategory.benda) {
      final previousPath = existing?.object?.img;
      if (existing?.object != null) {
        await appState.removeObject(
          existing!.object!,
          deleteMedia: previousPath != result.mediaPath,
        );
      }
      await appState.addObject(
        result.title,
        result.mediaPath,
        result.subtitle.isEmpty ? 'umum' : result.subtitle,
      );
      if (previousPath != null &&
          previousPath != result.mediaPath &&
          MediaSourceHelper.isLocalFilePath(previousPath)) {
        await LocalDatabase.instance.deleteFile(previousPath);
      }
      _pushActivity(
        title: existing == null
            ? 'Menambahkan benda baru: ${result.title}'
            : 'Memperbarui benda: ${result.title}',
        subtitle: result.subtitle.isEmpty ? 'Kategori umum' : result.subtitle,
        icon: Icons.category_rounded,
        color: _TeacherCategory.benda.color,
      );
    } else {
      final previousPath = existing?.song?.videoUrl;
      if (existing?.song != null) {
        await appState.removeSong(
          existing!.song!,
          deleteMedia: previousPath != result.mediaPath,
        );
      }
      await appState.addSong(
        result.title,
        result.mediaPath,
        fileName: result.fileName,
      );
      if (previousPath != null &&
          previousPath != result.mediaPath &&
          MediaSourceHelper.isLocalFilePath(previousPath)) {
        await LocalDatabase.instance.deleteFile(previousPath);
      }
      _pushActivity(
        title: existing == null
            ? 'Mengunggah lagu baru: ${result.title}'
            : 'Memperbarui lagu: ${result.title}',
        subtitle: result.fileName ?? 'Video lokal',
        icon: Icons.music_note_rounded,
        color: _TeacherCategory.lagu.color,
      );
    }
    _refreshStorage();
  }

  Future<void> _deleteContent(_TeacherContentData item) async {
    final appState = ref.read(appStateProvider);
    if (item.letter != null) {
      await appState.removeLetter(item.letter!);
      _pushActivity(
        title: 'Menghapus huruf: ${item.title}',
        subtitle: item.subtitle,
        icon: Icons.delete_outline_rounded,
        color: const Color(0xffF43F5E),
      );
    } else if (item.number != null) {
      await appState.removeNumber(item.number!);
      _pushActivity(
        title: 'Menghapus angka: ${item.title}',
        subtitle: item.subtitle,
        icon: Icons.delete_outline_rounded,
        color: const Color(0xffF43F5E),
      );
    } else if (item.object != null) {
      await appState.removeObject(item.object!);
      _pushActivity(
        title: 'Menghapus benda: ${item.title}',
        subtitle: item.subtitle,
        icon: Icons.delete_outline_rounded,
        color: const Color(0xffF43F5E),
      );
    } else if (item.song != null) {
      await appState.removeSong(item.song!);
      _pushActivity(
        title: 'Menghapus lagu: ${item.title}',
        subtitle: item.subtitle,
        icon: Icons.delete_outline_rounded,
        color: const Color(0xffF43F5E),
      );
    }
    _refreshStorage();
  }

  void _showReadOnlyMessage(_TeacherCategory category) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: category.color,
        content: Text(
          '${category.label} siap diubah dari dashboard pengajar.',
        ),
      ),
    );
  }

  void _pushActivity({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
  }) {
    setState(() {
      _activities.insert(
        0,
        _TeacherActivity(
          title: title,
          subtitle: subtitle,
          timestamp: DateTime.now(),
          icon: icon,
          color: color,
        ),
      );
    });
  }

  List<_TeacherActivity> _activityFeed(AppState app) {
    if (_activities.isNotEmpty) return _activities;
    return [
      _TeacherActivity(
        title: 'Konten benda siap digunakan',
        subtitle: '${app.objects.length} item lokal tersedia untuk belajar.',
        timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
        icon: Icons.inventory_2_rounded,
        color: _TeacherCategory.benda.color,
      ),
      _TeacherActivity(
        title: 'Lagu anak siap diputar',
        subtitle: '${app.songs.length} media lokal tersimpan.',
        timestamp: DateTime.now().subtract(const Duration(minutes: 12)),
        icon: Icons.music_video_rounded,
        color: _TeacherCategory.lagu.color,
      ),
      _TeacherActivity(
        title: 'Dashboard offline aktif',
        subtitle: 'Semua konten tetap bisa dikelola tanpa internet.',
        timestamp: DateTime.now().subtract(const Duration(hours: 1)),
        icon: Icons.cloud_done_rounded,
        color: const Color(0xff0EA5E9),
      ),
    ];
  }

  void _refreshStorage() {
    setState(() {
      _storageFuture = _loadStorage();
    });
  }

  Future<_TeacherStorageData> _loadStorage() async {
    final app = ref.read(appStateProvider);
    const capacity = 5 * 1024 * 1024 * 1024;
    final seen = <String>{};
    int imageBytes = 0;
    int videoBytes = 0;
    int audioBytes = 0;

    for (final item in app.objects) {
      imageBytes += await _measureMedia(item.img, seen);
    }
    for (final song in app.songs) {
      videoBytes += await _measureMedia(song.videoUrl, seen);
    }
    audioBytes += await _measureMedia(
      DefaultLearningCatalog.hurufPlaceholderAsset,
      seen,
    );

    final total = imageBytes + audioBytes + videoBytes;
    return _TeacherStorageData(
      totalBytes: total,
      capacityBytes: capacity,
      segments: [
        _TeacherStorageSegment(
          label: 'Gambar',
          bytes: imageBytes,
          color: const Color(0xff8B5CF6),
          icon: Icons.image_rounded,
        ),
        _TeacherStorageSegment(
          label: 'Audio',
          bytes: audioBytes,
          color: const Color(0xff22C55E),
          icon: Icons.audiotrack_rounded,
        ),
        _TeacherStorageSegment(
          label: 'Video',
          bytes: videoBytes,
          color: const Color(0xff38BDF8),
          icon: Icons.video_library_rounded,
        ),
      ],
    );
  }

  Future<int> _measureMedia(String path, Set<String> seen) async {
    if (path.trim().isEmpty || MediaSourceHelper.isAssetPath(path)) return 0;
    if (!seen.add(path)) return 0;
    if (MediaSourceHelper.isDataUri(path)) {
      final payload = path.split(',').last;
      return (payload.length * 0.75).round();
    }
    if (MediaSourceHelper.isLocalFilePath(path) && !kIsWeb) {
      final file = File(path);
      if (await file.exists()) {
        return file.length();
      }
    }
    return 0;
  }

  String _formatBytes(int bytes) {
    if (bytes <= 0) return '0 B';
    const units = ['B', 'KB', 'MB', 'GB', 'TB'];
    double value = bytes.toDouble();
    var unitIndex = 0;
    while (value >= 1024 && unitIndex < units.length - 1) {
      value /= 1024;
      unitIndex++;
    }
    final digits = value >= 100 ? 0 : value >= 10 ? 1 : 2;
    return '${value.toStringAsFixed(digits)} ${units[unitIndex]}';
  }
}

class _TeacherSidebar extends StatelessWidget {
  const _TeacherSidebar({
    required this.app,
    required this.section,
    required this.collapsed,
    required this.onToggleCollapse,
    required this.onSelected,
  });

  final AppState app;
  final _TeacherSection section;
  final bool collapsed;
  final VoidCallback? onToggleCollapse;
  final ValueChanged<_TeacherSection> onSelected;

  @override
  Widget build(BuildContext context) {
    final items = [
      _TeacherSection.dashboard,
      _TeacherSection.huruf,
      _TeacherSection.angka,
      _TeacherSection.benda,
      _TeacherSection.lagu,
      _TeacherSection.storage,
      _TeacherSection.settings,
    ];

    return AnimatedContainer(
      duration: 260.ms,
      width: collapsed ? 96 : 276,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(34),
        gradient: const LinearGradient(
          colors: [Color(0xffFFFFFF), Color(0xffF6F2FF), Color(0xffEFF9FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: Colors.white, width: 1.6),
        boxShadow: [
          BoxShadow(
            blurRadius: 34,
            offset: const Offset(0, 16),
            color: const Color(0xff8262FF).withValues(alpha: .14),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(34),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 20, 18, 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: collapsed ? 8 : 14,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xff8B5CF6), Color(0xffA78BFA)],
                    ),
                    borderRadius: BorderRadius.circular(26),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 24,
                        color: const Color(0xff8B5CF6).withValues(alpha: .25),
                      ),
                    ],
                  ),
                  child: collapsed
                      ? Center(
                          child: Image.asset(
                            'assets/images/Logo_Aplikasi.png',
                            width: 40,
                            height: 40,
                            fit: BoxFit.contain,
                          ),
                        )
                      : Row(
                          children: [
                            Image.asset(
                              'assets/images/Logo_Aplikasi.png',
                              width: 56,
                              height: 56,
                              fit: BoxFit.contain,
                            ),
                            const SizedBox(width: 12),
                            const Expanded(
                              child: Text(
                                'Khoir Quest',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                          ],
                        ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: ListView.separated(
                    itemCount: items.length,
                    separatorBuilder: (_, index) => const SizedBox(height: 8),
                    itemBuilder: (_, i) {
                      final item = items[i];
                      final selected = item == section;
                      return _TeacherSidebarTile(
                        item: item,
                        selected: selected,
                        collapsed: collapsed,
                        onTap: () => onSelected(item),
                      );
                    },
                  ),
                ),
                if (onToggleCollapse != null) ...[
                  const SizedBox(height: 12),
                  Align(
                    alignment: collapsed
                        ? Alignment.center
                        : Alignment.centerRight,
                    child: IconButton(
                      onPressed: onToggleCollapse,
                      style: IconButton.styleFrom(
                        backgroundColor: const Color(0xffF3EEFF),
                        foregroundColor: const Color(0xff7C3AED),
                      ),
                      icon: Icon(
                        collapsed
                            ? Icons.chevron_right_rounded
                            : Icons.chevron_left_rounded,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TeacherSidebarTile extends StatelessWidget {
  const _TeacherSidebarTile({
    required this.item,
    required this.selected,
    required this.collapsed,
    required this.onTap,
  });

  final _TeacherSection item;
  final bool selected;
  final bool collapsed;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: onTap,
      child: AnimatedContainer(
        duration: 220.ms,
        padding: EdgeInsets.symmetric(
          horizontal: collapsed ? 10 : 14,
          vertical: 12,
        ),
        decoration: BoxDecoration(
          gradient: selected
              ? LinearGradient(
                  colors: [
                    item.color,
                    item.color.withValues(alpha: .78),
                  ],
                )
              : null,
          color: selected ? null : Colors.transparent,
          borderRadius: BorderRadius.circular(22),
          boxShadow: selected
              ? [
                  BoxShadow(
                    blurRadius: 20,
                    color: item.color.withValues(alpha: .25),
                  ),
                ]
              : null,
        ),
        child: collapsed
            ? Center(
                child: Icon(
                  item.icon,
                  color: selected ? Colors.white : item.color,
                  size: 24,
                ),
              )
            : Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: selected
                          ? Colors.white.withValues(alpha: .20)
                          : item.color.withValues(alpha: .12),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(
                      item.icon,
                      color: selected ? Colors.white : item.color,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      item.label,
                      style: TextStyle(
                        color: selected
                            ? Colors.white
                            : const Color(0xff2D275B),
                        fontWeight: FontWeight.w900,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  if (selected)
                    Container(
                      width: 8,
                      height: 28,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: .85),
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                ],
              ),
      ),
    );
  }
}

class _TeacherTopbar extends StatelessWidget {
  const _TeacherTopbar({
    required this.app,
    required this.mobile,
    required this.notificationCount,
    required this.activeCategory,
    required this.onMenuTap,
    required this.onCollapseTap,
    required this.onQuickUpload,
  });

  final AppState app;
  final bool mobile;
  final int notificationCount;
  final _TeacherCategory activeCategory;
  final VoidCallback onMenuTap;
  final VoidCallback? onCollapseTap;
  final VoidCallback onQuickUpload;

  @override
  Widget build(BuildContext context) {
    final teacherName = app.childName.trim().isEmpty ? 'Pengajar' : app.childName;
    return Padding(
      padding: EdgeInsets.fromLTRB(mobile ? 16 : 20, 18, mobile ? 16 : 24, 12),
      child: _TeacherSurfaceCard(
        padding: EdgeInsets.symmetric(
          horizontal: mobile ? 14 : 18,
          vertical: 14,
        ),
        child: Wrap(
          spacing: 12,
          runSpacing: 12,
          crossAxisAlignment: WrapCrossAlignment.center,
          alignment: WrapAlignment.spaceBetween,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (mobile)
                  IconButton(
                    onPressed: onMenuTap,
                    style: IconButton.styleFrom(
                      backgroundColor: const Color(0xffF2EEFF),
                      foregroundColor: const Color(0xff7C3AED),
                    ),
                    icon: const Icon(Icons.menu_rounded),
                  )
                else if (onCollapseTap != null)
                  IconButton(
                    onPressed: onCollapseTap,
                    style: IconButton.styleFrom(
                      backgroundColor: const Color(0xffF2EEFF),
                      foregroundColor: const Color(0xff7C3AED),
                    ),
                    icon: const Icon(Icons.space_dashboard_rounded),
                  ),
                const SizedBox(width: 10),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: activeCategory.lightColor,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        activeCategory.asset,
                        width: 28,
                        height: 28,
                        fit: BoxFit.contain,
                      ),
                      if (!mobile) ...[
                        const SizedBox(width: 8),
                        Text(
                          'Panel Pengajar',
                          style: TextStyle(
                            color: activeCategory.color,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!mobile &&
                    activeCategory != _TeacherCategory.huruf &&
                    activeCategory != _TeacherCategory.angka)
                  FilledButton.icon(
                    onPressed: onQuickUpload,
                    style: FilledButton.styleFrom(
                      backgroundColor: activeCategory.color,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 15,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(22),
                      ),
                    ),
                    icon: const Icon(Icons.file_upload_rounded),
                    label: const Text('Quick Upload'),
                  ),
                if (!mobile) const SizedBox(width: 12),
                _TeacherNotificationButton(count: notificationCount),
                const SizedBox(width: 12),
                _TeacherProfilePill(
                  name: teacherName,
                  compact: mobile,
                  gender: app.gender,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TeacherSummaryCard extends StatelessWidget {
  const _TeacherSummaryCard({required this.data});

  final _TeacherSummaryCardData data;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: data.background,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white, width: 1.8),
        boxShadow: [
          BoxShadow(
            blurRadius: 18,
            offset: const Offset(0, 12),
            color: data.color.withValues(alpha: .12),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  Colors.white,
                  data.color.withValues(alpha: .20),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  blurRadius: 16,
                  color: data.color.withValues(alpha: .18),
                ),
              ],
            ),
            child: Icon(data.icon, color: data.color, size: 30),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                data.value != null
                    ? Text(
                        data.value!,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                          color: Color(0xff2F2966),
                        ),
                      )
                    : FutureBuilder<int>(
                        future: data.valueFuture,
                        builder: (_, snapshot) => Text(
                          '${snapshot.data ?? 0}',
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                            color: Color(0xff2F2966),
                          ),
                        ),
                      ),
                const SizedBox(height: 4),
                Text(
                  data.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    color: Color(0xff342D6B),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  data.subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xff6D6A95),
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TeacherCategoryChip extends StatelessWidget {
  const _TeacherCategoryChip({
    required this.category,
    required this.selected,
    required this.onTap,
  });

  final _TeacherCategory category;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: onTap,
      child: AnimatedContainer(
        duration: 220.ms,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          gradient: selected
              ? LinearGradient(
                  colors: [category.color, category.color.withValues(alpha: .78)],
                )
              : null,
          color: selected ? null : category.lightColor,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: selected ? category.color : category.color.withValues(alpha: .18),
            width: selected ? 1.8 : 1.2,
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    blurRadius: 16,
                    color: category.color.withValues(alpha: .20),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              category.icon,
              size: 18,
              color: selected ? Colors.white : category.color,
            ),
            const SizedBox(width: 8),
            Text(
              category.label,
              style: TextStyle(
                color: selected ? Colors.white : const Color(0xff2F2966),
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TeacherContentCard extends StatelessWidget {
  const _TeacherContentCard({
    required this.item,
    required this.onEdit,
    required this.onUpload,
    required this.onDelete,
    required this.onReadOnlyTap,
  });

  final _TeacherContentData item;
  final VoidCallback? onEdit;
  final VoidCallback? onUpload;
  final VoidCallback? onDelete;
  final VoidCallback onReadOnlyTap;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 220;
        return Container(
          padding: EdgeInsets.all(compact ? 12 : 14),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: .90),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: Colors.white, width: 1.5),
            boxShadow: [
              BoxShadow(
                blurRadius: 18,
                offset: const Offset(0, 10),
                color: item.color.withValues(alpha: .10),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: compact ? 190 : 240,
                width: double.infinity,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(22),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          item.color.withValues(alpha: .08),
                          item.color.withValues(alpha: .02),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: item.mediaPath.isEmpty
                        ? Padding(
                            padding: EdgeInsets.all(compact ? 10 : 12),
                            child: Image.asset(
                              item.category == 'Abjad'
                                  ? _TeacherCategory.huruf.asset
                                  : item.category == 'Bilangan'
                                  ? _TeacherCategory.angka.asset
                                  : item.category == 'Benda'
                                  ? _TeacherCategory.benda.asset
                                  : _TeacherCategory.lagu.asset,
                              fit: BoxFit.contain,
                            ),
                          )
                        : AppImage(url: item.mediaPath, fit: BoxFit.cover),
                  ),
                ),
              ),
              SizedBox(height: compact ? 10 : 14),
              Text(
                item.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: compact ? 16 : 18,
                  fontWeight: FontWeight.w900,
                  color: const Color(0xff2F2966),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                item.subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: const Color(0xff6D6A95),
                  fontWeight: FontWeight.w800,
                  fontSize: compact ? 12 : 13,
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _TeacherStatusPill(
                    label: item.statusLabel,
                    background: const Color(0xffEAFBF2),
                    foreground: const Color(0xff1F9D57),
                  ),
                  if (item.badgeText.trim().isNotEmpty)
                    _TeacherStatusPill(
                      label: item.badgeText,
                      background: item.color.withValues(alpha: .10),
                      foreground: item.color,
                    ),
                ],
              ),
              const SizedBox(height: 12),
              item.editable
                  ? Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _TeacherActionButton(
                          icon: Icons.edit_rounded,
                          color: const Color(0xff8B5CF6),
                          onTap: onEdit!,
                        ),
                        _TeacherActionButton(
                          icon: item.song == null
                              ? Icons.photo_size_select_large_rounded
                              : Icons.video_file_rounded,
                          color: const Color(0xff38BDF8),
                          onTap: onUpload!,
                        ),
                        _TeacherActionButton(
                          icon: Icons.delete_outline_rounded,
                          color: const Color(0xffFB7185),
                          onTap: onDelete!,
                        ),
                      ],
                    )
                  : SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: onReadOnlyTap,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: item.color,
                          side: BorderSide(
                            color: item.color.withValues(alpha: .22),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        icon: const Icon(Icons.remove_red_eye_outlined, size: 18),
                        label: Text(item.actionLabel),
                      ),
                    ),
            ],
          ),
        );
      },
    );
  }
}

class _TeacherUploadDialog extends StatefulWidget {
  const _TeacherUploadDialog({
    required this.category,
    this.existing,
  });

  final _TeacherCategory category;
  final _TeacherContentData? existing;

  @override
  State<_TeacherUploadDialog> createState() => _TeacherUploadDialogState();
}

class _TeacherUploadDialogState extends State<_TeacherUploadDialog> {
  late final TextEditingController _title;
  late final TextEditingController _subtitle;
  String? _fileName;
  String? _mediaPath;
  bool _saving = false;

  bool get _isSong => widget.category == _TeacherCategory.lagu;
  bool get _isHuruf => widget.category == _TeacherCategory.huruf;
  bool get _isAngka => widget.category == _TeacherCategory.angka;

  @override
  void initState() {
    super.initState();
    _title = TextEditingController(
      text: widget.existing?.letter?.letter ??
          widget.existing?.number?.number ??
          widget.existing?.title ??
          '',
    );
    _subtitle = TextEditingController(
      text: widget.existing?.letter?.objects.isNotEmpty == true
          ? widget.existing!.letter!.objects.first.name
          : widget.existing?.number?.name ??
              widget.existing?.object?.category ??
              '',
    );
    _fileName = widget.existing?.song?.fileName;
    _mediaPath =
        widget.existing?.letter?.objects.isNotEmpty == true
            ? widget.existing!.letter!.objects.first.img
            : widget.existing?.number?.img ??
                widget.existing?.object?.img ??
                widget.existing?.song?.videoUrl;
  }

  @override
  void dispose() {
    _title.dispose();
    _subtitle.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final accent = widget.category.color;
    final mediaWidth = MediaQuery.sizeOf(context).width;
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.fromLTRB(
        18,
        18,
        18,
        max(18, MediaQuery.viewInsetsOf(context).bottom + 18),
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 560,
          maxHeight: MediaQuery.sizeOf(context).height * .88,
        ),
        child: _TeacherSurfaceCard(
          padding: const EdgeInsets.all(22),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: accent.withValues(alpha: .12),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Icon(widget.category.icon, color: accent),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.existing == null
                                ? 'Tambah ${widget.category.label}'
                                : 'Edit ${widget.category.label}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                              color: Color(0xff2F2966),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _isSong
                                ? 'Upload video lagu anak lokal untuk dashboard offline.'
                                : _isHuruf
                                    ? 'Atur abjad, contoh benda, dan gambar preview secara terpisah.'
                                    : _isAngka
                                        ? 'Atur bilangan, nama bilangan, dan gambar preview.'
                                        : 'Simpan benda baru beserta gambar lokalnya.',
                            style: const TextStyle(
                              color: Color(0xff6D6A95),
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                AppField(
                  controller: _title,
                  label: _isSong
                      ? 'Judul Lagu'
                      : _isHuruf
                          ? 'Abjad'
                          : _isAngka
                              ? 'Bilangan'
                              : 'Nama Benda',
                  icon: _isSong
                      ? Icons.music_note_rounded
                      : _isAngka
                          ? Icons.numbers_rounded
                          : Icons.edit_rounded,
                  readOnly: _isHuruf || _isAngka,
                ),
                if (!_isSong)
                  AppField(
                    controller: _subtitle,
                    label: _isHuruf
                        ? 'Contoh Benda'
                        : _isAngka
                            ? 'Nama Bilangan'
                            : 'Kategori',
                    icon: _isHuruf
                        ? Icons.lightbulb_outline_rounded
                        : _isAngka
                            ? Icons.record_voice_over_rounded
                            : Icons.category_rounded,
                    hint: _isHuruf
                        ? 'contoh: Apel, Bola, Cicak'
                        : _isAngka
                            ? 'contoh: Satu, Dua, Tiga'
                            : 'contoh: makanan, hewan, sekolah',
                  ),
                const SizedBox(height: 4),
                GestureDetector(
                  onTap: _pickMedia,
                  child: AnimatedContainer(
                    duration: 220.ms,
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: accent.withValues(alpha: .06),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: accent.withValues(alpha: .35),
                        width: 1.4,
                      ),
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: 112,
                          height: 112,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(22),
                          ),
                          child: !_isSong && _mediaPath != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(22),
                                  child: AppImage(
                                    url: _mediaPath!,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : Image.asset(
                                  _isSong
                                      ? _TeacherCategory.lagu.asset
                                      : _isHuruf
                                          ? _TeacherCategory.huruf.asset
                                          : _isAngka
                                              ? _TeacherCategory.angka.asset
                                              : _TeacherCategory.benda.asset,
                                  fit: BoxFit.contain,
                                ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          _isSong
                              ? 'Tap untuk pilih video lagu'
                              : _isHuruf
                                  ? 'Tap untuk pilih gambar huruf'
                                  : _isAngka
                                      ? 'Tap untuk pilih gambar angka'
                                      : 'Tap untuk pilih gambar benda',
                          style: const TextStyle(
                            fontWeight: FontWeight.w900,
                            color: Color(0xff2F2966),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          _fileName ??
                              (_mediaPath == null
                                  ? 'Belum ada file dipilih'
                                  : _mediaPath!),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Color(0xff6D6A95),
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (_mediaPath != null && !_isSong) ...[
                  const SizedBox(height: 14),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: SizedBox(
                      height: mediaWidth < 420 ? 320 : 420,
                      width: double.infinity,
                      child: AppImage(url: _mediaPath!, fit: BoxFit.cover),
                    ),
                  ),
                ],
                const SizedBox(height: 18),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    SizedBox(
                      width: mediaWidth < 420 ? double.infinity : 220,
                      child: OutlinedButton(
                        onPressed: _saving ? null : () => Navigator.of(context).pop(),
                        child: const Text('Batal'),
                      ),
                    ),
                    SizedBox(
                      width: mediaWidth < 420 ? double.infinity : 220,
                      child: FilledButton.icon(
                        onPressed: _saving ? null : _submit,
                        style: FilledButton.styleFrom(
                          backgroundColor: accent,
                          foregroundColor: Colors.white,
                        ),
                        icon: _saving
                            ? const SizedBox.square(
                                dimension: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Icon(Icons.save_rounded),
                        label: Text(
                          widget.existing == null ? 'Simpan Konten' : 'Update Konten',
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _pickMedia() async {
    final result = await FilePicker.pickFiles(
      type: _isSong ? FileType.video : FileType.image,
      withData: true,
    );
    final file = result?.files.single;
    final bytes = file?.bytes;
    if (file == null || bytes == null) return;

    final savedPath = _isSong
        ? await LocalDatabase.instance.saveVideoBytes(
            bytes: bytes,
            fileName: file.name,
          )
        : await LocalDatabase.instance.saveImageBytes(
            bytes: bytes,
            fileName: file.name,
            bucket: _isHuruf || _isAngka
                ? StorageBucket.hurufImages
                : StorageBucket.bendaImages,
          );
    if (!mounted) return;
    setState(() {
      _fileName = file.name;
      _mediaPath = savedPath;
    });
  }

  Future<void> _submit() async {
    if (_title.text.trim().isEmpty) return;
    if (!_isSong && _subtitle.text.trim().isEmpty) return;
    if ((_mediaPath ?? '').trim().isEmpty) return;
    setState(() => _saving = true);
    Navigator.of(context).pop(
      _TeacherDraftResult(
        title: _title.text.trim(),
        subtitle: _subtitle.text.trim(),
        mediaPath: _mediaPath!.trim(),
        fileName: _fileName,
      ),
    );
  }
}

class _TeacherNotificationButton extends StatelessWidget {
  const _TeacherNotificationButton({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: .85),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xffEBE5FF)),
          ),
          child: const Icon(
            Icons.notifications_none_rounded,
            color: Color(0xff7C3AED),
          ),
        ),
        if (count > 0)
          Positioned(
            right: -2,
            top: -4,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
              decoration: const BoxDecoration(
                color: Color(0xffFF5D73),
                borderRadius: BorderRadius.all(Radius.circular(999)),
              ),
              child: Text(
                '$count',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _TeacherProfilePill extends StatelessWidget {
  const _TeacherProfilePill({
    required this.name,
    required this.gender,
    this.compact = false,
  });

  final String name;
  final Gender gender;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 8 : 10,
        vertical: compact ? 6 : 8,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .86),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xffECE7FF)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 42,
            height: 42,
            padding: const EdgeInsets.all(2),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [Color(0xff8B5CF6), Color(0xff60A5FA)],
              ),
            ),
            child: ClipOval(
              child: Image.asset(
                gender == Gender.girl
                    ? 'assets/images/profil_perempuan.png'
                    : 'assets/images/profil_lakilaki.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          if (!compact) ...[
            const SizedBox(width: 10),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 124),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xff2F2966),
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const _TeacherRolePill(compact: true),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _TeacherRolePill extends StatelessWidget {
  const _TeacherRolePill({this.compact = false});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 8 : 12,
        vertical: compact ? 4 : 8,
      ),
      decoration: BoxDecoration(
        color: const Color(0xffEFE8FF),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        'Pengajar',
        style: TextStyle(
          color: const Color(0xff7C3AED),
          fontWeight: FontWeight.w900,
          fontSize: compact ? 11 : 12,
        ),
      ),
    );
  }
}

class _TeacherSectionTitle extends StatelessWidget {
  const _TeacherSectionTitle({
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: const Color(0xff2F2966),
                fontWeight: FontWeight.w900,
              ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: const TextStyle(
            color: Color(0xff6D6A95),
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}


class _TeacherDropdownField extends StatelessWidget {
  const _TeacherDropdownField({
    required this.label,
    required this.icon,
    required this.items,
    required this.onSelected,
  });

  final String label;
  final IconData icon;
  final List<String> items;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: onSelected,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      itemBuilder: (_) => items
          .map((item) => PopupMenuItem<String>(value: item, child: Text(item)))
          .toList(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: .80),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xffE9E4FF)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: const Color(0xff8B5CF6)),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: Color(0xff2F2966),
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.expand_more_rounded, color: Color(0xff7C3AED)),
          ],
        ),
      ),
    );
  }
}

class _TeacherStatusPill extends StatelessWidget {
  const _TeacherStatusPill({
    required this.label,
    required this.background,
    required this.foreground,
  });

  final String label;
  final Color background;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: foreground,
          fontWeight: FontWeight.w900,
          fontSize: 12,
        ),
      ),
    );
  }
}

class _TeacherActionButton extends StatelessWidget {
  const _TeacherActionButton({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Ink(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: color.withValues(alpha: .10),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Icon(icon, color: color, size: 20),
      ),
    );
  }
}

class _TeacherActivityTile extends StatelessWidget {
  const _TeacherActivityTile({required this.activity});

  final _TeacherActivity activity;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: activity.color.withValues(alpha: .12),
              shape: BoxShape.circle,
            ),
            child: Icon(activity.icon, color: activity.color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    color: Color(0xff2F2966),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  activity.subtitle,
                  style: const TextStyle(
                    color: Color(0xff6D6A95),
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            _relativeTime(activity.timestamp),
            style: const TextStyle(
              color: Color(0xff8B87AC),
              fontSize: 12,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  String _relativeTime(DateTime time) {
    final diff = DateTime.now().difference(time);
    if (diff.inMinutes < 1) return 'baru saja';
    if (diff.inMinutes < 60) return '${diff.inMinutes} menit lalu';
    if (diff.inHours < 24) return '${diff.inHours} jam lalu';
    return '${diff.inDays} hari lalu';
  }
}

class _TeacherStorageRow extends StatelessWidget {
  const _TeacherStorageRow({
    required this.segment,
    required this.maxBytes,
  });

  final _TeacherStorageSegment segment;
  final int maxBytes;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: segment.color.withValues(alpha: .12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(segment.icon, color: segment.color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  segment.label,
                  style: const TextStyle(
                    color: Color(0xff2F2966),
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(999),
                  child: LinearProgressIndicator(
                    value: maxBytes <= 0
                        ? 0
                        : (segment.bytes / maxBytes).clamp(0, 1).toDouble(),
                    minHeight: 8,
                    backgroundColor: segment.color.withValues(alpha: .12),
                    color: segment.color,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text(
            _formatBytes(segment.bytes),
            style: const TextStyle(
              color: Color(0xff6D6A95),
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }

  String _formatBytes(int bytes) {
    if (bytes <= 0) return '0 B';
    const units = ['B', 'KB', 'MB', 'GB'];
    double value = bytes.toDouble();
    var index = 0;
    while (value >= 1024 && index < units.length - 1) {
      value /= 1024;
      index++;
    }
    return '${value.toStringAsFixed(value >= 10 ? 1 : 2)} ${units[index]}';
  }
}

class _TeacherStorageChip extends StatelessWidget {
  const _TeacherStorageChip({required this.segment});

  final _TeacherStorageSegment segment;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 156,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: segment.color.withValues(alpha: .09),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(segment.icon, color: segment.color),
          const SizedBox(height: 10),
          Text(
            segment.label,
            style: const TextStyle(
              color: Color(0xff2F2966),
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _formatBytes(segment.bytes),
            style: TextStyle(
              color: segment.color,
              fontWeight: FontWeight.w900,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  String _formatBytes(int bytes) {
    if (bytes <= 0) return '0 B';
    const units = ['B', 'KB', 'MB', 'GB'];
    double value = bytes.toDouble();
    var index = 0;
    while (value >= 1024 && index < units.length - 1) {
      value /= 1024;
      index++;
    }
    return '${value.toStringAsFixed(value >= 10 ? 1 : 2)} ${units[index]}';
  }
}

class _TeacherSurfaceCard extends StatelessWidget {
  const _TeacherSurfaceCard({
    required this.child,
    required this.padding,
    this.inner = false,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final bool inner;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(inner ? 26 : 32),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: inner ? .86 : .78),
            borderRadius: BorderRadius.circular(inner ? 26 : 32),
            border: Border.all(color: Colors.white, width: 1.4),
            boxShadow: [
              BoxShadow(
                blurRadius: inner ? 16 : 24,
                offset: const Offset(0, 12),
                color: const Color(0xff8B5CF6).withValues(alpha: .08),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}

class _TeacherSummaryCardData {
  const _TeacherSummaryCardData({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.background,
    this.value,
    this.valueFuture,
  });

  final String title;
  final String? value;
  final Future<int>? valueFuture;
  final String subtitle;
  final IconData icon;
  final Color color;
  final List<Color> background;
}

class _TeacherContentData {
  const _TeacherContentData({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.category,
    required this.statusLabel,
    required this.mediaPath,
    required this.color,
    required this.icon,
    required this.badgeText,
    required this.actionLabel,
    required this.editable,
    this.object,
    this.song,
    this.letter,
    this.number,
  });

  final String id;
  final String title;
  final String subtitle;
  final String category;
  final String statusLabel;
  final String mediaPath;
  final Color color;
  final IconData icon;
  final String badgeText;
  final String actionLabel;
  final bool editable;
  final LearningObject? object;
  final SongItem? song;
  final LetterGroup? letter;
  final NumberItem? number;
}

class _TeacherDraftResult {
  const _TeacherDraftResult({
    required this.title,
    required this.subtitle,
    required this.mediaPath,
    this.fileName,
  });

  final String title;
  final String subtitle;
  final String mediaPath;
  final String? fileName;
}

class _TeacherActivity {
  const _TeacherActivity({
    required this.title,
    required this.subtitle,
    required this.timestamp,
    required this.icon,
    required this.color,
  });

  final String title;
  final String subtitle;
  final DateTime timestamp;
  final IconData icon;
  final Color color;
}

class _TeacherStorageData {
  const _TeacherStorageData({
    required this.totalBytes,
    required this.capacityBytes,
    required this.segments,
  });

  const _TeacherStorageData.loading()
      : totalBytes = 0,
        capacityBytes = 5 * 1024 * 1024 * 1024,
        segments = const [
          _TeacherStorageSegment(
            label: 'Gambar',
            bytes: 0,
            color: Color(0xff8B5CF6),
            icon: Icons.image_rounded,
          ),
          _TeacherStorageSegment(
            label: 'Audio',
            bytes: 0,
            color: Color(0xff22C55E),
            icon: Icons.audiotrack_rounded,
          ),
          _TeacherStorageSegment(
            label: 'Video',
            bytes: 0,
            color: Color(0xff38BDF8),
            icon: Icons.video_library_rounded,
          ),
        ];

  final int totalBytes;
  final int capacityBytes;
  final List<_TeacherStorageSegment> segments;

  double get usage => (totalBytes / capacityBytes).clamp(0, 1).toDouble();
}

class _TeacherStorageSegment {
  const _TeacherStorageSegment({
    required this.label,
    required this.bytes,
    required this.color,
    required this.icon,
  });

  final String label;
  final int bytes;
  final Color color;
  final IconData icon;
}
