part of '../main.dart';

class AccountScreen extends ConsumerWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final app = ref.watch(appStateProvider);
    final t = app.theme;
    return PagePad(
      child: ListView(
        children: [
          // Profile card
          Container(
            padding: const EdgeInsets.all(24),
            decoration: tactileCard(context, radius: 34),
            child: Row(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [t.primary, t.accent],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(26),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                        color: t.primary.withValues(alpha: .25),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      app.childName.isNotEmpty ? app.childName[0].toUpperCase() : '?',
                      style: const TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 18),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        app.childName,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          color: t.dark ? Colors.white : const Color(0xff263238),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        app.email ?? '',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: muted(context),
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: app.role == Role.teacher
                              ? Colors.deepPurple.withValues(alpha: .12)
                              : Colors.green.withValues(alpha: .12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          app.role == Role.teacher ? '👩‍🏫 Pengajar' : '👶 Anak',
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 11,
                            color: app.role == Role.teacher ? Colors.deepPurple : Colors.green.shade700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Rewards
          RewardPill(stars: app.stars, streak: app.streak),
          const SizedBox(height: 16),

          // Progress
          ProgressOverview(progress: app.progress, compact: false),
          const SizedBox(height: 20),

          // Theme selector
          Container(
            padding: const EdgeInsets.all(20),
            decoration: tactileCard(context, radius: 26),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.purple.withValues(alpha: .12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.palette_rounded, size: 20, color: Colors.purple),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'TEMA APLIKASI',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 3,
                        color: Colors.purple,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: appThemes.map((theme) {
                    final selected = app.themeId == theme.id;
                    return GestureDetector(
                      onTap: () => ref.read(appStateProvider).setTheme(theme.id),
                      child: AnimatedContainer(
                        duration: 200.ms,
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          color: selected ? theme.primary.withValues(alpha: .15) : Colors.transparent,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: selected ? theme.primary : theme.primary.withValues(alpha: .2),
                            width: selected ? 2.5 : 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                color: theme.primary,
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: selected
                                    ? [BoxShadow(blurRadius: 8, color: theme.primary.withValues(alpha: .4))]
                                    : [],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              theme.name,
                              style: TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 13,
                                color: selected
                                    ? (t.dark ? Colors.white : Colors.grey.shade800)
                                    : muted(context),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),

          if (app.role == Role.teacher)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: FilledButton.icon(
                onPressed: () => ref.read(appStateProvider).go(TabItem.akun),
                icon: const Icon(Icons.dashboard_rounded),
                label: const Text('Dashboard Pengajar'),
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(54),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
              ),
            ),
          OutlinedButton.icon(
            onPressed: () => ref.read(appStateProvider).logout(),
            icon: const Icon(Icons.logout_rounded),
            label: const Text('Keluar'),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(54),
              foregroundColor: Colors.redAccent,
              side: const BorderSide(color: Colors.redAccent),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            ),
          ),
          const SizedBox(height: 110),
        ],
      ),
    );
  }
}
