import '../../../../core/config/supabase_config.dart';
import '../models/wallet_model.dart';

class WalletRemoteDataSource {
  final _client = SupabaseConfig.client;

  Future<List<WalletTransactionModel>> getTransactions(String groupId) async {
    final data = await _client.from('wallet_transactions').select('*, profiles(full_name)').eq('group_id', groupId).order('created_at', ascending: false);
    return (data as List).map((j) => WalletTransactionModel.fromJson(j)).toList();
  }

  Future<int> getBalance(String groupId) async {
    final data = await _client.from('wallet_transactions').select('amount, type').eq('group_id', groupId);
    int balance = 0;
    for (final row in data as List) { balance += row['type'] == 'credit' ? (row['amount'] as int) : -(row['amount'] as int); }
    return balance;
  }

  Future<void> addMoney(String groupId, int amount, String? note) async {
    final userId = _client.auth.currentUser!.id;
    await _client.from('wallet_transactions').insert({'group_id': groupId, 'user_id': userId, 'amount': amount, 'type': 'credit', 'note': note});
  }
}
