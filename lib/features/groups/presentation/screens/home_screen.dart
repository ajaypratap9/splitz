import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_provider.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../auth/presentation/widgets/splitz_logo.dart';
import '../providers/groups_provider.dart';
import '../widgets/group_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final groups = ref.watch(groupsProvider);
    final user = ref.watch(userProfileProvider);
    final userName = user.valueOrNull?.fullName ?? 'there';

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: isDark ? SplitzColors.darkBgGradient : const LinearGradient(colors: [SplitzColors.lightBg, SplitzColors.lightBgSecondary], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
        child: SafeArea(child: CustomScrollView(slivers: [
          SliverToBoxAdapter(child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: Row(children: [
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const SplitzLogo(size: 26),
                const SizedBox(height: 12),
                Text('${DateFormatter.getGreeting()},', style: TextStyle(fontFamily: 'DMSans', fontSize: 14, color: isDark ? SplitzColors.darkTextSecondary : SplitzColors.lightTextSecondary)).animate().fadeIn(duration: 400.ms),
                Text('$userName 👋', style: TextStyle(fontFamily: 'ClashDisplay', fontSize: 26, fontWeight: FontWeight.w700, color: isDark ? SplitzColors.darkText : SplitzColors.lightText)).animate().fadeIn(delay: 100.ms, duration: 400.ms),
              ])),
              Row(children: [
                GestureDetector(
                  onTap: () => ref.read(themeProvider.notifier).toggleTheme(),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: 40, height: 40,
                    decoration: BoxDecoration(shape: BoxShape.circle, color: isDark ? Colors.white.withOpacity(0.08) : Colors.black.withOpacity(0.05)),
                    child: Icon(isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded, size: 20, color: isDark ? SplitzColors.darkTextSecondary : SplitzColors.lightTextSecondary),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () => context.push('/settings'),
                  child: Container(
                    width: 40, height: 40,
                    decoration: BoxDecoration(shape: BoxShape.circle, color: isDark ? Colors.white.withOpacity(0.08) : Colors.black.withOpacity(0.05)),
                    child: Icon(Icons.settings_rounded, size: 20, color: isDark ? SplitzColors.darkTextSecondary : SplitzColors.lightTextSecondary),
                  ),
                ),
              ]),
            ]),
          )),
          const SliverToBoxAdapter(child: SizedBox(height: 24)),
          groups.when(
            data: (list) {
              if (list.isEmpty) return SliverFillRemaining(child: _EmptyState());
              return SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: SliverList.separated(
                  itemCount: list.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) => GroupCard(group: list[index], onTap: () => context.push('/group/${list[index].id}')).animate().fadeIn(delay: Duration(milliseconds: 100 * index), duration: 400.ms).slideX(begin: 0.05, end: 0),
                ),
              );
            },
            loading: () => const SliverFillRemaining(child: Center(child: CircularProgressIndicator(color: SplitzColors.accentPrimary))),
            error: (e, _) => SliverFillRemaining(child: Center(child: Text('Error: $e'))),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ])),
      ),
      floatingActionButton: _GroupFab(),
    );
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Center(child: Padding(padding: const EdgeInsets.all(32), child: Column(mainAxisSize: MainAxisSize.min, children: [
      Icon(Icons.group_add_rounded, size: 80, color: SplitzColors.accentPrimary.withOpacity(0.3)),
      const SizedBox(height: 24),
      Text('No groups yet', style: TextStyle(fontFamily: 'ClashDisplay', fontSize: 22, fontWeight: FontWeight.w600, color: isDark ? SplitzColors.darkText : SplitzColors.lightText)),
      const SizedBox(height: 8),
      Text('Create your first group to start splitting expenses', textAlign: TextAlign.center, style: TextStyle(fontFamily: 'DMSans', fontSize: 14, color: isDark ? SplitzColors.darkTextSecondary : SplitzColors.lightTextSecondary)),
    ])));
  }
}

class _GroupFab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      FloatingActionButton.small(
        heroTag: 'join',
        backgroundColor: SplitzColors.accentSecondary,
        onPressed: () => context.push('/join-group'),
        child: const Icon(Icons.login_rounded, color: Colors.white, size: 20),
      ),
      const SizedBox(height: 12),
      Container(
        decoration: BoxDecoration(shape: BoxShape.circle, gradient: SplitzColors.splitzGradient, boxShadow: [BoxShadow(color: SplitzColors.accentPrimary.withOpacity(0.4), blurRadius: 16, offset: const Offset(0, 4))]),
        child: FloatingActionButton(
          heroTag: 'create',
          backgroundColor: Colors.transparent,
          elevation: 0,
          onPressed: () => context.push('/create-group'),
          child: const Icon(Icons.add_rounded, color: Colors.white, size: 28),
        ),
      ),
    ]);
  }
}
