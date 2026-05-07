import '../../domain/entities/wallet_entity.dart';

class WalletTransactionModel extends WalletTransactionEntity {
  const WalletTransactionModel({required super.id, required super.groupId, required super.userId, required super.amount, required super.type, super.note, super.createdAt, super.userName});

  factory WalletTransactionModel.fromJson(Map<String, dynamic> json) => WalletTransactionModel(
    id: json['id'] as String, groupId: json['group_id'] as String, userId: json['user_id'] as String,
    amount: json['amount'] as int, type: json['type'] as String, note: json['note'] as String?,
    createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
    userName: json['profiles']?['full_name'] as String?,
  );
}
