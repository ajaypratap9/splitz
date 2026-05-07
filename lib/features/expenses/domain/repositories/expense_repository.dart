import '../entities/expense_entity.dart';
abstract class ExpenseRepository {
  Future<List<ExpenseEntity>> getExpenses(String groupId);
  Future<void> addExpense({required String groupId, required String title, required int amount, required String category, required String paidBy, required String splitType, required List<Map<String, dynamic>> participants});
  Future<void> deleteExpense(String expenseId);
}
