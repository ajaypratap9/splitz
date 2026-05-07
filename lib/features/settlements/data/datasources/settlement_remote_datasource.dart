import '../../../../core/config/supabase_config.dart';
import '../models/settlement_model.dart';
import '../../domain/entities/settlement_entity.dart';

class SettlementRemoteDataSource {
  final _client = SupabaseConfig.client;

  Future<List<NetBalance>> getNetBalances(String groupId) async {
    final data = await _client.rpc('calculate_net_balances', params: {'p_group_id': groupId});
    return (data as List).map((j) => NetBalance(userId: j['user_id'] as String, fullName: j['full_name'] as String? ?? 'User', netBalancePaise: (j['net_balance'] as num).toInt())).toList();
  }

  Future<List<SettlementModel>> getSettlements(String groupId) async {
    final data = await _client.from('settlements').select('*, from_profile:profiles!settlements_from_user_fkey(full_name), to_profile:profiles!settlements_to_user_fkey(full_name)').eq('group_id', groupId).order('created_at', ascending: false);
    return (data as List).map((j) => SettlementModel.fromJson(j)).toList();
  }

  Future<void> markAsPaid(String settlementId) async {
    await _client.from('settlements').update({'is_paid': true, 'paid_at': DateTime.now().toIso8601String()}).eq('id', settlementId);
  }

  Future<void> createSettlements(String groupId, List<SettlementEntity> settlements) async {
    final rows = settlements.map((s) => {'group_id': groupId, 'from_user': s.fromUser, 'to_user': s.toUser, 'amount': s.amount}).toList();
    if (rows.isNotEmpty) await _client.from('settlements').insert(rows);
  }
}
