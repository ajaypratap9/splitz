import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../../../../shared/widgets/animated_counter.dart';
import '../providers/wallet_provider.dart';

class WalletTab extends ConsumerWidget {
  final String groupId;
  const WalletTab({super.key, required this.groupId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final balance = ref.watch(walletBalanceProvider(groupId));
    final transactions = ref.watch(walletTransactionsProvider(groupId));

    return Container(
      decoration: BoxDecoration(gradient: isDark ? SplitzColors.darkBgGradient : const LinearGradient(colors: [SplitzColors.lightBg, SplitzColors.lightBgSecondary], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
      child: RefreshIndicator(
        onRefresh: () async { ref.invalidate(walletBalanceProvider(groupId)); ref.invalidate(walletTransactionsProvider(groupId)); },
        child: ListView(padding: SplitzSpacing.screenPadding, children: [
          const SizedBox(height: 8),
          GlassCard(
            padding: const EdgeInsets.all(24),
            child: Column(children: [
              Text('Total Balance', style: TextStyle(fontFamily: 'DMSans', fontSize: 13, color: isDark ? SplitzColors.darkTextSecondary : SplitzColors.lightTextSecondary)),
              const SizedBox(height: 8),
              balance.when(
                data: (val) => AnimatedCounter(value: CurrencyFormatter.paiseToRupees(val), style: TextStyle(fontFamily: 'JetBrainsMono', fontSize: 36, fontWeight: FontWeight.w700, color: val >= 0 ? SplitzColors.success : SplitzColors.error)),
                loading: () => const CircularProgressIndicator(color: SplitzColors.accentPrimary),
                error: (e, _) => Text('Error', style: TextStyle(color: SplitzColors.error)),
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () => _showAddMoney(context, ref),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(gradient: SplitzColors.splitzGradient, borderRadius: BorderRadius.circular(10)),
                  child: const Row(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.add_rounded, color: Colors.white, size: 18), SizedBox(width: 6), Text('Add Money', style: TextStyle(fontFamily: 'DMSans', fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white))]),
                ),
              ),
            ]),
          ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.05, end: 0),
          const SizedBox(height: 24),
          Text('Transaction History', style: TextStyle(fontFamily: 'ClashDisplay', fontSize: 18, fontWeight: FontWeight.w600, color: isDark ? SplitzColors.darkText : SplitzColors.lightText)),
          const SizedBox(height: 12),
          transactions.when(
            data: (list) {
              if (list.isEmpty) return Padding(padding: const EdgeInsets.all(32), child: Center(child: Text('No transactions yet', style: TextStyle(fontFamily: 'DMSans', color: isDark ? SplitzColors.darkTextTertiary : SplitzColors.lightTextTertiary))));
              return Column(children: list.asMap().entries.map((entry) {
                final t = entry.value;
                final isCredit = t.type == 'credit';
                return GlassCard(
                  padding: const EdgeInsets.all(12),
                  child: Row(children: [
                    Container(width: 36, height: 36, decoration: BoxDecoration(shape: BoxShape.circle, color: (isCredit ? SplitzColors.success : SplitzColors.error).withOpacity(0.1)), child: Icon(isCredit ? Icons.arrow_downward_rounded : Icons.arrow_upward_rounded, size: 18, color: isCredit ? SplitzColors.success : SplitzColors.error)),
                    const SizedBox(width: 12),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(t.userName ?? 'User', style: TextStyle(fontFamily: 'DMSans', fontSize: 14, fontWeight: FontWeight.w500, color: isDark ? SplitzColors.darkText : SplitzColors.lightText)),
                      if (t.note != null) Text(t.note!, style: TextStyle(fontFamily: 'DMSans', fontSize: 12, color: isDark ? SplitzColors.darkTextTertiary : SplitzColors.lightTextTertiary)),
                    ])),
                    Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                      Text('${isCredit ? '+' : '-'}${CurrencyFormatter.formatPaise(t.amount)}', style: TextStyle(fontFamily: 'JetBrainsMono', fontSize: 14, fontWeight: FontWeight.w600, color: isCredit ? SplitzColors.success : SplitzColors.error)),
                      if (t.createdAt != null) Text(DateFormatter.formatRelative(t.createdAt!), style: TextStyle(fontFamily: 'DMSans', fontSize: 11, color: isDark ? SplitzColors.darkTextTertiary : SplitzColors.lightTextTertiary)),
                    ]),
                  ]),
                );
              }).toList());
            },
            loading: () => const Center(child: CircularProgressIndicator(color: SplitzColors.accentPrimary)),
            error: (e, _) => Center(child: Text('Error: $e')),
          ),
          const SizedBox(height: 100),
        ]),
      ),
    );
  }

  void _showAddMoney(BuildContext context, WidgetRef ref) {
    final amtCtrl = TextEditingController();
    final noteCtrl = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: EdgeInsets.fromLTRB(20, 20, 20, MediaQuery.of(ctx).viewInsets.bottom + 20),
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Add Money', style: TextStyle(fontFamily: 'ClashDisplay', fontSize: 20, fontWeight: FontWeight.w600)),
          const SizedBox(height: 16),
          TextField(controller: amtCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Amount (₹)', prefixText: '₹ ')),
          const SizedBox(height: 12),
          TextField(controller: noteCtrl, decoration: const InputDecoration(labelText: 'Note (optional)')),
          const SizedBox(height: 20),
          SizedBox(width: double.infinity, height: 48, child: ElevatedButton(
            onPressed: () async {
              final amt = double.tryParse(amtCtrl.text);
              if (amt == null || amt <= 0) return;
              final paise = CurrencyFormatter.rupeesToPaise(amt);
              await ref.read(walletNotifierProvider(groupId)).addMoney(paise, noteCtrl.text.isEmpty ? null : noteCtrl.text);
              if (ctx.mounted) Navigator.pop(ctx);
            },
            child: const Text('Add'),
          )),
        ]),
      ),
    );
  }
}
