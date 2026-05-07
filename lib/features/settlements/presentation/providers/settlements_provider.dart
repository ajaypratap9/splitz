import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/settlement_remote_datasource.dart';
import '../../domain/entities/settlement_entity.dart';
import '../../domain/settlement_algorithm.dart';

final settlementDsProvider = Provider((ref) => SettlementRemoteDataSource());

final netBalancesProvider = FutureProvider.family<List<NetBalance>, String>((ref, groupId) async => ref.read(settlementDsProvider).getNetBalances(groupId));

final calculatedSettlementsProvider = FutureProvider.family<List<SettlementEntity>, String>((ref, groupId) async {
  final balances = await ref.read(settlementDsProvider).getNetBalances(groupId);
  return SettlementCalculator().calculate(balances, groupId);
});

final existingSettlementsProvider = FutureProvider.family<List<SettlementEntity>, String>((ref, groupId) async => ref.read(settlementDsProvider).getSettlements(groupId));

final settlementNotifierProvider = Provider.family<SettlementNotifier, String>((ref, groupId) => SettlementNotifier(ref.read(settlementDsProvider), groupId, ref));

class SettlementNotifier {
  final SettlementRemoteDataSource _ds;
  final String groupId;
  final Ref _ref;
  SettlementNotifier(this._ds, this.groupId, this._ref);

  Future<void> markAsPaid(String settlementId) async {
    await _ds.markAsPaid(settlementId);
    _ref.invalidate(existingSettlementsProvider(groupId));
    _ref.invalidate(calculatedSettlementsProvider(groupId));
  }

  Future<void> recalculate() async {
    final balances = await _ds.getNetBalances(groupId);
    final settlements = SettlementCalculator().calculate(balances, groupId);
    await _ds.createSettlements(groupId, settlements);
    _ref.invalidate(existingSettlementsProvider(groupId));
    _ref.invalidate(calculatedSettlementsProvider(groupId));
  }
}
