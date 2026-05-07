class ExpenseEntity {
  final String id;
  final String groupId;
  final String title;
  final int amount;
  final String category;
  final String paidBy;
  final String splitType;
  final DateTime? date;
  final String? notes;
  final bool isDeleted;
  final String createdBy;
  final DateTime? createdAt;
  final String? paidByName;

  const ExpenseEntity({required this.id, required this.groupId, required this.title, required this.amount, this.category = 'general', required this.paidBy, this.splitType = 'equal', this.date, this.notes, this.isDeleted = false, required this.createdBy, this.createdAt, this.paidByName});
}

class ExpenseParticipantEntity {
  final String id;
  final String expenseId;
  final String userId;
  final int shareAmount;
  final double? sharePercentage;
  final bool isSettled;
  final String? userName;

  const ExpenseParticipantEntity({required this.id, required this.expenseId, required this.userId, required this.shareAmount, this.sharePercentage, this.isSettled = false, this.userName});
}
