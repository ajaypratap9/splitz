import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../../domain/entities/group_entity.dart';

class GroupCard extends StatelessWidget {
  final GroupEntity group;
  final int netBalance;
  final VoidCallback onTap;

  const GroupCard({super.key, required this.group, this.netBalance = 0, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GlassCard(
      onTap: onTap,
      padding: const EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(
            width: 44, height: 44,
            decoration: BoxDecoration(color: SplitzColors.accentPrimary.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
            child: Center(child: Text(group.emoji, style: const TextStyle(fontSize: 22))),
          ),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(group.name, style: TextStyle(fontFamily: 'ClashDisplay', fontSize: 17, fontWeight: FontWeight.w600, color: isDark ? SplitzColors.darkText : SplitzColors.lightText)),
            const SizedBox(height: 2),
            Text('${group.memberCount} members', style: TextStyle(fontFamily: 'DMSans', fontSize: 12, color: isDark ? SplitzColors.darkTextTertiary : SplitzColors.lightTextTertiary)),
          ])),
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Text(netBalance >= 0 ? 'you are owed' : 'you owe', style: TextStyle(fontFamily: 'DMSans', fontSize: 11, color: isDark ? SplitzColors.darkTextTertiary : SplitzColors.lightTextTertiary)),
            const SizedBox(height: 2),
            Text(CurrencyFormatter.formatPaise(netBalance.abs()), style: TextStyle(fontFamily: 'JetBrainsMono', fontSize: 16, fontWeight: FontWeight.w700, color: netBalance >= 0 ? SplitzColors.success : SplitzColors.error)),
          ]),
        ]),
      ]),
    );
  }
}
