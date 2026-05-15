import 'dart:convert';
import 'dart:math';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:confetti/confetti.dart';
import 'package:crypto/crypto.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast_io.dart';
import 'package:sembast_web/sembast_web.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:video_player/video_player.dart';

part 'src/models.dart';
part 'src/local_database.dart';
part 'src/theme_data.dart';
part 'src/learning_data.dart';
part 'src/app_state.dart';
part 'src/ui_helpers.dart';
part 'src/app_root.dart';
part 'src/auth_screen.dart';
part 'src/shell_main_screen.dart';
part 'src/learning_screens.dart';
part 'src/songs_screen.dart';
part 'src/account_screen.dart';
part 'src/teacher_dashboard.dart';
part 'src/screen_widgets.dart';
part 'src/badge_system.dart';
part 'src/badge_screen.dart';

const adminEmail = 'andibayu8310@gmail.com';

void main() => runApp(const ProviderScope(child: BelajarYukApp()));
