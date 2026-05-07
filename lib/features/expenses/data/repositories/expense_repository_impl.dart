import '../../domain/entities/expense_entity.dart';
import '../../domain/repositories/expense_repository.dart';
import '../datasources/expense_remote_datasource.dart';

class ExpenseRepositoryImpl implements ExpenseRepository {
  final ExpenseRemoteDataSource _ds;
  ExpenseRepositoryImpl(this._ds);
  @override Future<List<ExpenseEntity>> getExpenses(String groupId) => _ds.getExpenses(groupId);
  @override Future<void> addExpense({required String groupId, required String title, required int amount, required String category, required String paidBy, required String splitType, required List<Map<String, dynamic>> participants}) => _ds.addExpense(groupId: groupId, title: title, amount: amount, category: category, paidBy: paidBy, splitType: splitType, participants: participants);
  @override Future<void> deleteExpense(String expenseId) => _ds.deleteExpense(expenseId);
}
