import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/splitz_button.dart';
import '../providers/groups_provider.dart';
import '../../data/datasources/group_remote_datasource.dart';

class JoinGroupScreen extends ConsumerStatefulWidget {
  const JoinGroupScreen({super.key});
  @override
  ConsumerState<JoinGroupScreen> createState() => _JoinGroupScreenState();
}

class _JoinGroupScreenState extends ConsumerState<JoinGroupScreen> {
  final _ctrl = TextEditingController();
  Timer? _debounce;
  bool _checking = false;
  bool _valid = false;
  bool _loading = false;
  String? _groupId;
  String? _groupName;

  @override
  void dispose() { _ctrl.dispose(); _debounce?.cancel(); super.dispose(); }

  void _onChanged(String val) {
    _debounce?.cancel();
    final code = val.replaceAll(' ', '').toUpperCase();
    if (code.length != 6) { setState(() { _valid = false; _groupName = null; }); return; }
    setState(() => _checking = true);
    _debounce = Timer(const Duration(milliseconds: 500), () => _validate(code));
  }

  Future<void> _validate(String code) async {
    try {
      final group = await GroupRemoteDataSource().getGroupByInviteCode(code);
      if (mounted) setState(() { _checking = false; _valid = group != null; _groupId = group?.id; _groupName = group?.name; });
    } catch (e) { if (mounted) setState(() { _checking = false; _valid = false; }); }
  }

  Future<void> _join() async {
    if (_groupId == null) return;
    setState(() => _loading = true);
    try {
      await ref.read(groupsProvider.notifier).joinGroup(_groupId!);
      if (mounted) context.go('/group/$_groupId');
    } catch (e) { if (mounted) { setState(() => _loading = false); ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e'))); } }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(title: const Text('Join Group'), leading: IconButton(icon: const Icon(Icons.close_rounded), onPressed: () => context.pop())),
      body: Container(
        decoration: BoxDecoration(gradient: isDark ? SplitzColors.darkBgGradient : const LinearGradient(colors: [SplitzColors.lightBg, SplitzColors.lightBgSecondary], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
        child: SafeArea(child: Padding(padding: SplitzSpacing.screenPadding, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const SizedBox(height: 16),
          Text('Enter invite code', style: TextStyle(fontFamily: 'ClashDisplay', fontSize: 22, fontWeight: FontWeight.w700, color: isDark ? SplitzColors.darkText : SplitzColors.lightText)).animate().fadeIn(duration: 400.ms),
          const SizedBox(height: 8),
          Text('Ask your friend for the 6-character code', style: TextStyle(fontFamily: 'DMSans', fontSize: 14, color: isDark ? SplitzColors.darkTextSecondary : SplitzColors.lightTextSecondary)),
          const SizedBox(height: 32),
          TextField(
            controller: _ctrl,
            onChanged: _onChanged,
            textCapitalization: TextCapitalization.characters,
            maxLength: 7,
            textAlign: TextAlign.center,
            style: TextStyle(fontFamily: 'JetBrainsMono', fontSize: 28, fontWeight: FontWeight.w700, letterSpacing: 8, color: isDark ? SplitzColors.darkText : SplitzColors.lightText),
            decoration: InputDecoration(
              counterText: '',
              hintText: '• • • • • •',
              hintStyle: TextStyle(fontFamily: 'JetBrainsMono', fontSize: 28, color: isDark ? SplitzColors.darkTextTertiary : SplitzColors.lightTextTertiary, letterSpacing: 8),
              suffixIcon: _checking ? const Padding(padding: EdgeInsets.all(12), child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: SplitzColors.accentPrimary))) : _ctrl.text.length >= 6 ? Icon(_valid ? Icons.check_circle_rounded : Icons.cancel_rounded, color: _valid ? SplitzColors.success : SplitzColors.error) : null,
            ),
          ).animate().fadeIn(delay: 200.ms, duration: 400.ms),
          if (_valid && _groupName != null) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: SplitzColors.success.withOpacity(0.1), borderRadius: SplitzSpacing.borderRadiusMd),
              child: Row(children: [const Icon(Icons.group_rounded, color: SplitzColors.success, size: 20), const SizedBox(width: 8), Text(_groupName!, style: const TextStyle(fontFamily: 'DMSans', fontSize: 14, fontWeight: FontWeight.w600, color: SplitzColors.success))]),
            ).animate().fadeIn(duration: 300.ms),
          ],
          const Spacer(),
          SplitzButton(label: 'Join Group', onPressed: _join, isLoading: _loading, isFullWidth: true).animate().fadeIn(delay: 300.ms),
          const SizedBox(height: 32),
        ]))),
      ),
    );
  }
}
