import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../expenses/presentation/providers/expenses_provider.dart';

class AnalyticsTab extends ConsumerStatefulWidget {
  final String groupId;
  const AnalyticsTab({super.key, required this.groupId});
  @override
  ConsumerState<AnalyticsTab> createState() => _AnalyticsTabState();
}

class _AnalyticsTabState extends ConsumerState<AnalyticsTab> {
  String _period = 'All Time';
  final _periods = ['This Month', 'Last Month', 'All Time'];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final expenses = ref.watch(expensesProvider(widget.groupId));

    return Container(
      decoration: BoxDecoration(gradient: isDark ? SplitzColors.darkBgGradient : const LinearGradient(colors: [SplitzColors.lightBg, SplitzColors.lightBgSecondary], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
      child: expenses.when(
        data: (list) {
          // Filter by period
          final now = DateTime.now();
          final filtered = list.where((e) {
            final d = e.date ?? e.createdAt ?? now;
            if (_period == 'This Month') return d.month == now.month && d.year == now.year;
            if (_period == 'Last Month') { final lm = DateTime(now.year, now.month - 1); return d.month == lm.month && d.year == lm.year; }
            return true;
          }).toList();

          // Category breakdown
          final catMap = <String, int>{};
          for (final e in filtered) { catMap[e.category] = (catMap[e.category] ?? 0) + e.amount; }
          final totalSpend = filtered.fold<int>(0, (s, e) => s + e.amount);

          // Monthly spending (last 6 months)
          final monthlyMap = <String, int>{};
          for (int i = 5; i >= 0; i--) {
            final m = DateTime(now.year, now.month - i);
            final key = '${m.month}/${m.year % 100}';
            monthlyMap[key] = 0;
          }
          for (final e in list) {
            final d = e.date ?? e.createdAt ?? now;
            final key = '${d.month}/${d.year % 100}';
            if (monthlyMap.containsKey(key)) monthlyMap[key] = (monthlyMap[key] ?? 0) + e.amount;
          }

          return ListView(padding: SplitzSpacing.screenPadding, children: [
            const SizedBox(height: 8),
            SingleChildScrollView(scrollDirection: Axis.horizontal, child: Row(children: _periods.map((p) => Padding(padding: const EdgeInsets.only(right: 8), child: GestureDetector(
              onTap: () => setState(() => _period = p),
              child: AnimatedContainer(duration: const Duration(milliseconds: 200), padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8), decoration: BoxDecoration(gradient: _period == p ? SplitzColors.splitzGradient : null, color: _period == p ? null : (isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.03)), borderRadius: BorderRadius.circular(20)), child: Text(p, style: TextStyle(fontFamily: 'DMSans', fontSize: 13, fontWeight: FontWeight.w600, color: _period == p ? Colors.white : (isDark ? SplitzColors.darkTextSecondary : SplitzColors.lightTextSecondary)))),
            ))).toList())),
            const SizedBox(height: 24),
            // Total Spend Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(gradient: SplitzColors.splitzGradient, borderRadius: SplitzSpacing.borderRadiusLg),
              child: Column(children: [
                const Text('Total Spending', style: TextStyle(fontFamily: 'DMSans', fontSize: 13, color: Colors.white70)),
                const SizedBox(height: 4),
                Text(CurrencyFormatter.formatPaise(totalSpend), style: const TextStyle(fontFamily: 'JetBrainsMono', fontSize: 28, fontWeight: FontWeight.w700, color: Colors.white)),
              ]),
            ).animate().fadeIn(duration: 400.ms),
            const SizedBox(height: 24),
            // Category Pie Chart
            if (catMap.isNotEmpty) ...[
              Text('By Category', style: TextStyle(fontFamily: 'ClashDisplay', fontSize: 18, fontWeight: FontWeight.w600, color: isDark ? SplitzColors.darkText : SplitzColors.lightText)),
              const SizedBox(height: 16),
              SizedBox(height: 200, child: PieChart(PieChartData(
                sections: catMap.entries.map((e) {
                  final pct = totalSpend > 0 ? (e.value / totalSpend * 100) : 0.0;
                  final color = SplitzColors.getCategoryColor(e.key);
                  return PieChartSectionData(value: e.value.toDouble(), title: '${pct.round()}%', color: color, radius: 50, titleStyle: const TextStyle(fontFamily: 'DMSans', fontSize: 11, fontWeight: FontWeight.w600, color: Colors.white));
                }).toList(),
                centerSpaceRadius: 40,
                sectionsSpace: 2,
              ))).animate().fadeIn(delay: 200.ms, duration: 400.ms).scale(begin: const Offset(0.9, 0.9), end: const Offset(1, 1)),
              const SizedBox(height: 12),
              Wrap(spacing: 12, runSpacing: 6, children: catMap.entries.map((e) => Row(mainAxisSize: MainAxisSize.min, children: [
                Container(width: 10, height: 10, decoration: BoxDecoration(shape: BoxShape.circle, color: SplitzColors.getCategoryColor(e.key))),
                const SizedBox(width: 4),
                Text('${e.key[0].toUpperCase()}${e.key.substring(1)}: ${CurrencyFormatter.formatPaise(e.value)}', style: TextStyle(fontFamily: 'DMSans', fontSize: 12, color: isDark ? SplitzColors.darkTextSecondary : SplitzColors.lightTextSecondary)),
              ])).toList()),
            ],
            const SizedBox(height: 24),
            // Monthly Bar Chart
            Text('Monthly Trend', style: TextStyle(fontFamily: 'ClashDisplay', fontSize: 18, fontWeight: FontWeight.w600, color: isDark ? SplitzColors.darkText : SplitzColors.lightText)),
            const SizedBox(height: 16),
            SizedBox(height: 200, child: BarChart(BarChartData(
              barGroups: monthlyMap.entries.toList().asMap().entries.map((entry) {
                final val = entry.value.value.toDouble() / 100;
                return BarChartGroupData(x: entry.key, barRods: [BarChartRodData(toY: val, gradient: SplitzColors.splitzGradient, width: 18, borderRadius: const BorderRadius.vertical(top: Radius.circular(4)))]);
              }).toList(),
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, getTitlesWidget: (val, meta) { final keys = monthlyMap.keys.toList(); final idx = val.toInt(); if (idx >= 0 && idx < keys.length) return Text(keys[idx], style: TextStyle(fontFamily: 'DMSans', fontSize: 10, color: isDark ? SplitzColors.darkTextTertiary : SplitzColors.lightTextTertiary)); return const Text(''); })),
                leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              borderData: FlBorderData(show: false),
              gridData: const FlGridData(show: false),
            ))).animate().fadeIn(delay: 400.ms, duration: 400.ms),
            const SizedBox(height: 100),
          ]);
        },
        loading: () => const Center(child: CircularProgressIndicator(color: SplitzColors.accentPrimary)),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}
