class SettlementEntity {
  final String id;
  final String groupId;
  final String fromUser;
  final String toUser;
  final int amount;
  final bool isPaid;
  final DateTime? paidAt;
  final DateTime? createdAt;
  final String? fromUserName;
  final String? toUserName;

  const SettlementEntity({required this.id, required this.groupId, required this.fromUser, required this.toUser, required this.amount, this.isPaid = false, this.paidAt, this.createdAt, this.fromUserName, this.toUserName});
}

class NetBalance {
  final String userId;
  final String fullName;
  final int netBalancePaise;

  const NetBalance({required this.userId, required this.fullName, required this.netBalancePaise});
}
