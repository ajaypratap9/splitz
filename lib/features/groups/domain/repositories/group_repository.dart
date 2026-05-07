import '../entities/group_entity.dart';

abstract class GroupRepository {
  Future<List<GroupEntity>> getUserGroups();
  Future<GroupEntity> createGroup({required String name, String? description, required String emoji});
  Future<GroupEntity?> getGroupByInviteCode(String code);
  Future<void> joinGroup(String groupId);
  Future<List<GroupMemberEntity>> getGroupMembers(String groupId);
  Future<Map<String, dynamic>> getGroupSummary(String groupId);
}
