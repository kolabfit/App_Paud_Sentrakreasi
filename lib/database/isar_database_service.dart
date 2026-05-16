import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../core/constants/app_identity.dart';
import 'collections/badge_collection.dart';
import 'collections/learning_history_collection.dart';
import 'collections/learning_material_collection.dart';
import 'collections/learning_progress_collection.dart';
import 'collections/local_session_collection.dart';
import 'collections/theme_settings_collection.dart';
import 'collections/user_profile_collection.dart';

class IsarDatabaseService {
  IsarDatabaseService._();

  static final instance = IsarDatabaseService._();

  Isar? _isar;
  Future<Isar>? _opening;

  Future<Isar> initDatabase() async {
    final existing = _isar;
    if (existing != null) return existing;
    final opening = _opening;
    if (opening != null) return opening;
    _opening = _openDatabase();
    final isar = await _opening!;
    _isar = isar;
    _opening = null;
    return isar;
  }

  Future<Isar> _openDatabase() async {
    if (kIsWeb) {
      return Isar.open(
        [
          UserProfileEntitySchema,
          LearningProgressEntitySchema,
          BadgeModelEntitySchema,
          LearningMaterialEntitySchema,
          ThemeSettingsEntitySchema,
          LearningHistoryEntitySchema,
          LocalSessionEntitySchema,
        ],
        directory: '',
        name: AppIdentity.databaseName,
        inspector: false,
      );
    }

    final dir = await getApplicationSupportDirectory();
    return Isar.open(
      [
        UserProfileEntitySchema,
        LearningProgressEntitySchema,
        BadgeModelEntitySchema,
        LearningMaterialEntitySchema,
        ThemeSettingsEntitySchema,
        LearningHistoryEntitySchema,
        LocalSessionEntitySchema,
      ],
      directory: dir.path,
      name: AppIdentity.databaseName,
      inspector: false,
    );
  }

  Future<T> read<T>(FutureOr<T> Function(Isar isar) action) async {
    final isar = await initDatabase();
    return action(isar);
  }

  Future<T> write<T>(FutureOr<T> Function(Isar isar) action) async {
    final isar = await initDatabase();
    late T result;
    await isar.writeTxn(() async {
      result = await action(isar);
    });
    return result;
  }
}
