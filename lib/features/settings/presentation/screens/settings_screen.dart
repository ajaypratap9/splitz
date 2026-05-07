import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_provider.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../../../../shared/widgets/splitz_button.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final user = ref.watch(userProfileProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Container(
        decoration: BoxDecoration(gradient: isDark ? SplitzColors.darkBgGradient : const LinearGradient(colors: [SplitzColors.lightBg, SplitzColors.lightBgSecondary], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
        child: ListView(padding: SplitzSpacing.screenPadding, children: [
          const SizedBox(height: 8),
          // Profile Section
          GlassCard(
            padding: const EdgeInsets.all(20),
            child: user.when(
              data: (u) => Row(children: [
                CircleAvatar(radius: 28, backgroundColor: SplitzColors.accentPrimary.withOpacity(0.15), child: Text((u?.fullName ?? 'U')[0].toUpperCase(), style: const TextStyle(fontFamily: 'ClashDisplay', fontSize: 22, fontWeight: FontWeight.w700, color: SplitzColors.accentPrimary))),
                const SizedBox(width: 16),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(u?.fullName ?? 'User', style: TextStyle(fontFamily: 'ClashDisplay', fontSize: 18, fontWeight: FontWeight.w600, color: isDark ? SplitzColors.darkText : SplitzColors.lightText)),
                  const SizedBox(height: 2),
                  Text(u?.email ?? 'No email', style: TextStyle(fontFamily: 'DMSans', fontSize: 13, color: isDark ? SplitzColors.darkTextSecondary : SplitzColors.lightTextSecondary)),
                ])),
              ]),
              loading: () => const Center(child: CircularProgressIndicator(color: SplitzColors.accentPrimary)),
              error: (e, _) => Text('Error: $e'),
            ),
          ).animate().fadeIn(duration: 400.ms),
          const SizedBox(height: 24),
          // Theme Section
          Text('Appearance', style: TextStyle(fontFamily: 'ClashDisplay', fontSize: 16, fontWeight: FontWeight.w600, color: isDark ? SplitzColors.darkText : SplitzColors.lightText)),
          const SizedBox(height: 12),
          GlassCard(
            padding: const EdgeInsets.all(16),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Row(children: [
                Icon(isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded, color: SplitzColors.accentPrimary, size: 22),
                const SizedBox(width: 12),
                Text(isDark ? 'Dark Mode' : 'Light Mode', style: TextStyle(fontFamily: 'DMSans', fontSize: 15, fontWeight: FontWeight.w500, color: isDark ? SplitzColors.darkText : SplitzColors.lightText)),
              ]),
              Switch(
                value: isDark,
                onChanged: (_) => ref.read(themeProvider.notifier).toggleTheme(),
                activeColor: SplitzColors.accentPrimary,
              ),
            ]),
          ).animate().fadeIn(delay: 100.ms, duration: 400.ms),
          const SizedBox(height: 12),
          // Theme preview mini cards
          Row(children: [
            Expanded(child: GestureDetector(
              onTap: () => ref.read(themeProvider.notifier).setTheme(ThemeMode.light),
              child: Container(height: 60, decoration: BoxDecoration(color: SplitzColors.lightBg, borderRadius: SplitzSpacing.borderRadiusMd, border: Border.all(color: !isDark ? SplitzColors.accentPrimary : Colors.transparent, width: 2)), child: const Center(child: Text('Light', style: TextStyle(fontFamily: 'DMSans', fontSize: 13, fontWeight: FontWeight.w600, color: SplitzColors.lightText)))),
            )),
            const SizedBox(width: 12),
            Expanded(child: GestureDetector(
              onTap: () => ref.read(themeProvider.notifier).setTheme(ThemeMode.dark),
              child: Container(height: 60, decoration: BoxDecoration(color: SplitzColors.darkBg, borderRadius: SplitzSpacing.borderRadiusMd, border: Border.all(color: isDark ? SplitzColors.accentPrimary : Colors.transparent, width: 2)), child: const Center(child: Text('Dark', style: TextStyle(fontFamily: 'DMSans', fontSize: 13, fontWeight: FontWeight.w600, color: SplitzColors.darkText)))),
            )),
          ]).animate().fadeIn(delay: 200.ms, duration: 400.ms),
          const SizedBox(height: 32),
          // App Info
          Text('About', style: TextStyle(fontFamily: 'ClashDisplay', fontSize: 16, fontWeight: FontWeight.w600, color: isDark ? SplitzColors.darkText : SplitzColors.lightText)),
          const SizedBox(height: 12),
          GlassCard(padding: const EdgeInsets.all(16), child: Column(children: [
            _InfoRow(label: 'Version', value: '1.0.0', isDark: isDark),
            const Divider(height: 16),
            _InfoRow(label: 'Build', value: '1', isDark: isDark),
          ])).animate().fadeIn(delay: 300.ms, duration: 400.ms),
          const SizedBox(height: 32),
          SplitzButton(
            label: 'Logout',
            isOutlined: true,
            isFullWidth: true,
            icon: Icons.logout_rounded,
            onPressed: () async {
              final confirm = await showDialog<bool>(context: context, builder: (ctx) => AlertDialog(title: const Text('Logout?'), content: const Text('Are you sure you want to logout?'), actions: [TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')), TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Logout', style: TextStyle(color: SplitzColors.error)))]));
              if (confirm == true) { await ref.read(authNotifierProvider.notifier).logout(); if (context.mounted) context.go('/login'); }
            },
          ).animate().fadeIn(delay: 400.ms, duration: 400.ms),
          const SizedBox(height: 32),
        ]),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isDark;
  const _InfoRow({required this.label, required this.value, required this.isDark});
  @override
  Widget build(BuildContext context) => Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
    Text(label, style: TextStyle(fontFamily: 'DMSans', fontSize: 14, color: isDark ? SplitzColors.darkTextSecondary : SplitzColors.lightTextSecondary)),
    Text(value, style: TextStyle(fontFamily: 'DMSans', fontSize: 14, fontWeight: FontWeight.w500, color: isDark ? SplitzColors.darkText : SplitzColors.lightText)),
  ]);
}
