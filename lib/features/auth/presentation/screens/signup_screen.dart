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

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});
  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;
  String? _error;
  double _passwordStrength = 0;

  @override
  void dispose() { _nameCtrl.dispose(); _emailCtrl.dispose(); _passCtrl.dispose(); _confirmCtrl.dispose(); super.dispose(); }

  void _calcStrength(String pass) {
    double s = 0;
    if (pass.length >= 6) s += 0.25;
    if (pass.length >= 10) s += 0.25;
    if (RegExp(r'[A-Z]').hasMatch(pass) && RegExp(r'[a-z]').hasMatch(pass)) s += 0.25;
    if (RegExp(r'[0-9!@#\$%^&*(),.?":{}|<>]').hasMatch(pass)) s += 0.25;
    setState(() => _passwordStrength = s);
  }

  Color get _strengthColor {
    if (_passwordStrength <= 0.25) return SplitzColors.error;
    if (_passwordStrength <= 0.5) return SplitzColors.warning;
    if (_passwordStrength <= 0.75) return SplitzColors.accentSecondary;
    return SplitzColors.success;
  }

  String get _strengthLabel {
    if (_passwordStrength <= 0.25) return 'Weak';
    if (_passwordStrength <= 0.5) return 'Fair';
    if (_passwordStrength <= 0.75) return 'Good';
    return 'Strong';
  }

  Future<void> _signup() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() { _loading = true; _error = null; });
    final ok = await ref.read(authNotifierProvider.notifier).signup(
      fullName: _nameCtrl.text.trim(), email: _emailCtrl.text.trim(), password: _passCtrl.text,
    );
    if (!mounted) return;
    setState(() => _loading = false);
    if (ok) { context.go('/home'); } else { setState(() => _error = 'Signup failed. Please try again.'); }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: Container(
        width: double.infinity, height: double.infinity,
        decoration: BoxDecoration(gradient: isDark ? SplitzColors.darkBgGradient : const LinearGradient(colors: [SplitzColors.lightBg, SplitzColors.lightBgSecondary], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
        child: SafeArea(child: SingleChildScrollView(padding: SplitzSpacing.screenPadding, child: Column(children: [
          const SizedBox(height: 32),
          const SplitzLogo(size: 40).animate().fadeIn(duration: 500.ms),
          const SizedBox(height: 32),
          ClipRRect(
            borderRadius: SplitzSpacing.borderRadiusXl,
            child: BackdropFilter(filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20), child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: isDark ? Colors.white.withOpacity(0.05) : Colors.white.withOpacity(0.85),
                borderRadius: SplitzSpacing.borderRadiusXl,
                border: Border.all(color: isDark ? Colors.white.withOpacity(0.08) : Colors.black.withOpacity(0.08)),
              ),
              child: Form(key: _formKey, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Create Account', style: TextStyle(fontFamily: 'ClashDisplay', fontSize: 24, fontWeight: FontWeight.w700, color: isDark ? SplitzColors.darkText : SplitzColors.lightText)),
                const SizedBox(height: 4),
                Text('Join Splitz and start splitting', style: TextStyle(fontFamily: 'DMSans', fontSize: 14, color: isDark ? SplitzColors.darkTextSecondary : SplitzColors.lightTextSecondary)),
                const SizedBox(height: 24),
                AuthTextField(controller: _nameCtrl, label: 'Full Name', prefixIcon: Icons.person_outline_rounded, validator: (v) => v == null || v.trim().isEmpty ? 'Name required' : null),
                const SizedBox(height: 16),
                AuthTextField(controller: _emailCtrl, label: 'Email', prefixIcon: Icons.email_outlined, keyboardType: TextInputType.emailAddress, validator: (v) => v == null || !v.contains('@') ? 'Valid email required' : null),
                const SizedBox(height: 16),
                AuthTextField(controller: _passCtrl, label: 'Password', prefixIcon: Icons.lock_outline_rounded, isPassword: true, onChanged: _calcStrength, validator: (v) => v == null || v.length < 6 ? 'Min 6 characters' : null),
                const SizedBox(height: 8),
                Row(children: [
                  Expanded(child: ClipRRect(borderRadius: BorderRadius.circular(4), child: LinearProgressIndicator(value: _passwordStrength, backgroundColor: isDark ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.1), valueColor: AlwaysStoppedAnimation(_strengthColor), minHeight: 4))),
                  const SizedBox(width: 8),
                  Text(_passCtrl.text.isEmpty ? '' : _strengthLabel, style: TextStyle(fontFamily: 'DMSans', fontSize: 12, color: _strengthColor, fontWeight: FontWeight.w500)),
                ]),
                const SizedBox(height: 16),
                AuthTextField(controller: _confirmCtrl, label: 'Confirm Password', prefixIcon: Icons.lock_outline_rounded, isPassword: true, validator: (v) => v != _passCtrl.text ? 'Passwords do not match' : null),
                if (_error != null) ...[
                  const SizedBox(height: 12),
                  Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: SplitzColors.error.withOpacity(0.1), borderRadius: SplitzSpacing.borderRadiusSm), child: Row(children: [const Icon(Icons.error_outline, color: SplitzColors.error, size: 18), const SizedBox(width: 8), Expanded(child: Text(_error!, style: const TextStyle(fontFamily: 'DMSans', fontSize: 13, color: SplitzColors.error)))])),
                ],
                const SizedBox(height: 24),
                SplitzButton(label: 'Create Account', onPressed: _signup, isLoading: _loading, isFullWidth: true),
              ])),
            )),
          ).animate().fadeIn(delay: 200.ms, duration: 500.ms).slideY(begin: 0.1, end: 0),
          const SizedBox(height: 24),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text('Already have an account? ', style: TextStyle(fontFamily: 'DMSans', fontSize: 14, color: isDark ? SplitzColors.darkTextSecondary : SplitzColors.lightTextSecondary)),
            GestureDetector(onTap: () => context.pop(), child: ShaderMask(shaderCallback: (b) => SplitzColors.splitzGradient.createShader(Rect.fromLTWH(0, 0, b.width, b.height)), child: const Text('Sign In', style: TextStyle(fontFamily: 'DMSans', fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white)))),
          ]).animate().fadeIn(delay: 400.ms),
          const SizedBox(height: 32),
        ]))),
      ),
    );
  }
}
