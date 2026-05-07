import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../wallet/presentation/screens/wallet_tab.dart';
import '../../../expenses/presentation/screens/expenses_tab.dart';
import '../../../settlements/presentation/screens/settlements_tab.dart';
import '../../../analytics/presentation/screens/analytics_tab.dart';
import '../providers/groups_provider.dart';

class GroupDashboardScreen extends ConsumerStatefulWidget {
  final String groupId;
  const GroupDashboardScreen({super.key, required this.groupId});
  @override
  ConsumerState<GroupDashboardScreen> createState() => _GroupDashboardScreenState();
}

class _GroupDashboardScreenState extends ConsumerState<GroupDashboardScreen> with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;

  @override
  void initState() { super.initState(); _tabCtrl = TabController(length: 4, vsync: this); }
  @override
  void dispose() { _tabCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final groups = ref.watch(groupsProvider);
    final group = groups.valueOrNull?.where((g) => g.id == widget.groupId).firstOrNull;

    return Scaffold(
      appBar: AppBar(
        title: Row(children: [
          if (group != null) Text(group.emoji, style: const TextStyle(fontSize: 22)),
          const SizedBox(width: 8),
          Text(group?.name ?? 'Group', style: TextStyle(fontFamily: 'ClashDisplay', fontSize: 20, fontWeight: FontWeight.w600, color: isDark ? SplitzColors.darkText : SplitzColors.lightText)),
        ]),
        leading: IconButton(icon: const Icon(Icons.arrow_back_rounded), onPressed: () => context.go('/home')),
        bottom: TabBar(
          controller: _tabCtrl,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          labelColor: SplitzColors.accentPrimary,
          unselectedLabelColor: isDark ? SplitzColors.darkTextTertiary : SplitzColors.lightTextTertiary,
          labelStyle: const TextStyle(fontFamily: 'DMSans', fontSize: 14, fontWeight: FontWeight.w600),
          unselectedLabelStyle: const TextStyle(fontFamily: 'DMSans', fontSize: 14, fontWeight: FontWeight.w400),
          indicatorColor: SplitzColors.accentPrimary,
          indicatorWeight: 3,
          indicatorSize: TabBarIndicatorSize.label,
          dividerColor: Colors.transparent,
          tabs: const [Tab(text: 'Wallet'), Tab(text: 'Expenses'), Tab(text: 'Settlements'), Tab(text: 'Analytics')],
        ),
      ),
      body: TabBarView(controller: _tabCtrl, children: [
        WalletTab(groupId: widget.groupId),
        ExpensesTab(groupId: widget.groupId),
        SettlementsTab(groupId: widget.groupId),
        AnalyticsTab(groupId: widget.groupId),
      ]),
    );
  }
}
