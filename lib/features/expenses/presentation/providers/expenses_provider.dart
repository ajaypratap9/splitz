import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/expense_remote_datasource.dart';
import '../../data/repositories/expense_repository_impl.dart';
import '../../domain/entities/expense_entity.dart';
import '../../domain/repositories/expense_repository.dart';

final expenseDsProvider = Provider((ref) => ExpenseRemoteDataSource());
final expenseRepoProvider = Provider<ExpenseRepository>((ref) => ExpenseRepositoryImpl(ref.read(expenseDsProvider)));

final expensesProvider = FutureProvider.family<List<ExpenseEntity>, String>((ref, groupId) async => ref.read(expenseRepoProvider).getExpenses(groupId));

final expenseNotifierProvider = Provider.family<ExpenseNotifier, String>((ref, groupId) => ExpenseNotifier(ref.read(expenseRepoProvider), groupId, ref));

class ExpenseNotifier {
  final ExpenseRepository _repo;
  final String groupId;
  final Ref _ref;
  ExpenseNotifier(this._repo, this.groupId, this._ref);

  Future<void> addExpense({required String title, required int amount, required String category, required String paidBy, required String splitType, required List<Map<String, dynamic>> participants}) async {
    await _repo.addExpense(groupId: groupId, title: title, amount: amount, category: category, paidBy: paidBy, splitType: splitType, participants: participants);
    _ref.invalidate(expensesProvider(groupId));
  }

  Future<void> deleteExpense(String expenseId) async {
    await _repo.deleteExpense(expenseId);
    _ref.invalidate(expensesProvider(groupId));
  }
}
