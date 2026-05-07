import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../groups/domain/entities/group_entity.dart';

class ParticipantSelector extends StatelessWidget {
  final List<GroupMemberEntity> members;
  final Set<String> selectedIds;
  final ValueChanged<String> onToggle;
  final VoidCallback onSelectAll;

  const ParticipantSelector({super.key, required this.members, required this.selectedIds, required this.onToggle, required this.onSelectAll});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text('Split with', style: TextStyle(fontFamily: 'DMSans', fontSize: 14, fontWeight: FontWeight.w500, color: isDark ? SplitzColors.darkTextSecondary : SplitzColors.lightTextSecondary)),
        GestureDetector(onTap: onSelectAll, child: Text(selectedIds.length == members.length ? 'Deselect All' : 'Select All', style: const TextStyle(fontFamily: 'DMSans', fontSize: 13, fontWeight: FontWeight.w600, color: SplitzColors.accentPrimary))),
      ]),
      const SizedBox(height: 12),
      Wrap(spacing: 8, runSpacing: 8, children: members.map((m) {
        final selected = selectedIds.contains(m.userId);
        return GestureDetector(
          onTap: () => onToggle(m.userId),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: selected ? SplitzColors.accentPrimary.withOpacity(0.12) : (isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.03)),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: selected ? SplitzColors.accentPrimary : Colors.transparent, width: 1.5),
            ),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              CircleAvatar(radius: 12, backgroundColor: SplitzColors.accentPrimary.withOpacity(0.2), child: Text((m.fullName ?? 'U')[0].toUpperCase(), style: const TextStyle(fontFamily: 'DMSans', fontSize: 11, fontWeight: FontWeight.w600, color: SplitzColors.accentPrimary))),
              const SizedBox(width: 6),
              Text(m.fullName ?? 'User', style: TextStyle(fontFamily: 'DMSans', fontSize: 13, fontWeight: selected ? FontWeight.w600 : FontWeight.w400, color: selected ? SplitzColors.accentPrimary : (isDark ? SplitzColors.darkTextSecondary : SplitzColors.lightTextSecondary))),
              if (selected) ...[const SizedBox(width: 4), const Icon(Icons.check_circle_rounded, size: 16, color: SplitzColors.accentPrimary)],
            ]),
          ),
        );
      }).toList()),
    ]);
  }
}
