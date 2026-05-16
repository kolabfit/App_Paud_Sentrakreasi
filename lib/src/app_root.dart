part of '../main.dart';

class KhoirQuestApp extends ConsumerWidget {
  const KhoirQuestApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final app = ref.watch(appStateProvider);
    final theme = app.theme;
    final colors =
        ColorScheme.fromSeed(
          seedColor: theme.primary,
          brightness: theme.dark ? Brightness.dark : Brightness.light,
        ).copyWith(
          surface: theme.dark ? theme.widgetBg : null,
          primary: theme.primary,
          secondary: theme.secondary,
          tertiary: theme.accent,
          onSurface: theme.dark ? NightPalette.text : null,
        );
    final baseText =
        ThemeData(
          brightness: theme.dark ? Brightness.dark : Brightness.light,
        ).textTheme.apply(
          fontFamily: 'Nunito',
          bodyColor: theme.dark ? NightPalette.text : const Color(0xff263238),
          displayColor: theme.dark
              ? NightPalette.text
              : const Color(0xff263238),
        );
    final themed = ThemeData(
      useMaterial3: true,
      colorScheme: colors,
      fontFamily: 'Nunito',
      textTheme: baseText.copyWith(
        headlineLarge: baseText.headlineLarge?.copyWith(
          fontFamily: 'Baloo2',
          fontWeight: FontWeight.w900,
        ),
        headlineMedium: baseText.headlineMedium?.copyWith(
          fontFamily: 'Baloo2',
          fontWeight: FontWeight.w900,
        ),
        headlineSmall: baseText.headlineSmall?.copyWith(
          fontFamily: 'Baloo2',
          fontWeight: FontWeight.w900,
        ),
        titleLarge: baseText.titleLarge?.copyWith(
          fontFamily: 'Baloo2',
          fontWeight: FontWeight.w900,
        ),
        titleMedium: baseText.titleMedium?.copyWith(
          fontFamily: 'Baloo2',
          fontWeight: FontWeight.w900,
        ),
        titleSmall: baseText.titleSmall?.copyWith(
          fontFamily: 'Baloo2',
          fontWeight: FontWeight.w900,
        ),
      ),
      scaffoldBackgroundColor: theme.bg,
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 0,
        backgroundColor: theme.dark
            ? NightPalette.surface.withValues(alpha: .72)
            : null,
        labelStyle: TextStyle(color: theme.dark ? NightPalette.text : null),
        side: BorderSide(
          color: theme.dark
              ? NightPalette.cyan.withValues(alpha: .22)
              : Colors.transparent,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: theme.dark ? theme.primary : null,
          foregroundColor: theme.dark ? NightPalette.text : null,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          textStyle: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15),
          shadowColor: theme.dark ? theme.primary.withValues(alpha: .45) : null,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: theme.dark ? NightPalette.text : null,
          side: BorderSide(
            color: theme.dark
                ? NightPalette.cyan.withValues(alpha: .42)
                : theme.primary,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          textStyle: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15),
        ),
      ),
      cardTheme: CardThemeData(
        color: theme.dark ? theme.widgetBg : null,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        elevation: theme.dark ? 0 : 2,
      ),
      navigationBarTheme: NavigationBarThemeData(
        height: 72,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        indicatorShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
      ),
    );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: AppIdentity.appName,
      theme: themed,
      builder: (context, child) => AnimatedTheme(
        data: themed,
        duration: 420.ms,
        curve: Curves.easeOutCubic,
        child: child ?? const SizedBox.shrink(),
      ),
      home: !app.ready
          ? const SplashScreen()
          : !app.onboardingSeen
          ? const OnboardingScreen()
          : app.role == null
          ? const AuthScreen()
          : app.role == Role.teacher
          ? const TeacherDashboard()
          : const ShellScreen(),
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 30,
                        offset: const Offset(0, 12),
                        color: Theme.of(
                          context,
                        ).colorScheme.primary.withValues(alpha: .2),
                      ),
                    ],
                  ),
                  child: Image.asset(
                    'assets/images/Anak_hebat.png',
                    fit: BoxFit.contain,
                  ),
                )
                .animate(onPlay: (c) => c.repeat(reverse: true))
                .moveY(begin: -10, end: 10, duration: 1200.ms),
            const SizedBox(height: 20),
            Text(
              'KHOIR QUEST',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w900,
                letterSpacing: 6,
                color: Theme.of(context).colorScheme.primary,
              ),
            ).animate().fadeIn(duration: 600.ms),
          ],
        ),
      ),
    );
  }
}
