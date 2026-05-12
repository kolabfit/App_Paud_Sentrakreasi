part of '../main.dart';

// ═══════════════════════════════════════════════════════════════
//  CHILD-FRIENDLY AUTH FLOW
//  Step-by-step, one question per screen
// ═══════════════════════════════════════════════════════════════

enum _AuthPhase { welcome, loginEmail, loginPass, regName, regEmail, regPass }

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});
  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  final email = TextEditingController();
  final pass = TextEditingController();
  final name = TextEditingController();
  bool teacher = false;
  bool showPass = false;
  bool loading = false;
  String? error;
  _AuthPhase phase = _AuthPhase.welcome;

  void _goPhase(_AuthPhase p) => setState(() { phase = p; error = null; });

  @override
  Widget build(BuildContext context) {
    final t = ref.watch(appStateProvider).theme;
    return Scaffold(
      body: ThemedBackground(
        child: SafeArea(
          child: AnimatedSwitcher(
            duration: 350.ms,
            transitionBuilder: (child, anim) => FadeTransition(
              opacity: anim,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0.08, 0),
                  end: Offset.zero,
                ).animate(CurvedAnimation(parent: anim, curve: Curves.easeOutCubic)),
                child: child,
              ),
            ),
            child: KeyedSubtree(
              key: ValueKey(phase),
              child: switch (phase) {
                _AuthPhase.welcome    => _buildWelcome(t),
                _AuthPhase.loginEmail => _buildStep(t, 'Halo lagi! 👋', 'Minta Ayah/Bunda ketik email ya...', Icons.mail_rounded, email, 'Email', false, () => _goPhase(_AuthPhase.loginPass)),
                _AuthPhase.loginPass  => _buildStep(t, 'Satu langkah lagi! 🔐', 'Minta Ayah/Bunda ketik password...', Icons.lock_rounded, pass, 'Password', true, _submitLogin),
                _AuthPhase.regName    => _buildStep(t, 'Siapa nama kamu? 🧒', 'Tulis nama jagoan kecil di sini!', Icons.child_care_rounded, name, 'Nama Anak', false, () => _goPhase(_AuthPhase.regEmail)),
                _AuthPhase.regEmail   => _buildStep(t, 'Email Ayah/Bunda 📧', 'Minta Ayah/Bunda ketik email ya...', Icons.mail_rounded, email, 'Email', false, () => _goPhase(_AuthPhase.regPass)),
                _AuthPhase.regPass    => _buildStep(t, 'Buat Password 🔑', 'Minta Ayah/Bunda buat password (min 6 huruf)', Icons.lock_rounded, pass, 'Password', true, _submitRegister),
              },
            ),
          ),
        ),
      ),
    );
  }

  // ─── WELCOME SCREEN ──────────────────────
  Widget _buildWelcome(AppThemeData t) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            // Mascot
            Container(
              width: 160, height: 160,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(48),
                color: t.widgetBg,
                border: Border.all(color: t.widgetBorder, width: 4),
                boxShadow: [
                  BoxShadow(offset: const Offset(0, 10), blurRadius: 0, color: t.widgetBorder.withValues(alpha: .25)),
                  BoxShadow(blurRadius: 30, color: t.primary.withValues(alpha: .12)),
                ],
              ),
              padding: const EdgeInsets.all(18),
              child: Image.asset('assets/images/Anak_hebat.png', fit: BoxFit.contain),
            )
                .animate(onPlay: (c) => c.repeat(reverse: true))
                .moveY(begin: -10, end: 10, duration: 2200.ms),
            const SizedBox(height: 32),

            Text(
              'Apakah aku\nkenal kamu? 🤔',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w900,
                color: t.dark ? Colors.white : const Color(0xff263238),
                height: 1.2,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Pilih salah satu ya!',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: muted(context),
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 36),

            // Iya button
            _WelcomeButton(
              label: 'Iya! Aku sudah punya akun 😄',
              color: const Color(0xff27AE60),
              icon: Icons.emoji_emotions_rounded,
              theme: t,
              onTap: () => _goPhase(_AuthPhase.loginEmail),
            ),
            const SizedBox(height: 16),

            // Tidak button
            _WelcomeButton(
              label: 'Belum! Aku mau daftar baru 🌟',
              color: const Color(0xff3498DB),
              icon: Icons.person_add_rounded,
              theme: t,
              onTap: () => _goPhase(_AuthPhase.regName),
            ),
            const SizedBox(height: 28),

            // Teacher mode toggle
            TextButton.icon(
              onPressed: () {
                setState(() => teacher = !teacher);
                if (teacher) _goPhase(_AuthPhase.loginEmail);
              },
              icon: Icon(
                Icons.admin_panel_settings_rounded,
                size: 18,
                color: t.dark ? Colors.white38 : Colors.grey.shade400,
              ),
              label: Text(
                'Khusus Guru / Admin',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 12,
                  color: t.dark ? Colors.white38 : Colors.grey.shade400,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── SINGLE STEP SCREEN ──────────────────────
  Widget _buildStep(
    AppThemeData t,
    String title,
    String subtitle,
    IconData icon,
    TextEditingController controller,
    String fieldLabel,
    bool isPassword,
    VoidCallback onNext,
  ) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(28),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 440),
          child: Column(
            children: [
              // Icon bubble
              Container(
                width: 90, height: 90,
                decoration: BoxDecoration(
                  color: t.primary.withValues(alpha: .12),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: t.primary.withValues(alpha: .2), width: 2),
                ),
                child: Icon(icon, size: 42, color: t.primary),
              ).animate().scale(duration: 300.ms, curve: Curves.elasticOut),
              const SizedBox(height: 24),

              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                  color: t.dark ? Colors.white : const Color(0xff263238),
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: muted(context),
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 32),

              // Input card
              Container(
                padding: const EdgeInsets.all(22),
                decoration: tactileCard(context, radius: 28),
                child: Column(
                  children: [
                    TextField(
                      controller: controller,
                      obscureText: isPassword && !showPass,
                      autofocus: true,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: isPassword ? 18 : 22,
                        fontWeight: FontWeight.w900,
                        color: t.dark ? Colors.white : const Color(0xff263238),
                      ),
                      decoration: InputDecoration(
                        hintText: fieldLabel,
                        hintStyle: TextStyle(
                          color: muted(context),
                          fontWeight: FontWeight.w600,
                        ),
                        filled: true,
                        fillColor: t.dark ? Colors.white.withValues(alpha: .05) : Colors.grey.shade50,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                        suffixIcon: isPassword
                            ? IconButton(
                                icon: Icon(showPass ? Icons.visibility_off : Icons.visibility),
                                onPressed: () => setState(() => showPass = !showPass),
                              )
                            : null,
                      ),
                      onSubmitted: (_) => onNext(),
                    ),

                    if (error != null) ...[
                      const SizedBox(height: 14),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: Colors.red.shade200),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.warning_amber_rounded, color: Colors.red.shade600, size: 18),
                            const SizedBox(width: 8),
                            Expanded(child: Text(error!, style: TextStyle(color: Colors.red.shade700, fontWeight: FontWeight.w800, fontSize: 12))),
                          ],
                        ),
                      ),
                    ],

                    const SizedBox(height: 18),
                    FilledButton.icon(
                      onPressed: loading ? null : onNext,
                      icon: loading
                          ? const SizedBox.square(dimension: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                          : const Icon(Icons.arrow_forward_rounded),
                      label: Text(isPassword ? (phase == _AuthPhase.loginPass ? 'Masuk!' : 'Daftar!') : 'Lanjut'),
                      style: bigButton(t.primary),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),
              // Back button
              TextButton.icon(
                onPressed: () {
                  if (phase == _AuthPhase.loginEmail || phase == _AuthPhase.regName) {
                    _goPhase(_AuthPhase.welcome);
                  } else if (phase == _AuthPhase.loginPass) {
                    _goPhase(_AuthPhase.loginEmail);
                  } else if (phase == _AuthPhase.regEmail) {
                    _goPhase(_AuthPhase.regName);
                  } else if (phase == _AuthPhase.regPass) {
                    _goPhase(_AuthPhase.regEmail);
                  }
                },
                icon: Icon(Icons.arrow_back_rounded, size: 18, color: muted(context)),
                label: Text('Kembali', style: TextStyle(color: muted(context), fontWeight: FontWeight.w800)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─── SUBMIT ACTIONS ──────────────────────
  Future<void> _submitLogin() async {
    if (email.text.trim().isEmpty) return setState(() => error = 'Email belum diisi');
    if (pass.text.length < 6) return setState(() => error = 'Password minimal 6 karakter');
    setState(() { loading = true; error = null; });
    try {
      await ref.read(appStateProvider).login(
        nextEmail: email.text.trim(),
        password: pass.text,
        teacherMode: teacher,
      );
    } catch (e) {
      setState(() => error = e.toString());
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  Future<void> _submitRegister() async {
    if (name.text.trim().isEmpty) return setState(() => error = 'Nama belum diisi');
    if (email.text.trim().isEmpty) return setState(() => error = 'Email belum diisi');
    if (pass.text.length < 6) return setState(() => error = 'Password minimal 6 karakter');
    setState(() { loading = true; error = null; });
    try {
      await ref.read(appStateProvider).login(
        nextEmail: email.text.trim(),
        password: pass.text,
        teacherMode: false,
        name: name.text.trim(),
      );
    } catch (e) {
      setState(() => error = e.toString());
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }
}

// ─── Welcome choice button ──────────────────────
class _WelcomeButton extends StatelessWidget {
  const _WelcomeButton({
    required this.label,
    required this.color,
    required this.icon,
    required this.theme,
    required this.onTap,
  });
  final String label;
  final Color color;
  final IconData icon;
  final AppThemeData theme;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(maxWidth: 380),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        decoration: BoxDecoration(
          color: theme.widgetBg,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: color.withValues(alpha: .3), width: 2.5),
          boxShadow: [
            BoxShadow(offset: const Offset(0, 7), blurRadius: 0, color: color.withValues(alpha: .15)),
            BoxShadow(blurRadius: 16, offset: const Offset(0, 8), color: Colors.black.withValues(alpha: theme.dark ? .15 : .04)),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 52, height: 52,
              decoration: BoxDecoration(
                color: color.withValues(alpha: .12),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  color: theme.dark ? Colors.white : Colors.grey.shade800,
                ),
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded, size: 16, color: color),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 300.ms).slideX(begin: .05);
  }
}
