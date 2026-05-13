import 'dart:math';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:video_player/video_player.dart';

part 'src/models.dart';
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

const adminEmail = 'andibayu8310@gmail.com';

void main() => runApp(const ProviderScope(child: BelajarYukApp()));
