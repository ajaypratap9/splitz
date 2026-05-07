import '../../domain/entities/group_entity.dart';
import '../../domain/repositories/group_repository.dart';
import '../datasources/group_remote_datasource.dart';

class GroupRepositoryImpl implements GroupRepository {
  final GroupRemoteDataSource _ds;
  GroupRepositoryImpl(this._ds);

  @override
  Future<List<GroupEntity>> getUserGroups() => _ds.getUserGroups();
  @override
  Future<GroupEntity> createGroup({required String name, String? description, required String emoji}) => _ds.createGroup(name: name, description: description, emoji: emoji);
  @override
  Future<GroupEntity?> getGroupByInviteCode(String code) => _ds.getGroupByInviteCode(code);
  @override
  Future<void> joinGroup(String groupId) => _ds.joinGroup(groupId);
  @override
  Future<List<GroupMemberEntity>> getGroupMembers(String groupId) => _ds.getGroupMembers(groupId);
  @override
  Future<Map<String, dynamic>> getGroupSummary(String groupId) => _ds.getGroupSummary(groupId);
}
