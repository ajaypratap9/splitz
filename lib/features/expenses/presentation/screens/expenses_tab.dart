import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/date_formatter.dart';
import '../providers/expenses_provider.dart';
import '../widgets/expense_card.dart';
import 'package:go_router/go_router.dart';

class ExpensesTab extends ConsumerWidget {
  final String groupId;
  const ExpensesTab({super.key, required this.groupId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final expenses = ref.watch(expensesProvider(groupId));

    return Container(
      decoration: BoxDecoration(gradient: isDark ? SplitzColors.darkBgGradient : const LinearGradient(colors: [SplitzColors.lightBg, SplitzColors.lightBgSecondary], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
      child: Stack(children: [
        RefreshIndicator(
          onRefresh: () async => ref.invalidate(expensesProvider(groupId)),
          child: expenses.when(
            data: (list) {
              if (list.isEmpty) return Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
                Icon(Icons.receipt_long_rounded, size: 64, color: SplitzColors.accentPrimary.withOpacity(0.3)),
                const SizedBox(height: 16),
                Text('No expenses yet', style: TextStyle(fontFamily: 'ClashDisplay', fontSize: 18, fontWeight: FontWeight.w600, color: isDark ? SplitzColors.darkText : SplitzColors.lightText)),
                const SizedBox(height: 8),
                Text('Tap + to add your first expense', style: TextStyle(fontFamily: 'DMSans', fontSize: 14, color: isDark ? SplitzColors.darkTextTertiary : SplitzColors.lightTextTertiary)),
              ]));

              // Group by date
              final grouped = <String, List<dynamic>>{};
              for (final e in list) {
                final key = DateFormatter.formatDateHeader(e.date ?? e.createdAt ?? DateTime.now());
                grouped.putIfAbsent(key, () => []).add(e);
              }

              return ListView.builder(
                padding: SplitzSpacing.screenPadding,
                itemCount: grouped.length,
                itemBuilder: (context, index) {
                  final dateKey = grouped.keys.elementAt(index);
                  final items = grouped[dateKey]!;
                  return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Padding(padding: const EdgeInsets.only(top: 16, bottom: 8), child: Text(dateKey, style: TextStyle(fontFamily: 'DMSans', fontSize: 13, fontWeight: FontWeight.w600, color: isDark ? SplitzColors.darkTextTertiary : SplitzColors.lightTextTertiary))),
                    ...items.asMap().entries.map((entry) {
                      final e = entry.value;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: ExpenseCard(title: e.title, amount: e.amount, category: e.category, paidByName: e.paidByName, date: e.date ?? e.createdAt, onDelete: () => ref.read(expenseNotifierProvider(groupId)).deleteExpense(e.id)).animate().fadeIn(delay: Duration(milliseconds: 50 * entry.key), duration: 300.ms),
                      );
                    }),
                  ]);
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator(color: SplitzColors.accentPrimary)),
            error: (e, _) => Center(child: Text('Error: $e')),
          ),
        ),
        Positioned(
          bottom: 20, right: 20,
          child: Container(
            decoration: BoxDecoration(shape: BoxShape.circle, gradient: SplitzColors.splitzGradient, boxShadow: [BoxShadow(color: SplitzColors.accentPrimary.withOpacity(0.4), blurRadius: 16, offset: const Offset(0, 4))]),
            child: FloatingActionButton(
              heroTag: 'addExpense',
              backgroundColor: Colors.transparent,
              elevation: 0,
              onPressed: () => context.push('/group/$groupId/add-expense'),
              child: const Icon(Icons.add_rounded, color: Colors.white),
            ),
          ),
        ),
      ]),
    );
  }
}
