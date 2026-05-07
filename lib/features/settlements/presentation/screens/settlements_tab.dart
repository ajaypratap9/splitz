import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../../../../shared/widgets/splitz_button.dart';
import '../providers/settlements_provider.dart';

class SettlementsTab extends ConsumerWidget {
  final String groupId;
  const SettlementsTab({super.key, required this.groupId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final settlements = ref.watch(calculatedSettlementsProvider(groupId));

    return Container(
      decoration: BoxDecoration(gradient: isDark ? SplitzColors.darkBgGradient : const LinearGradient(colors: [SplitzColors.lightBg, SplitzColors.lightBgSecondary], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
      child: RefreshIndicator(
        onRefresh: () async { ref.invalidate(calculatedSettlementsProvider(groupId)); },
        child: ListView(padding: SplitzSpacing.screenPadding, children: [
          const SizedBox(height: 8),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('What needs to be settled', style: TextStyle(fontFamily: 'ClashDisplay', fontSize: 18, fontWeight: FontWeight.w600, color: isDark ? SplitzColors.darkText : SplitzColors.lightText)),
            GestureDetector(
              onTap: () => ref.read(settlementNotifierProvider(groupId)).recalculate(),
              child: Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), decoration: BoxDecoration(color: SplitzColors.accentPrimary.withOpacity(0.1), borderRadius: BorderRadius.circular(8)), child: const Row(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.refresh_rounded, size: 16, color: SplitzColors.accentPrimary), SizedBox(width: 4), Text('Recalculate', style: TextStyle(fontFamily: 'DMSans', fontSize: 12, fontWeight: FontWeight.w600, color: SplitzColors.accentPrimary))])),
            ),
          ]),
          const SizedBox(height: 16),
          settlements.when(
            data: (list) {
              if (list.isEmpty) return Padding(padding: const EdgeInsets.all(32), child: Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
                Icon(Icons.check_circle_outline_rounded, size: 64, color: SplitzColors.success.withOpacity(0.5)),
                const SizedBox(height: 16),
                Text('All settled up! 🎉', style: TextStyle(fontFamily: 'ClashDisplay', fontSize: 20, fontWeight: FontWeight.w600, color: isDark ? SplitzColors.darkText : SplitzColors.lightText)),
              ])));
              return Column(children: list.asMap().entries.map((entry) {
                final s = entry.value;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: GlassCard(
                    padding: const EdgeInsets.all(16),
                    child: Row(children: [
                      CircleAvatar(radius: 18, backgroundColor: SplitzColors.error.withOpacity(0.1), child: Text((s.fromUserName ?? 'U')[0], style: const TextStyle(fontFamily: 'DMSans', fontSize: 14, fontWeight: FontWeight.w600, color: SplitzColors.error))),
                      const SizedBox(width: 8),
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        RichText(text: TextSpan(style: TextStyle(fontFamily: 'DMSans', fontSize: 14, color: isDark ? SplitzColors.darkText : SplitzColors.lightText), children: [
                          TextSpan(text: s.fromUserName ?? 'User', style: const TextStyle(fontWeight: FontWeight.w600)),
                          const TextSpan(text: ' owes '),
                          TextSpan(text: s.toUserName ?? 'User', style: const TextStyle(fontWeight: FontWeight.w600)),
                        ])),
                        const SizedBox(height: 2),
                        Text(CurrencyFormatter.formatPaise(s.amount), style: const TextStyle(fontFamily: 'JetBrainsMono', fontSize: 16, fontWeight: FontWeight.w700, color: SplitzColors.accentPrimary)),
                      ])),
                      CircleAvatar(radius: 18, backgroundColor: SplitzColors.success.withOpacity(0.1), child: Text((s.toUserName ?? 'U')[0], style: const TextStyle(fontFamily: 'DMSans', fontSize: 14, fontWeight: FontWeight.w600, color: SplitzColors.success))),
                    ]),
                  ).animate().fadeIn(delay: Duration(milliseconds: 100 * entry.key), duration: 300.ms),
                );
              }).toList());
            },
            loading: () => const Center(child: Padding(padding: EdgeInsets.all(32), child: CircularProgressIndicator(color: SplitzColors.accentPrimary))),
            error: (e, _) => Center(child: Text('Error: $e')),
          ),
          const SizedBox(height: 100),
        ]),
      ),
    );
  }
}
