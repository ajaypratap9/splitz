import 'entities/settlement_entity.dart';

/// Greedy settlement calculator — minimizes number of transactions
class SettlementCalculator {
  List<SettlementEntity> calculate(List<NetBalance> balances, String groupId) {
    // Filter out zero balances
    final nonZero = balances.where((b) => b.netBalancePaise != 0).toList();
    if (nonZero.isEmpty) return [];

    // Separate creditors (net > 0, others owe them) and debtors (net < 0, they owe)
    final creditors = nonZero.where((b) => b.netBalancePaise > 0).toList()
      ..sort((a, b) => b.netBalancePaise.compareTo(a.netBalancePaise));
    final debtors = nonZero.where((b) => b.netBalancePaise < 0).toList()
      ..sort((a, b) => a.netBalancePaise.compareTo(b.netBalancePaise));

    if (creditors.isEmpty || debtors.isEmpty) return [];

    final credAmounts = creditors.map((c) => c.netBalancePaise).toList();
    final debtAmounts = debtors.map((d) => -d.netBalancePaise).toList(); // make positive

    final settlements = <SettlementEntity>[];
    int ci = 0, di = 0;

    while (ci < creditors.length && di < debtors.length) {
      if (credAmounts[ci] <= 0) { ci++; continue; }
      if (debtAmounts[di] <= 0) { di++; continue; }

      final settleAmount = credAmounts[ci] < debtAmounts[di] ? credAmounts[ci] : debtAmounts[di];

      settlements.add(SettlementEntity(
        id: '${debtors[di].userId}_${creditors[ci].userId}_$settleAmount',
        groupId: groupId,
        fromUser: debtors[di].userId,
        toUser: creditors[ci].userId,
        amount: settleAmount,
        fromUserName: debtors[di].fullName,
        toUserName: creditors[ci].fullName,
      ));

      credAmounts[ci] -= settleAmount;
      debtAmounts[di] -= settleAmount;

      if (credAmounts[ci] == 0) ci++;
      if (debtAmounts[di] == 0) di++;
    }

    return settlements;
  }
}
