part of '../main.dart';

final appStateProvider = ChangeNotifierProvider<AppState>((ref) => AppState());

enum Role { child, teacher }

enum TabItem { main, belajar, lagu, akun }

enum LearnMode { menu, huruf, angka, benda, iqra }

class AppState extends ChangeNotifier {
  AppState() {
    load();
  }

  SharedPreferences? _prefs;
  String? email;
  String childName = 'Teman';
  Role? role;
  String themeId = 'hewan';
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
  int streak = 3;

  AppThemeData get theme =>
      appThemes.firstWhere((t) => t.id == themeId, orElse: () => appThemes[2]);

  Future<void> load() async {
    _prefs = await SharedPreferences.getInstance();
    email = _prefs?.getString('email');
    childName = _prefs?.getString('childName') ?? 'Teman';
    themeId = _prefs?.getString('themeId') ?? 'hewan';
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
    streak = _prefs?.getInt('streak') ?? streak;
    ready = true;
    notifyListeners();
  }

  Future<void> login({
    required String nextEmail,
    required String password,
    required bool teacherMode,
    String? name,
  }) async {
    if (!nextEmail.contains('@')) {
      throw 'Email belum valid ya Bunda/Ayah';
    }
    if (password.length < 6) throw 'Password minimal 6 karakter ya';
    role = teacherMode || nextEmail.toLowerCase() == adminEmail
        ? Role.teacher
        : Role.child;
    email = nextEmail;
    childName = name?.trim().isNotEmpty == true ? name!.trim() : 'Teman';
    await _prefs?.setString('email', email!);
    await _prefs?.setString('childName', childName);
    await _prefs?.setString('role', role == Role.teacher ? 'teacher' : 'child');
    tab = role == Role.teacher ? TabItem.akun : TabItem.main;
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
