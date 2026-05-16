part of '../main.dart';

final appStateProvider = ChangeNotifierProvider<AppState>(
  (ref) => AppState(LocalDatabase.instance),
);

enum Role { child, teacher }

enum Gender { boy, girl }

enum TabItem { main, belajar, lagu, akun }

enum LearnMode { menu, huruf, angka, benda, iqra }

class AppState extends ChangeNotifier {
  AppState(this._db) {
    load();
  }

  SharedPreferences? _prefs;
  final LocalDatabase _db;
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

  final List<LetterGroup> letters = [...defaultLettersData];
  final List<NumberItem> numbers = [...defaultNumbersData];
  final List<LearningObject> objects = [...objectsData];
  final List<SongItem> songs = [...songsData];
  final Set<String> favorites = {};
  final Set<String> iqraMastered = {};
  final Set<String> hurfMastered = {};
  final Set<String> angkaMastered = {};
  final Set<String> bendaMastered = {};
  final List<String> iqraHistory = [];
  int stars = 12;
  int iqraStreak = 0;

  AppThemeData get theme =>
      appThemes.firstWhere((t) => t.id == themeId, orElse: () => appThemes[0]);

  Future<void> load() async {
    await _db.ensureReady();
    _prefs = await SharedPreferences.getInstance();
    onboardingSeen = _prefs?.getBool('onboardingSeen') ?? false;
    await _migrateSharedPreferencesAccount();
    final account = await _db.currentAccount();
    if (account == null) {
      final savedTheme =
          await _db.loadThemeId() ?? _prefs?.getString('themeId') ?? 'default';
      themeId = appThemes.any((t) => t.id == savedTheme)
          ? savedTheme
          : 'default';
      favorites.clear();
    } else {
      _applyAccount(account);
    }
    objects
      ..clear()
      ..addAll(await _db.loadObjects());
    letters
      ..clear()
      ..addAll(await _db.loadLetters());
    _sortLetters();
    numbers
      ..clear()
      ..addAll(await _db.loadNumbers());
    _sortNumbers();
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
    favorites.clear();
    await _db.clearSession();
    notifyListeners();
  }

  Future<void> setTheme(String id) async {
    themeId = id;
    await _prefs?.setString('themeId', id);
    await _db.saveThemeId(
      ownerUsername: email,
      themeId: id,
      darkMode: appThemes
          .firstWhere((t) => t.id == id, orElse: () => appThemes[0])
          .night,
    );
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
    await _recordHistory(
      materialId: item.latin,
      category: 'iqra',
      duration: 1,
      score: 100,
    );
    await _saveAccount();
    notifyListeners();
  }

  Future<void> markHurfSuccess(String letter) async {
    hurfMastered.add(letter);
    progress['membaca'] = min(
      100,
      (hurfMastered.length / max(1, letters.length) * 100).round(),
    );
    stars += 2;
    await _recordHistory(
      materialId: letter,
      category: 'huruf',
      duration: 1,
      score: 100,
    );
    await _saveAccount();
    notifyListeners();
  }

  Future<void> markAngkaSuccess(String number) async {
    angkaMastered.add(number);
    progress['angka'] = min(
      100,
      (angkaMastered.length / max(1, numbers.length) * 100).round(),
    );
    stars += 2;
    await _recordHistory(
      materialId: number,
      category: 'angka',
      duration: 1,
      score: 100,
    );
    await _saveAccount();
    notifyListeners();
  }

  Future<void> markBendaSuccess(String name) async {
    bendaMastered.add(name);
    progress['benda'] = min(
      100,
      (bendaMastered.length / max(1, objects.length) * 100).round(),
    );
    stars += 2;
    await _recordHistory(
      materialId: name,
      category: 'benda',
      duration: 1,
      score: 100,
    );
    await _saveAccount();
    notifyListeners();
  }

  Future<void> addObject(String name, String img, String category) async {
    final object = await _db.addObject(name, img, category);
    objects.insert(0, object);
    notifyListeners();
  }

  Future<void> saveLetter({
    required String letter,
    required String example,
    required String imagePath,
    String? existingId,
  }) async {
    final item = await _db.saveLetter(
      letter: letter,
      example: example,
      imagePath: imagePath,
      existingId: existingId,
    );
    letters.removeWhere((entry) => entry.id == item.id);
    letters.insert(0, item);
    _sortLetters();
    notifyListeners();
  }

  Future<void> removeLetter(LetterGroup item) async {
    letters.removeWhere((entry) => entry.id == item.id || entry.letter == item.letter);
    if (hurfMastered.remove(item.letter)) {
      progress['membaca'] = min(
        100,
        (hurfMastered.length / max(1, letters.length) * 100).round(),
      );
      await _saveAccount();
    }
    await _db.removeLetter(item);
    notifyListeners();
  }

  Future<void> saveNumber({
    required String number,
    required String name,
    required String imagePath,
    String? existingId,
  }) async {
    final item = await _db.saveNumber(
      number: number,
      name: name,
      imagePath: imagePath,
      existingId: existingId,
    );
    numbers.removeWhere((entry) => entry.id == item.id);
    numbers.insert(0, item);
    _sortNumbers();
    notifyListeners();
  }

  void _sortLetters() {
    letters.sort((a, b) => a.letter.toUpperCase().compareTo(b.letter.toUpperCase()));
  }

  void _sortNumbers() {
    numbers.sort((a, b) {
      final aNum = int.tryParse(a.number) ?? 9999;
      final bNum = int.tryParse(b.number) ?? 9999;
      final byValue = aNum.compareTo(bNum);
      if (byValue != 0) return byValue;
      return a.number.compareTo(b.number);
    });
  }

  Future<void> removeNumber(NumberItem item) async {
    numbers.removeWhere((entry) => entry.id == item.id || entry.number == item.number);
    if (angkaMastered.remove(item.number)) {
      progress['angka'] = min(
        100,
        (angkaMastered.length / max(1, numbers.length) * 100).round(),
      );
      await _saveAccount();
    }
    await _db.removeNumber(item);
    notifyListeners();
  }

  Future<void> removeObject(LearningObject item, {bool deleteMedia = true}) async {
    objects.remove(item);
    if (deleteMedia && MediaSourceHelper.isLocalFilePath(item.img)) {
      await _db.deleteFile(item.img);
    }
    await _db.removeObject(item);
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

  Future<void> removeSong(SongItem song, {bool deleteMedia = true}) async {
    songs.remove(song);
    favorites.remove(song.id);
    if (deleteMedia && MediaSourceHelper.isLocalFilePath(song.videoUrl)) {
      await _db.deleteFile(song.videoUrl);
    }
    await _db.saveSongs(songs);
    if (email != null) {
      await _db.saveFavoriteIds(email!, favorites);
    }
    notifyListeners();
  }

  Future<void> toggleFavorite(String id) async {
    favorites.contains(id) ? favorites.remove(id) : favorites.add(id);
    if (email != null) {
      await _db.saveFavoriteIds(email!, favorites);
    }
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
    favorites
      ..clear()
      ..addAll(account.favoriteMaterialIds);
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
    hurfMastered
      ..clear()
      ..addAll(account.hurfMastered);
    angkaMastered
      ..clear()
      ..addAll(account.angkaMastered);
    bendaMastered
      ..clear()
      ..addAll(account.bendaMastered);
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
        hurfMastered: hurfMastered.toList(),
        angkaMastered: angkaMastered.toList(),
        bendaMastered: bendaMastered.toList(),
        favoriteMaterialIds: favorites.toList(),
      ),
    );
  }

  Future<void> _recordHistory({
    required String materialId,
    required String category,
    required int duration,
    required int score,
  }) async {
    final username = email;
    if (username == null) return;
    await _db.addHistory(
      username: username,
      record: LearningHistoryRecord(
        materialId: materialId,
        category: category,
        duration: duration,
        score: score,
        playedAt: DateTime.now(),
      ),
    );
  }
}
