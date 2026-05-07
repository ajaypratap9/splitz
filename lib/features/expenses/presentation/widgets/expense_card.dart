import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/utils/date_formatter.dart';

class ExpenseCard extends StatelessWidget {
  final String title;
  final int amount;
  final String category;
  final String? paidByName;
  final DateTime? date;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const ExpenseCard({super.key, required this.title, required this.amount, this.category = 'general', this.paidByName, this.date, this.onTap, this.onDelete});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final catColor = SplitzColors.getCategoryColor(category);
    final catIcon = SplitzColors.getCategoryIcon(category);

    return Dismissible(
      key: Key(title + amount.toString()),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDelete?.call(),
      confirmDismiss: (_) async {
        return await showDialog<bool>(context: context, builder: (ctx) => AlertDialog(title: const Text('Delete Expense?'), content: const Text('This action cannot be undone.'), actions: [TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')), TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Delete', style: TextStyle(color: SplitzColors.error)))])) ?? false;
      },
      background: Container(alignment: Alignment.centerRight, padding: const EdgeInsets.only(right: 20), decoration: BoxDecoration(color: SplitzColors.error.withOpacity(0.1), borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.delete_rounded, color: SplitzColors.error)),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isDark ? Colors.white.withOpacity(0.03) : Colors.white.withOpacity(0.7),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: isDark ? Colors.white.withOpacity(0.06) : Colors.black.withOpacity(0.06)),
          ),
          child: Row(children: [
            Container(width: 40, height: 40, decoration: BoxDecoration(color: catColor.withOpacity(0.12), borderRadius: BorderRadius.circular(10)), child: Icon(catIcon, size: 20, color: catColor)),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title, style: TextStyle(fontFamily: 'DMSans', fontSize: 14, fontWeight: FontWeight.w500, color: isDark ? SplitzColors.darkText : SplitzColors.lightText)),
              const SizedBox(height: 2),
              Text('Paid by ${paidByName ?? 'Unknown'}', style: TextStyle(fontFamily: 'DMSans', fontSize: 12, color: isDark ? SplitzColors.darkTextTertiary : SplitzColors.lightTextTertiary)),
            ])),
            Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
              Text(CurrencyFormatter.formatPaise(amount), style: TextStyle(fontFamily: 'JetBrainsMono', fontSize: 15, fontWeight: FontWeight.w600, color: isDark ? SplitzColors.darkText : SplitzColors.lightText)),
              if (date != null) Text(DateFormatter.formatRelative(date!), style: TextStyle(fontFamily: 'DMSans', fontSize: 11, color: isDark ? SplitzColors.darkTextTertiary : SplitzColors.lightTextTertiary)),
            ]),
          ]),
        ),
      ),
    );
  }
}
