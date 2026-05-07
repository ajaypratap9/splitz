import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/config/supabase_config.dart';

final realtimeServiceProvider = Provider.family<RealtimeService, String>((ref, groupId) {
  final service = RealtimeService(groupId: groupId, ref: ref);
  ref.onDispose(() => service.dispose());
  return service;
});

class RealtimeService {
  final String groupId;
  final Ref ref;
  RealtimeChannel? _channel;
  final List<StreamController> _controllers = [];

  RealtimeService({required this.groupId, required this.ref});

  void subscribe({
    required String table,
    required void Function(Map<String, dynamic> payload) onInsert,
    void Function(Map<String, dynamic> payload)? onUpdate,
    void Function(Map<String, dynamic> payload)? onDelete,
  }) {
    _channel = SupabaseConfig.client.channel('group_$groupId\_$table')
      .onPostgresChanges(
        event: PostgresChangeEvent.insert,
        schema: 'public',
        table: table,
        filter: PostgresChangeFilter(type: PostgresChangeFilterType.eq, column: 'group_id', value: groupId),
        callback: (payload) => onInsert(payload.newRecord),
      );

    if (onUpdate != null) {
      _channel = _channel!.onPostgresChanges(
        event: PostgresChangeEvent.update,
        schema: 'public',
        table: table,
        filter: PostgresChangeFilter(type: PostgresChangeFilterType.eq, column: 'group_id', value: groupId),
        callback: (payload) => onUpdate(payload.newRecord),
      );
    }

    if (onDelete != null) {
      _channel = _channel!.onPostgresChanges(
        event: PostgresChangeEvent.delete,
        schema: 'public',
        table: table,
        filter: PostgresChangeFilter(type: PostgresChangeFilterType.eq, column: 'group_id', value: groupId),
        callback: (payload) => onDelete(payload.oldRecord),
      );
    }

    _channel!.subscribe();
  }

  void dispose() {
    _channel?.unsubscribe();
    for (final c in _controllers) { c.close(); }
  }
}
