import '../../domain/entities/group_entity.dart';

class GroupModel extends GroupEntity {
  const GroupModel({required super.id, required super.name, super.description, super.emoji, required super.inviteCode, required super.createdBy, super.currency, super.isActive, super.createdAt, super.memberCount, super.totalBalance});

  factory GroupModel.fromJson(Map<String, dynamic> json) => GroupModel(
    id: json['id'] as String,
    name: json['name'] as String,
    description: json['description'] as String?,
    emoji: json['emoji'] as String? ?? '💰',
    inviteCode: json['invite_code'] as String,
    createdBy: json['created_by'] as String,
    currency: json['currency'] as String? ?? 'INR',
    isActive: json['is_active'] as bool? ?? true,
    createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
  );

  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'description': description, 'emoji': emoji, 'invite_code': inviteCode, 'created_by': createdBy, 'currency': currency, 'is_active': isActive};
}

class GroupMemberModel extends GroupMemberEntity {
  const GroupMemberModel({required super.id, required super.groupId, required super.userId, super.role, super.joinedAt, super.isActive, super.fullName, super.avatarUrl});

  factory GroupMemberModel.fromJson(Map<String, dynamic> json) => GroupMemberModel(
    id: json['id'] as String,
    groupId: json['group_id'] as String,
    userId: json['user_id'] as String,
    role: json['role'] as String? ?? 'member',
    joinedAt: json['joined_at'] != null ? DateTime.parse(json['joined_at'] as String) : null,
    isActive: json['is_active'] as bool? ?? true,
    fullName: json['profiles']?['full_name'] as String?,
    avatarUrl: json['profiles']?['avatar_url'] as String?,
  );
}
