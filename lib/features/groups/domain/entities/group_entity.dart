class GroupEntity {
  final String id;
  final String name;
  final String? description;
  final String emoji;
  final String inviteCode;
  final String createdBy;
  final String currency;
  final bool isActive;
  final DateTime? createdAt;
  final int memberCount;
  final int totalBalance;

  const GroupEntity({required this.id, required this.name, this.description, this.emoji = '💰', required this.inviteCode, required this.createdBy, this.currency = 'INR', this.isActive = true, this.createdAt, this.memberCount = 0, this.totalBalance = 0});

  GroupEntity copyWith({String? id, String? name, String? description, String? emoji, String? inviteCode, String? createdBy, String? currency, bool? isActive, DateTime? createdAt, int? memberCount, int? totalBalance}) => GroupEntity(id: id ?? this.id, name: name ?? this.name, description: description ?? this.description, emoji: emoji ?? this.emoji, inviteCode: inviteCode ?? this.inviteCode, createdBy: createdBy ?? this.createdBy, currency: currency ?? this.currency, isActive: isActive ?? this.isActive, createdAt: createdAt ?? this.createdAt, memberCount: memberCount ?? this.memberCount, totalBalance: totalBalance ?? this.totalBalance);
}

class GroupMemberEntity {
  final String id;
  final String groupId;
  final String userId;
  final String role;
  final DateTime? joinedAt;
  final bool isActive;
  final String? fullName;
  final String? avatarUrl;

  const GroupMemberEntity({required this.id, required this.groupId, required this.userId, this.role = 'member', this.joinedAt, this.isActive = true, this.fullName, this.avatarUrl});
}
