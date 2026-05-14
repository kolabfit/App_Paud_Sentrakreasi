part of '../main.dart';

final appStateProvider = ChangeNotifierProvider<AppState>((ref) => AppState());

enum Role { child, teacher }

enum Gender { boy, girl }

enum TabItem { main, belajar, lagu, akun }

enum LearnMode { menu, huruf, angka, benda, iqra }

class AppState extends ChangeNotifier {
  AppState() {
    load();
  }

  SharedPreferences? _prefs;
  final LocalDatabase _db = LocalDatabase.instance;
  String? email;
  String childName = 'Teman';
  Gender gender = Gender.boy;
  Role? role;
  String themeId = 'default';
  bool onboardingSeen = false;
  TabItem tab = TabItem.main;
  LearnMode learnMode = LearnMode.menu;
  bool ready = false;

  final Map<String, int> progress = {
    'membaca': 0,
    'angka': 0,
    'benda': 0,
    'iqra': 0,
  };

  final List<LearningObject> objects = [...objectsData];
  final List<SongItem> songs = [...songsData];
  final Set<String> favorites = {};
  final Set<String> iqraMastered = {};
  final List<String> iqraHistory = [];
  int stars = 12;
  int iqraStreak = 0;

  AppThemeData get theme =>
      appThemes.firstWhere((t) => t.id == themeId, orElse: () => appThemes[0]);

  Future<void> load() async {
    _prefs = await SharedPreferences.getInstance();
    onboardingSeen = _prefs?.getBool('onboardingSeen') ?? false;
    await _migrateSharedPreferencesAccount();
    final account = await _db.currentAccount();
    if (account == null) {
      final savedTheme = _prefs?.getString('themeId') ?? 'default';
      themeId = appThemes.any((t) => t.id == savedTheme)
          ? savedTheme
          : 'default';
    } else {
      _applyAccount(account);
    }
    songs
      ..clear()
      ..addAll(await _db.loadSongs());
    ready = true;
    notifyListeners();
  }

  Future<void> login({
    required String nextEmail,
    required String password,
    bool teacherMode = false,
    bool register = false,
    bool autoCreate = false,
    String? name,
    Gender? nextGender,
  }) async {
    if (nextEmail.trim().length < 3) throw 'Username minimal 3 karakter ya';
    if (password.length < 6) throw 'Password minimal 6 karakter ya';
    final nextRole = teacherMode || _resolveRole(nextEmail) == Role.teacher
        ? Role.teacher
        : Role.child;
    final account = await _db.authenticate(
      username: nextEmail,
      password: password,
      register: register,
      autoCreate: autoCreate,
      role: nextRole,
      childName: name?.trim().isNotEmpty == true ? name!.trim() : 'Teman',
      gender: nextGender ?? gender,
      themeId: themeId,
      defaultProgress: progress,
      defaultStars: stars,
    );
    _applyAccount(account);
    tab = role == Role.teacher ? TabItem.akun : TabItem.main;
    notifyListeners();
  }

  Role _resolveRole(String identity) {
    final id = identity.toLowerCase().trim();
    if (id == adminEmail ||
        id == 'pengajar' ||
        id == 'guru' ||
        id.startsWith('guru_') ||
        id.contains('@guru')) {
      return Role.teacher;
    }
    return Role.child;
  }

  Future<void> completeOnboarding() async {
    onboardingSeen = true;
    await _prefs?.setBool('onboardingSeen', true);
    notifyListeners();
  }

  Future<void> logout() async {
    email = null;
    role = null;
    await _db.clearSession();
    notifyListeners();
  }

  Future<void> setTheme(String id) async {
    themeId = id;
    await _prefs?.setString('themeId', id);
    await _saveAccount();
    notifyListeners();
  }

  void go(TabItem item) {
    tab = item;
    notifyListeners();
  }

  void openLearn(LearnMode mode) {
    learnMode = mode;
    tab = TabItem.belajar;
    notifyListeners();
  }

  Future<void> bump(String key, [int amount = 7]) async {
    progress[key] = min(100, (progress[key] ?? 0) + amount);
    stars += 1;
    await _saveAccount();
    notifyListeners();
  }

  Future<void> markIqraSuccess(IqraItem item) async {
    iqraMastered.add(item.latin);
    iqraHistory.insert(
      0,
      '${DateTime.now().toIso8601String()}|${item.char}|${item.latin}',
    );
    if (iqraHistory.length > 20) {
      iqraHistory.removeRange(20, iqraHistory.length);
    }
    iqraStreak += 1;
    progress['iqra'] = min(
      100,
      (iqraMastered.length / iqraData.length * 100).round(),
    );
    stars += 2;
    await _saveAccount();
    notifyListeners();
  }

  void addObject(String name, String img, String category) {
    objects.insert(0, LearningObject(name, img, category));
    notifyListeners();
  }

  void removeObject(LearningObject item) {
    objects.remove(item);
    notifyListeners();
  }

  Future<void> addSong(String title, String url, {String? fileName}) async {
    songs.insert(
      0,
      SongItem(
        DateTime.now().millisecondsSinceEpoch.toString(),
        title,
        url,
        const [],
        fileName: fileName,
      ),
    );
    await _db.saveSongs(songs);
    notifyListeners();
  }

  Future<void> removeSong(SongItem song) async {
    songs.remove(song);
    favorites.remove(song.id);
    await _db.saveSongs(songs);
    notifyListeners();
  }

  void toggleFavorite(String id) {
    favorites.contains(id) ? favorites.remove(id) : favorites.add(id);
    notifyListeners();
  }

  Future<void> _migrateSharedPreferencesAccount() async {
    final savedEmail = _prefs?.getString('email');
    if (savedEmail == null) return;
    final savedTheme = _prefs?.getString('themeId') ?? 'default';
    final savedProgress = Map<String, int>.from(progress);
    for (final key in savedProgress.keys) {
      savedProgress[key] =
          _prefs?.getInt('progress_$key') ?? savedProgress[key]!;
    }
    final roleName = _prefs?.getString('role');
    await _db.migrateAccount(
      username: savedEmail,
      childName: _prefs?.getString('childName') ?? 'Teman',
      gender: _prefs?.getString('gender') == 'girl' ? Gender.girl : Gender.boy,
      role: roleName == 'teacher' ? Role.teacher : Role.child,
      themeId: appThemes.any((t) => t.id == savedTheme)
          ? savedTheme
          : 'default',
      stars: _prefs?.getInt('stars') ?? stars,
      iqraStreak: _prefs?.getInt('iqra_streak') ?? 0,
      progress: savedProgress,
      iqraMastered: _prefs?.getStringList('iqra_mastered') ?? const [],
      iqraHistory: _prefs?.getStringList('iqra_history') ?? const [],
    );
  }

  void _applyAccount(UserAccount account) {
    email = account.username;
    childName = account.childName;
    gender = account.gender;
    role = account.role;
    themeId = appThemes.any((t) => t.id == account.themeId)
        ? account.themeId
        : 'default';
    for (final entry in account.progress.entries) {
      progress[entry.key] = entry.value;
    }
    stars = account.stars;
    iqraStreak = account.iqraStreak;
    iqraMastered
      ..clear()
      ..addAll(account.iqraMastered);
    iqraHistory
      ..clear()
      ..addAll(account.iqraHistory);
  }

  Future<void> _saveAccount() async {
    final username = email;
    final currentRole = role;
    if (username == null || currentRole == null) return;
    await _db.saveAccount(
      UserAccount(
        username: username,
        childName: childName,
        gender: gender,
        role: currentRole,
        themeId: themeId,
        stars: stars,
        iqraStreak: iqraStreak,
        progress: progress,
        iqraMastered: iqraMastered.toList(),
        iqraHistory: iqraHistory.toList(),
      ),
    );
  }
}
