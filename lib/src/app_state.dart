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
    'membaca': 65,
    'angka': 40,
    'benda': 85,
    'iqra': 25,
  };

  final List<LearningObject> objects = [...objectsData];
  final List<SongItem> songs = [...songsData];
  final Set<String> favorites = {};
  int stars = 12;

  AppThemeData get theme =>
      appThemes.firstWhere((t) => t.id == themeId, orElse: () => appThemes[0]);

  Future<void> load() async {
    _prefs = await SharedPreferences.getInstance();
    email = _prefs?.getString('email');
    childName = _prefs?.getString('childName') ?? 'Teman';
    gender = _prefs?.getString('gender') == 'girl' ? Gender.girl : Gender.boy;
    onboardingSeen = _prefs?.getBool('onboardingSeen') ?? false;
    final savedTheme = _prefs?.getString('themeId') ?? 'default';
    themeId = appThemes.any((t) => t.id == savedTheme) ? savedTheme : 'default';
    final roleName = _prefs?.getString('role');
    role = roleName == 'teacher'
        ? Role.teacher
        : roleName == 'child'
        ? Role.child
        : null;
    for (final key in progress.keys) {
      progress[key] = _prefs?.getInt('progress_$key') ?? progress[key]!;
    }
    stars = _prefs?.getInt('stars') ?? stars;
    ready = true;
    notifyListeners();
  }

  Future<void> login({
    required String nextEmail,
    required String password,
    bool teacherMode = false,
    String? name,
    Gender? nextGender,
  }) async {
    if (nextEmail.trim().length < 3) throw 'Username minimal 3 karakter ya';
    if (password.length < 6) throw 'Password minimal 6 karakter ya';
    role = teacherMode || _resolveRole(nextEmail) == Role.teacher
        ? Role.teacher
        : Role.child;
    email = nextEmail.trim();
    childName = name?.trim().isNotEmpty == true ? name!.trim() : 'Teman';
    gender = nextGender ?? gender;
    await _prefs?.setString('email', email!);
    await _prefs?.setString('childName', childName);
    await _prefs?.setString('gender', gender == Gender.girl ? 'girl' : 'boy');
    await _prefs?.setString('role', role == Role.teacher ? 'teacher' : 'child');
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
    await _prefs?.remove('email');
    await _prefs?.remove('role');
    notifyListeners();
  }

  Future<void> setTheme(String id) async {
    themeId = id;
    await _prefs?.setString('themeId', id);
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
    await _prefs?.setInt('progress_$key', progress[key]!);
    await _prefs?.setInt('stars', stars);
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

  void addSong(String title, String url) {
    songs.insert(
      0,
      SongItem(
        DateTime.now().millisecondsSinceEpoch.toString(),
        title,
        url,
        const [],
      ),
    );
    notifyListeners();
  }

  void removeSong(SongItem song) {
    songs.remove(song);
    favorites.remove(song.id);
    notifyListeners();
  }

  void toggleFavorite(String id) {
    favorites.contains(id) ? favorites.remove(id) : favorites.add(id);
    notifyListeners();
  }
}
