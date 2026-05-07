import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/config/supabase_config.dart';
import '../../../../shared/widgets/splitz_button.dart';
import '../../../../shared/widgets/category_chip.dart';
import '../../../groups/presentation/providers/groups_provider.dart';
import '../providers/expenses_provider.dart';
import '../../domain/split_engine/equal_split_strategy.dart';
import '../widgets/participant_selector.dart';

class AddExpenseScreen extends ConsumerStatefulWidget {
  final String groupId;
  const AddExpenseScreen({super.key, required this.groupId});
  @override
  ConsumerState<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends ConsumerState<AddExpenseScreen> {
  final _titleCtrl = TextEditingController();
  final _amountCtrl = TextEditingController();
  String _category = 'general';
  String? _paidBy;
  final Set<String> _participants = {};
  bool _loading = false;
  final _categories = ['food', 'travel', 'shopping', 'entertainment', 'utilities', 'general'];

  @override
  void initState() { super.initState(); _paidBy = SupabaseConfig.client.auth.currentUser?.id; }
  @override
  void dispose() { _titleCtrl.dispose(); _amountCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final members = ref.watch(groupMembersProvider(widget.groupId));
    final amountText = _amountCtrl.text;
    final amountVal = double.tryParse(amountText) ?? 0;
    final splitPreview = _participants.isNotEmpty && amountVal > 0 ? amountVal / _participants.length : 0.0;

    return Scaffold(
      appBar: AppBar(title: const Text('Add Expense'), leading: IconButton(icon: const Icon(Icons.close_rounded), onPressed: () => context.pop())),
      body: Container(
        decoration: BoxDecoration(gradient: isDark ? SplitzColors.darkBgGradient : const LinearGradient(colors: [SplitzColors.lightBg, SplitzColors.lightBgSecondary], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
        child: SingleChildScrollView(padding: SplitzSpacing.screenPadding, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Center(child: Column(children: [
            Text('₹', style: TextStyle(fontFamily: 'JetBrainsMono', fontSize: 20, color: isDark ? SplitzColors.darkTextTertiary : SplitzColors.lightTextTertiary)),
            SizedBox(
              width: 200,
              child: TextField(
                controller: _amountCtrl,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                textAlign: TextAlign.center,
                onChanged: (_) => setState(() {}),
                style: TextStyle(fontFamily: 'JetBrainsMono', fontSize: 42, fontWeight: FontWeight.w700, color: isDark ? SplitzColors.darkText : SplitzColors.lightText),
                decoration: InputDecoration(hintText: '0.00', hintStyle: TextStyle(color: isDark ? SplitzColors.darkTextTertiary : SplitzColors.lightTextTertiary), border: InputBorder.none, enabledBorder: InputBorder.none, focusedBorder: InputBorder.none),
              ),
            ),
          ])).animate().fadeIn(duration: 400.ms),
          const SizedBox(height: 16),
          TextFormField(controller: _titleCtrl, decoration: const InputDecoration(labelText: 'What was it for?', hintText: 'e.g. Dinner at Taj'), style: TextStyle(fontFamily: 'DMSans', color: isDark ? SplitzColors.darkText : SplitzColors.lightText)).animate().fadeIn(delay: 100.ms),
          const SizedBox(height: 20),
          Text('Category', style: TextStyle(fontFamily: 'DMSans', fontSize: 14, fontWeight: FontWeight.w500, color: isDark ? SplitzColors.darkTextSecondary : SplitzColors.lightTextSecondary)),
          const SizedBox(height: 8),
          SingleChildScrollView(scrollDirection: Axis.horizontal, child: Row(children: _categories.map((c) => Padding(padding: const EdgeInsets.only(right: 8), child: CategoryChip(category: c, isSelected: _category == c, onTap: () => setState(() => _category = c)))).toList())).animate().fadeIn(delay: 200.ms),
          const SizedBox(height: 20),
          members.when(
            data: (memberList) {
              if (_participants.isEmpty && memberList.isNotEmpty) {
                WidgetsBinding.instance.addPostFrameCallback((_) { if (mounted) setState(() { for (final m in memberList) _participants.add(m.userId); }); });
              }
              return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Paid by', style: TextStyle(fontFamily: 'DMSans', fontSize: 14, fontWeight: FontWeight.w500, color: isDark ? SplitzColors.darkTextSecondary : SplitzColors.lightTextSecondary)),
                const SizedBox(height: 8),
                SingleChildScrollView(scrollDirection: Axis.horizontal, child: Row(children: memberList.map((m) {
                  final selected = _paidBy == m.userId;
                  return Padding(padding: const EdgeInsets.only(right: 8), child: GestureDetector(
                    onTap: () => setState(() => _paidBy = m.userId),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: selected ? SplitzColors.accentPrimary.withOpacity(0.12) : (isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.03)), border: Border.all(color: selected ? SplitzColors.accentPrimary : Colors.transparent)),
                      child: Text(m.fullName ?? 'User', style: TextStyle(fontFamily: 'DMSans', fontSize: 13, fontWeight: selected ? FontWeight.w600 : FontWeight.w400, color: selected ? SplitzColors.accentPrimary : (isDark ? SplitzColors.darkTextSecondary : SplitzColors.lightTextSecondary))),
                    ),
                  ));
                }).toList())),
                const SizedBox(height: 20),
                ParticipantSelector(members: memberList, selectedIds: _participants, onToggle: (id) => setState(() { if (_participants.contains(id)) _participants.remove(id); else _participants.add(id); }), onSelectAll: () => setState(() { if (_participants.length == memberList.length) _participants.clear(); else { for (final m in memberList) _participants.add(m.userId); } })),
              ]);
            },
            loading: () => const Center(child: CircularProgressIndicator(color: SplitzColors.accentPrimary)),
            error: (e, _) => Text('Error loading members: $e'),
          ).animate().fadeIn(delay: 300.ms),
          if (_participants.isNotEmpty && amountVal > 0) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: SplitzColors.accentPrimary.withOpacity(0.08), borderRadius: BorderRadius.circular(10)),
              child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                const Icon(Icons.info_outline_rounded, size: 16, color: SplitzColors.accentPrimary),
                const SizedBox(width: 8),
                Text('Each person owes ${CurrencyFormatter.formatRupees(splitPreview)}', style: const TextStyle(fontFamily: 'DMSans', fontSize: 13, fontWeight: FontWeight.w600, color: SplitzColors.accentPrimary)),
              ]),
            ).animate().fadeIn(duration: 300.ms),
          ],
          const SizedBox(height: 32),
          SplitzButton(label: 'Add Expense', onPressed: _submit, isLoading: _loading, isFullWidth: true).animate().fadeIn(delay: 400.ms),
          const SizedBox(height: 32),
        ])),
      ),
    );
  }

  Future<void> _submit() async {
    final amount = double.tryParse(_amountCtrl.text);
    if (amount == null || amount <= 0 || _titleCtrl.text.trim().isEmpty || _paidBy == null || _participants.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please fill in all fields')));
      return;
    }
    setState(() => _loading = true);
    final amountPaise = CurrencyFormatter.rupeesToPaise(amount);
    final strategy = EqualSplitStrategy();
    final shares = strategy.calculate(totalAmountPaise: amountPaise, participantIds: _participants.toList());
    final participantData = shares.map((s) => {'user_id': s.userId, 'share_amount': s.shareAmountPaise, 'share_percentage': s.sharePercentage}).toList();
    try {
      await ref.read(expenseNotifierProvider(widget.groupId)).addExpense(title: _titleCtrl.text.trim(), amount: amountPaise, category: _category, paidBy: _paidBy!, splitType: 'equal', participants: participantData);
      if (mounted) { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Expense added! 🎉'))); context.pop(); }
    } catch (e) { if (mounted) { setState(() => _loading = false); ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e'))); } }
  }
}
