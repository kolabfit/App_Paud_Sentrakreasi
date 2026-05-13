part of '../main.dart';

class UserAccount {
  const UserAccount({
    required this.username,
    required this.childName,
    required this.gender,
    required this.role,
    required this.themeId,
    required this.stars,
    required this.iqraStreak,
    required this.progress,
    required this.iqraMastered,
    required this.iqraHistory,
  });

  final String username;
  final String childName;
  final Gender gender;
  final Role role;
  final String themeId;
  final int stars;
  final int iqraStreak;
  final Map<String, int> progress;
  final List<String> iqraMastered;
  final List<String> iqraHistory;
}

class LocalDatabase {
  LocalDatabase._();
  static final instance = LocalDatabase._();

  final _accounts = stringMapStoreFactory.store('accounts');
  final _session = stringMapStoreFactory.store('session');
  final _content = stringMapStoreFactory.store('content');
  Database? _db;

  Future<Database> get db async {
    final current = _db;
    if (current != null) return current;
    if (kIsWeb) {
      return _db = await databaseFactoryWeb.openDatabase('belajar_yuk.db');
    }
    final dir = await getApplicationSupportDirectory();
    return _db = await databaseFactoryIo.openDatabase(
      '${dir.path}/belajar_yuk.db',
      version: 1,
    );
  }

  Future<UserAccount?> currentAccount() async {
    final database = await db;
    final data = await _session.record('current').get(database);
    final username = data?['username'] as String?;
    if (username == null) return null;
    return account(username);
  }

  Future<void> clearSession() async {
    await _session.record('current').delete(await db);
  }

  Future<UserAccount?> account(String username) async {
    final data = await _accounts.record(_key(username)).get(await db);
    return data == null ? null : _fromMap(data);
  }

  Future<UserAccount> authenticate({
    required String username,
    required String password,
    required bool register,
    required bool autoCreate,
    required Role role,
    required String childName,
    required Gender gender,
    required String themeId,
    required Map<String, int> defaultProgress,
    required int defaultStars,
  }) async {
    final database = await db;
    final key = _key(username);
    final saved = await _accounts.record(key).get(database);
    final now = DateTime.now().toIso8601String();
    final hash = _hash(password);

    if (saved == null) {
      if (!register && !autoCreate) throw 'Akun belum terdaftar';
      final data = <String, Object?>{
        'username': username.trim(),
        'passwordHash': hash,
        'childName': childName,
        'gender': gender.name,
        'role': role.name,
        'themeId': themeId,
        'stars': defaultStars,
        'iqraStreak': 0,
        'progress': Map<String, int>.from(defaultProgress),
        'iqraMastered': <String>[],
        'iqraHistory': <String>[],
        'createdAt': now,
        'updatedAt': now,
      };
      await _accounts.record(key).put(database, data);
      await _session.record('current').put(database, {'username': key});
      return _fromMap(data);
    }

    if (register) throw 'Username sudah terdaftar';

    final savedHash = saved['passwordHash'] as String?;
    if (savedHash != null && savedHash != hash) throw 'Password salah';
    if (savedHash == null) {
      await _accounts.record(key).update(database, {'passwordHash': hash});
    }
    await _session.record('current').put(database, {'username': key});
    return _fromMap({...saved, 'passwordHash': hash});
  }

  Future<void> saveAccount(UserAccount account) async {
    await _accounts.record(_key(account.username)).update(await db, {
      'childName': account.childName,
      'gender': account.gender.name,
      'role': account.role.name,
      'themeId': account.themeId,
      'stars': account.stars,
      'iqraStreak': account.iqraStreak,
      'progress': Map<String, int>.from(account.progress),
      'iqraMastered': account.iqraMastered,
      'iqraHistory': account.iqraHistory,
      'updatedAt': DateTime.now().toIso8601String(),
    });
  }

  Future<void> migrateAccount({
    required String username,
    required String childName,
    required Gender gender,
    required Role role,
    required String themeId,
    required int stars,
    required int iqraStreak,
    required Map<String, int> progress,
    required List<String> iqraMastered,
    required List<String> iqraHistory,
  }) async {
    final database = await db;
    final key = _key(username);
    if (await _accounts.record(key).exists(database)) return;
    final now = DateTime.now().toIso8601String();
    await _accounts.record(key).put(database, {
      'username': username.trim(),
      'passwordHash': null,
      'childName': childName,
      'gender': gender.name,
      'role': role.name,
      'themeId': themeId,
      'stars': stars,
      'iqraStreak': iqraStreak,
      'progress': Map<String, int>.from(progress),
      'iqraMastered': iqraMastered,
      'iqraHistory': iqraHistory,
      'createdAt': now,
      'updatedAt': now,
    });
    await _session.record('current').put(database, {'username': key});
  }

  Future<List<SongItem>> loadSongs() async {
    final data = await _content.record('songs').get(await db);
    final rawSongs = data?['items'] as List?;
    if (rawSongs == null) return [...songsData];
    return rawSongs.map((raw) {
      final item = Map<String, Object?>.from(raw as Map);
      return SongItem(
        item['id'] as String,
        item['title'] as String,
        item['videoUrl'] as String,
        const [],
        fileName: item['fileName'] as String?,
      );
    }).toList();
  }

  Future<void> saveSongs(List<SongItem> songs) async {
    await _content.record('songs').put(await db, {
      'items': songs
          .map(
            (song) => {
              'id': song.id,
              'title': song.title,
              'videoUrl': song.videoUrl,
              'fileName': song.fileName,
            },
          )
          .toList(),
      'updatedAt': DateTime.now().toIso8601String(),
    });
  }

  UserAccount _fromMap(Map<String, Object?> data) {
    final rawProgress = data['progress'] as Map?;
    return UserAccount(
      username: data['username'] as String,
      childName: data['childName'] as String? ?? 'Teman',
      gender: data['gender'] == 'girl' ? Gender.girl : Gender.boy,
      role: data['role'] == 'teacher' ? Role.teacher : Role.child,
      themeId: data['themeId'] as String? ?? 'default',
      stars: data['stars'] as int? ?? 0,
      iqraStreak: data['iqraStreak'] as int? ?? 0,
      progress: {
        if (rawProgress != null)
          for (final e in rawProgress.entries)
            e.key.toString(): (e.value as num).toInt(),
      },
      iqraMastered: List<String>.from(
        data['iqraMastered'] as List? ?? const [],
      ),
      iqraHistory: List<String>.from(data['iqraHistory'] as List? ?? const []),
    );
  }

  String _key(String username) => username.toLowerCase().trim();
  String _hash(String password) =>
      sha256.convert(utf8.encode(password)).toString();
}
