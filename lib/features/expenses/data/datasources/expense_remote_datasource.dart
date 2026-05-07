import '../../../../core/config/supabase_config.dart';
import '../models/expense_model.dart';

class ExpenseRemoteDataSource {
  final _client = SupabaseConfig.client;

  Future<List<ExpenseModel>> getExpenses(String groupId) async {
    final data = await _client.from('expenses').select('*, profiles!expenses_paid_by_fkey(full_name)').eq('group_id', groupId).eq('is_deleted', false).order('date', ascending: false);
    return (data as List).map((j) => ExpenseModel.fromJson(j)).toList();
  }

  Future<void> addExpense({required String groupId, required String title, required int amount, required String category, required String paidBy, required String splitType, required List<Map<String, dynamic>> participants}) async {
    final userId = _client.auth.currentUser!.id;
    final expenseData = await _client.from('expenses').insert({'group_id': groupId, 'title': title, 'amount': amount, 'category': category, 'paid_by': paidBy, 'split_type': splitType, 'created_by': userId}).select().single();
    final expenseId = expenseData['id'] as String;
    final participantRows = participants.map((p) => {'expense_id': expenseId, 'user_id': p['user_id'], 'share_amount': p['share_amount'], 'share_percentage': p['share_percentage']}).toList();
    await _client.from('expense_participants').insert(participantRows);
  }

  Future<void> deleteExpense(String expenseId) async {
    await _client.from('expenses').update({'is_deleted': true}).eq('id', expenseId);
  }
}
