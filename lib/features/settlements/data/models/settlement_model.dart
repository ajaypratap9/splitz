import '../../domain/entities/settlement_entity.dart';

class SettlementModel extends SettlementEntity {
  const SettlementModel({required super.id, required super.groupId, required super.fromUser, required super.toUser, required super.amount, super.isPaid, super.paidAt, super.createdAt, super.fromUserName, super.toUserName});

  factory SettlementModel.fromJson(Map<String, dynamic> json) => SettlementModel(
    id: json['id'] as String, groupId: json['group_id'] as String,
    fromUser: json['from_user'] as String, toUser: json['to_user'] as String,
    amount: json['amount'] as int, isPaid: json['is_paid'] as bool? ?? false,
    paidAt: json['paid_at'] != null ? DateTime.parse(json['paid_at'] as String) : null,
    createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
    fromUserName: json['from_profile']?['full_name'] as String?,
    toUserName: json['to_profile']?['full_name'] as String?,
  );
}
