class WalletTransactionEntity {
  final String id;
  final String groupId;
  final String userId;
  final int amount;
  final String type;
  final String? note;
  final DateTime? createdAt;
  final String? userName;

  const WalletTransactionEntity({required this.id, required this.groupId, required this.userId, required this.amount, required this.type, this.note, this.createdAt, this.userName});
}
