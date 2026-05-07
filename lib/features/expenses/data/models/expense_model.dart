import '../../domain/entities/expense_entity.dart';

class ExpenseModel extends ExpenseEntity {
  const ExpenseModel({required super.id, required super.groupId, required super.title, required super.amount, super.category, required super.paidBy, super.splitType, super.date, super.notes, super.isDeleted, required super.createdBy, super.createdAt, super.paidByName});

  factory ExpenseModel.fromJson(Map<String, dynamic> json) => ExpenseModel(
    id: json['id'] as String, groupId: json['group_id'] as String, title: json['title'] as String,
    amount: json['amount'] as int, category: json['category'] as String? ?? 'general',
    paidBy: json['paid_by'] as String, splitType: json['split_type'] as String? ?? 'equal',
    date: json['date'] != null ? DateTime.parse(json['date'] as String) : null,
    notes: json['notes'] as String?, isDeleted: json['is_deleted'] as bool? ?? false,
    createdBy: json['created_by'] as String, createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
    paidByName: json['profiles']?['full_name'] as String?,
  );
}
