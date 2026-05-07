import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/group_remote_datasource.dart';
import '../../data/repositories/group_repository_impl.dart';
import '../../domain/entities/group_entity.dart';
import '../../domain/repositories/group_repository.dart';

final groupDataSourceProvider = Provider((ref) => GroupRemoteDataSource());
final groupRepositoryProvider = Provider<GroupRepository>((ref) => GroupRepositoryImpl(ref.read(groupDataSourceProvider)));

final groupsProvider = StateNotifierProvider<GroupsNotifier, AsyncValue<List<GroupEntity>>>((ref) => GroupsNotifier(ref.read(groupRepositoryProvider)));

final selectedGroupProvider = StateProvider<String?>((ref) => null);

final groupMembersProvider = FutureProvider.family<List<GroupMemberEntity>, String>((ref, groupId) async {
  final repo = ref.read(groupRepositoryProvider);
  return repo.getGroupMembers(groupId);
});

final groupSummaryProvider = FutureProvider.family<Map<String, dynamic>, String>((ref, groupId) async {
  final repo = ref.read(groupRepositoryProvider);
  return repo.getGroupSummary(groupId);
});

class GroupsNotifier extends StateNotifier<AsyncValue<List<GroupEntity>>> {
  final GroupRepository _repo;
  GroupsNotifier(this._repo) : super(const AsyncValue.loading()) { loadGroups(); }

  Future<void> loadGroups() async {
    state = const AsyncValue.loading();
    try {
      final groups = await _repo.getUserGroups();
      state = AsyncValue.data(groups);
    } catch (e, st) { state = AsyncValue.error(e, st); }
  }

  Future<GroupEntity> createGroup({required String name, String? description, required String emoji}) async {
    final group = await _repo.createGroup(name: name, description: description, emoji: emoji);
    final current = state.valueOrNull ?? [];
    state = AsyncValue.data([group, ...current]);
    return group;
  }

  Future<void> joinGroup(String groupId) async {
    await _repo.joinGroup(groupId);
    await loadGroups();
  }
}
