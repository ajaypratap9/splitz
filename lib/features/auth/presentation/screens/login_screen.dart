import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/splitz_button.dart';
import '../providers/auth_provider.dart';
import '../widgets/splitz_logo.dart';
import '../widgets/auth_text_field.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});
  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() { _loading = true; _error = null; });
    final ok = await ref.read(authNotifierProvider.notifier).login(
      email: _emailCtrl.text.trim(), password: _passCtrl.text,
    );
    if (!mounted) return;
    setState(() => _loading = false);
    if (ok) { context.go('/home'); } else { setState(() => _error = 'Invalid email or password'); }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: Container(
        width: double.infinity, height: double.infinity,
        decoration: BoxDecoration(
          gradient: isDark ? SplitzColors.darkBgGradient : const LinearGradient(
            colors: [SplitzColors.lightBg, SplitzColors.lightBgSecondary],
            begin: Alignment.topCenter, end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: SplitzSpacing.screenPadding,
            child: Column(
              children: [
                const SizedBox(height: 60),
                const SplitzLogo(size: 48, showTagline: true).animate().fadeIn(duration: 600.ms),
                const SizedBox(height: 48),
                ClipRRect(
                  borderRadius: SplitzSpacing.borderRadiusXl,
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: isDark ? Colors.white.withOpacity(0.05) : Colors.white.withOpacity(0.85),
                        borderRadius: SplitzSpacing.borderRadiusXl,
                        border: Border.all(color: isDark ? Colors.white.withOpacity(0.08) : Colors.black.withOpacity(0.08)),
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text('Welcome back', style: TextStyle(fontFamily: 'ClashDisplay', fontSize: 24, fontWeight: FontWeight.w700, color: isDark ? SplitzColors.darkText : SplitzColors.lightText)),
                          const SizedBox(height: 4),
                          Text('Sign in to continue', style: TextStyle(fontFamily: 'DMSans', fontSize: 14, color: isDark ? SplitzColors.darkTextSecondary : SplitzColors.lightTextSecondary)),
                          const SizedBox(height: 24),
                          AuthTextField(controller: _emailCtrl, label: 'Email', hint: 'you@example.com', prefixIcon: Icons.email_outlined, keyboardType: TextInputType.emailAddress, validator: (v) => v == null || !v.contains('@') ? 'Valid email required' : null),
                          const SizedBox(height: 16),
                          AuthTextField(controller: _passCtrl, label: 'Password', hint: '••••••••', prefixIcon: Icons.lock_outline_rounded, isPassword: true, validator: (v) => v == null || v.isEmpty ? 'Password required' : null),
                          if (_error != null) ...[
                            const SizedBox(height: 12),
                            Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: SplitzColors.error.withOpacity(0.1), borderRadius: SplitzSpacing.borderRadiusSm), child: Row(children: [const Icon(Icons.error_outline, color: SplitzColors.error, size: 18), const SizedBox(width: 8), Expanded(child: Text(_error!, style: const TextStyle(fontFamily: 'DMSans', fontSize: 13, color: SplitzColors.error)))])),
                          ],
                          const SizedBox(height: 24),
                          SplitzButton(label: 'Sign In', onPressed: _login, isLoading: _loading, isFullWidth: true),
                        ]),
                      ),
                    ),
                  ),
                ).animate().fadeIn(delay: 300.ms, duration: 500.ms).slideY(begin: 0.1, end: 0),
                const SizedBox(height: 24),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text("Don't have an account? ", style: TextStyle(fontFamily: 'DMSans', fontSize: 14, color: isDark ? SplitzColors.darkTextSecondary : SplitzColors.lightTextSecondary)),
                  GestureDetector(
                    onTap: () => context.push('/signup'),
                    child: ShaderMask(shaderCallback: (b) => SplitzColors.splitzGradient.createShader(Rect.fromLTWH(0, 0, b.width, b.height)), child: const Text('Sign Up', style: TextStyle(fontFamily: 'DMSans', fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white))),
                  ),
                ]).animate().fadeIn(delay: 500.ms),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
