import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/config/supabase_config.dart';
import '../../../../core/utils/invite_code_generator.dart';
import '../models/group_model.dart';

class GroupRemoteDataSource {
  final SupabaseClient _client = SupabaseConfig.client;

  Future<List<GroupModel>> getUserGroups() async {
    final userId = _client.auth.currentUser!.id;
    final memberRows = await _client.from('group_members').select('group_id').eq('user_id', userId).eq('is_active', true);
    final groupIds = (memberRows as List).map((r) => r['group_id'] as String).toList();
    if (groupIds.isEmpty) return [];
    final data = await _client.from('groups').select().inFilter('id', groupIds).eq('is_active', true).order('created_at', ascending: false);
    return (data as List).map((j) => GroupModel.fromJson(j)).toList();
  }

  Future<GroupModel> createGroup({required String name, String? description, required String emoji}) async {
    final userId = _client.auth.currentUser!.id;
    final code = InviteCodeGenerator.generate();
    final data = await _client.from('groups').insert({'name': name, 'description': description, 'emoji': emoji, 'invite_code': code, 'created_by': userId}).select().single();
    await _client.from('group_members').insert({'group_id': data['id'], 'user_id': userId, 'role': 'admin'});
    return GroupModel.fromJson(data);
  }

  Future<GroupModel?> getGroupByInviteCode(String code) async {
    final data = await _client.from('groups').select().eq('invite_code', code.toUpperCase()).eq('is_active', true).maybeSingle();
    if (data == null) return null;
    return GroupModel.fromJson(data);
  }

  Future<void> joinGroup(String groupId) async {
    final userId = _client.auth.currentUser!.id;
    await _client.from('group_members').upsert({'group_id': groupId, 'user_id': userId, 'role': 'member', 'is_active': true});
  }

  Future<List<GroupMemberModel>> getGroupMembers(String groupId) async {
    final data = await _client.from('group_members').select('*, profiles(full_name, avatar_url)').eq('group_id', groupId).eq('is_active', true);
    return (data as List).map((j) => GroupMemberModel.fromJson(j)).toList();
  }

  Future<Map<String, dynamic>> getGroupSummary(String groupId) async {
    final data = await _client.rpc('get_group_summary', params: {'p_group_id': groupId});
    return data as Map<String, dynamic>;
  }
}
