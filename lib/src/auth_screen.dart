part of '../main.dart';

enum _AuthMode { login, register }

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final page = PageController();
  int index = 0;

  @override
  Widget build(BuildContext context) {
    final t = ref.watch(appStateProvider).theme;
    final slides = [
      (
        'Selamat datang di Belajar Yuk!',
        'Belajar sambil bermain setiap hari.',
        Icons.waving_hand_rounded,
        'assets/images/Anak_hebat.png',
      ),
      (
        'Mode Seru dengan suara',
        'Ucapkan jawaban, dapatkan reward.',
        Icons.mic_rounded,
        'assets/images/Logo_membaca.png',
      ),
      (
        'Lagu anak interaktif',
        'Bernyanyi, bergerak, dan tetap fokus.',
        Icons.music_note_rounded,
        'assets/images/Bernyanyi.png',
      ),
      (
        'Tracking progress belajar',
        'Ayah, Bunda, dan Pengajar mudah memantau.',
        Icons.insights_rounded,
        'assets/images/Logo_123.png',
      ),
    ];

    return Scaffold(
      body: ThemedBackground(
        child: Stack(
          children: [
            const _FloatingShapes(),
            SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: PageView.builder(
                      controller: page,
                      onPageChanged: (v) => setState(() => index = v),
                      itemCount: slides.length,
                      itemBuilder: (_, i) {
                        final s = slides[i];
                        return Padding(
                          padding: const EdgeInsets.all(26),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _GlassCard(
                                child: Column(
                                  children: [
                                    Icon(s.$3, color: t.primary, size: 42),
                                    const SizedBox(height: 14),
                                    Image.asset(
                                          s.$4,
                                          height: 210,
                                          fit: BoxFit.contain,
                                        )
                                        .animate(
                                          onPlay: (c) =>
                                              c.repeat(reverse: true),
                                        )
                                        .moveY(
                                          begin: -8,
                                          end: 8,
                                          duration: 1800.ms,
                                        ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 30),
                              Text(
                                s.$1,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.w900,
                                  height: 1.1,
                                  color: t.dark
                                      ? Colors.white
                                      : const Color(0xff143447),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                s.$2,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                  color: muted(context),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(slides.length, (i) {
                      final active = i == index;
                      return AnimatedContainer(
                        duration: 220.ms,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: active ? 26 : 9,
                        height: 9,
                        decoration: BoxDecoration(
                          color: active
                              ? t.primary
                              : t.primary.withValues(alpha: .25),
                          borderRadius: BorderRadius.circular(99),
                        ),
                      );
                    }),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: FilledButton.icon(
                      onPressed: () =>
                          ref.read(appStateProvider).completeOnboarding(),
                      icon: const Icon(Icons.play_arrow_rounded),
                      label: const Text('Mulai Belajar'),
                      style: bigButton(t.primary),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  final username = TextEditingController();
  final pass = TextEditingController();
  _AuthMode mode = _AuthMode.login;
  Gender gender = Gender.boy;
  bool showPass = false;
  bool loading = false;
  String? error;

  @override
  Widget build(BuildContext context) {
    final t = ref.watch(appStateProvider).theme;
    final register = mode == _AuthMode.register;
    return Scaffold(
      body: ThemedBackground(
        child: Stack(
          children: [
            const _FloatingShapes(),
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 460),
                    child: Column(
                      children: [
                        _MascotHero(theme: t, register: register),
                        const SizedBox(height: 18),
                        Text(
                          register
                              ? 'Create your new account'
                              : 'Welcome back!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                            color: t.dark
                                ? Colors.white
                                : const Color(0xff12384a),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          register
                              ? 'Username, password, lalu pilih avatar.'
                              : 'Login untuk lanjut berpetualang.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            color: muted(context),
                          ),
                        ),
                        const SizedBox(height: 22),
                        _GlassCard(
                          child: Column(
                            children: [
                              AppField(
                                controller: username,
                                label: 'Username',
                                icon: Icons.person_rounded,
                                hint: 'contoh: budi_ceria',
                              ),
                              AppField(
                                controller: pass,
                                label: 'Password',
                                icon: Icons.lock_rounded,
                                hint: 'minimal 6 karakter',
                                obscure: !showPass,
                                suffix: IconButton(
                                  onPressed: () =>
                                      setState(() => showPass = !showPass),
                                  icon: Icon(
                                    showPass
                                        ? Icons.visibility_off_rounded
                                        : Icons.visibility_rounded,
                                  ),
                                ),
                              ),
                              if (register) ...[
                                const SizedBox(height: 2),
                                Row(
                                  children: [
                                    Expanded(
                                      child: _GenderCard(
                                        label: 'Laki-laki',
                                        gender: Gender.boy,
                                        selected: gender == Gender.boy,
                                        onTap: () =>
                                            setState(() => gender = Gender.boy),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: _GenderCard(
                                        label: 'Perempuan',
                                        gender: Gender.girl,
                                        selected: gender == Gender.girl,
                                        onTap: () => setState(
                                          () => gender = Gender.girl,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                              if (error != null) ...[
                                const SizedBox(height: 12),
                                _ErrorBox(error!),
                              ],
                              const SizedBox(height: 16),
                              FilledButton.icon(
                                onPressed: loading ? null : _submit,
                                icon: loading
                                    ? const SizedBox.square(
                                        dimension: 18,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white,
                                        ),
                                      )
                                    : Icon(
                                        register
                                            ? Icons.person_add_rounded
                                            : Icons.login_rounded,
                                      ),
                                label: Text(register ? 'Register' : 'Login'),
                                style: bigButton(t.primary),
                              ),
                              const SizedBox(height: 16),
                              _DividerLabel(
                                label: register
                                    ? 'Or sign up with'
                                    : 'Or login with',
                              ),
                              const SizedBox(height: 14),
                              Row(
                                children: [
                                  Expanded(
                                    child: _SocialButton(
                                      label: 'Google',
                                      icon: Icons.g_mobiledata_rounded,
                                      onTap: () => _social('google'),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: _SocialButton(
                                      label: 'Phone',
                                      icon: Icons.phone_rounded,
                                      onTap: () => _social('phone'),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: _SocialButton(
                                      label: 'Apple',
                                      icon: Icons.apple_rounded,
                                      onTap: () => _social('apple'),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 18),
                        TextButton(
                          onPressed: () => setState(() {
                            mode = register
                                ? _AuthMode.login
                                : _AuthMode.register;
                            error = null;
                          }),
                          child: Text(
                            register
                                ? 'Sudah punya akun? Login'
                                : 'Belum punya akun? Register',
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              color: t.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (username.text.trim().length < 3) {
      return setState(() => error = 'Username minimal 3 karakter');
    }
    if (pass.text.length < 6) {
      return setState(() => error = 'Password minimal 6 karakter');
    }
    setState(() {
      loading = true;
      error = null;
    });
    try {
      await ref
          .read(appStateProvider)
          .login(
            nextEmail: username.text,
            password: pass.text,
            register: mode == _AuthMode.register,
            name: mode == _AuthMode.register ? username.text : null,
            nextGender: gender,
          );
    } catch (e) {
      setState(() => error = e.toString());
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  Future<void> _social(String provider) async {
    Feedback.forTap(context);
    final name = provider == 'phone' ? 'nomor_hp_user' : '${provider}_user';
    setState(() {
      loading = true;
      error = null;
    });
    try {
      await ref
          .read(appStateProvider)
          .login(
            nextEmail: name,
            password: 'social123',
            autoCreate: true,
            name: name,
            nextGender: gender,
          );
    } catch (e) {
      setState(() => error = e.toString());
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }
}

class _MascotHero extends StatelessWidget {
  const _MascotHero({required this.theme, required this.register});
  final AppThemeData theme;
  final bool register;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 190,
          height: 120,
          decoration: BoxDecoration(
            color: theme.primary.withValues(alpha: .16),
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(90),
              top: Radius.circular(40),
            ),
          ),
        ),
        Container(
              width: 140,
              height: 140,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.widgetBg,
                borderRadius: BorderRadius.circular(44),
                border: Border.all(color: theme.widgetBorder, width: 4),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 28,
                    color: theme.primary.withValues(alpha: .24),
                  ),
                ],
              ),
              child: Image.asset(
                register ? 'assets/images/Anak_hebat.png' : theme.asset,
                fit: BoxFit.contain,
              ),
            )
            .animate(onPlay: (c) => c.repeat(reverse: true))
            .moveY(begin: -7, end: 7, duration: 1700.ms),
      ],
    );
  }
}

class _GenderCard extends StatelessWidget {
  const _GenderCard({
    required this.label,
    required this.gender,
    required this.selected,
    required this.onTap,
  });
  final String label;
  final Gender gender;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = gender == Gender.boy
        ? const Color(0xff1D9BF0)
        : const Color(0xffF15BB5);
    return GestureDetector(
      onTap: () {
        Feedback.forTap(context);
        onTap();
      },
      child:
          AnimatedContainer(
                duration: 220.ms,
                padding: const EdgeInsets.symmetric(
                  vertical: 14,
                  horizontal: 8,
                ),
                decoration: BoxDecoration(
                  color: selected
                      ? color.withValues(alpha: .13)
                      : cardColor(context),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: selected ? color : color.withValues(alpha: .2),
                    width: selected ? 2.5 : 1.2,
                  ),
                  boxShadow: selected
                      ? [
                          BoxShadow(
                            blurRadius: 18,
                            color: color.withValues(alpha: .35),
                          ),
                        ]
                      : softShadow,
                ),
                child: Column(
                  children: [
                    Icon(
                      gender == Gender.boy
                          ? Icons.face_5_rounded
                          : Icons.face_3_rounded,
                      color: color,
                      size: 34,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      label,
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        color: selected ? color : muted(context),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              )
              .animate(target: selected ? 1 : 0)
              .scale(
                begin: const Offset(1, 1),
                end: const Offset(1.04, 1.04),
                duration: 180.ms,
              ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  const _SocialButton({
    required this.label,
    required this.icon,
    required this.onTap,
  });
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Ink(
        height: 50,
        decoration: BoxDecoration(
          color: cardColor(context),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: muted(context).withValues(alpha: .18)),
          boxShadow: softShadow,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 23),
            const SizedBox(width: 5),
            Flexible(
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 280.ms).slideY(begin: .08);
  }
}

class _GlassCard extends StatelessWidget {
  const _GlassCard({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final t = _themeOf(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(32),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: t.widgetBg.withValues(alpha: t.dark ? .72 : .82),
            borderRadius: BorderRadius.circular(32),
            border: Border.all(
              color: Colors.white.withValues(alpha: t.dark ? .12 : .55),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                blurRadius: 28,
                offset: const Offset(0, 14),
                color: Colors.black.withValues(alpha: t.dark ? .25 : .08),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}

class _DividerLabel extends StatelessWidget {
  const _DividerLabel({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Divider(color: muted(context).withValues(alpha: .25))),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: muted(context),
            ),
          ),
        ),
        Expanded(child: Divider(color: muted(context).withValues(alpha: .25))),
      ],
    );
  }
}

class _ErrorBox extends StatelessWidget {
  const _ErrorBox(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.red.shade700,
          fontWeight: FontWeight.w900,
          fontSize: 12,
        ),
      ),
    );
  }
}

class _FloatingShapes extends StatelessWidget {
  const _FloatingShapes();

  @override
  Widget build(BuildContext context) {
    final t = _themeOf(context);
    return Positioned.fill(
      child: IgnorePointer(
        child: Stack(
          children: List.generate(12, (i) {
            final left = (i * 67) % 360;
            final top = 30.0 + ((i * 91) % 720);
            final size = 18.0 + (i % 4) * 10;
            return Positioned(
              left: left.toDouble(),
              top: top,
              child:
                  Container(
                        width: size,
                        height: size,
                        decoration: BoxDecoration(
                          color: [
                            t.primary,
                            t.secondary,
                            t.accent,
                          ][i % 3].withValues(alpha: .12),
                          shape: i.isEven
                              ? BoxShape.circle
                              : BoxShape.rectangle,
                          borderRadius: i.isEven
                              ? null
                              : BorderRadius.circular(10),
                        ),
                      )
                      .animate(onPlay: (c) => c.repeat(reverse: true))
                      .moveY(begin: -8, end: 8, duration: (1600 + i * 140).ms),
            );
          }),
        ),
      ),
    );
  }
}
