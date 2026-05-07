import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/splitz_button.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../providers/groups_provider.dart';
import '../widgets/invite_code_widget.dart';

class CreateGroupScreen extends ConsumerStatefulWidget {
  const CreateGroupScreen({super.key});
  @override
  ConsumerState<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends ConsumerState<CreateGroupScreen> {
  final _nameCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  String _selectedEmoji = '💰';
  bool _loading = false;
  String? _createdCode;
  int _step = 0;

  final _emojis = ['💰', '🏠', '✈️', '🍔', '🎬', '🎮', '🛒', '🏋️', '🎓', '🏖️', '🚗', '💼', '🎉', '❤️', '🌍', '⚡'];

  @override
  void dispose() { _nameCtrl.dispose(); _descCtrl.dispose(); super.dispose(); }

  Future<void> _create() async {
    if (_nameCtrl.text.trim().isEmpty) return;
    setState(() => _loading = true);
    try {
      final group = await ref.read(groupsProvider.notifier).createGroup(name: _nameCtrl.text.trim(), description: _descCtrl.text.trim().isEmpty ? null : _descCtrl.text.trim(), emoji: _selectedEmoji);
      setState(() { _createdCode = group.inviteCode; _step = 2; _loading = false; });
    } catch (e) { setState(() => _loading = false); if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e'))); }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(title: Text(_step == 2 ? 'Group Created!' : 'Create Group'), leading: IconButton(icon: const Icon(Icons.close_rounded), onPressed: () => context.pop())),
      body: Container(
        decoration: BoxDecoration(gradient: isDark ? SplitzColors.darkBgGradient : const LinearGradient(colors: [SplitzColors.lightBg, SplitzColors.lightBgSecondary], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
        child: SafeArea(child: SingleChildScrollView(padding: SplitzSpacing.screenPadding, child: _step == 2 ? _successView() : _formView(isDark))),
      ),
    );
  }

  Widget _formView(bool isDark) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const SizedBox(height: 8),
      Text('Pick an emoji', style: TextStyle(fontFamily: 'DMSans', fontSize: 14, fontWeight: FontWeight.w500, color: isDark ? SplitzColors.darkTextSecondary : SplitzColors.lightTextSecondary)),
      const SizedBox(height: 12),
      Wrap(spacing: 8, runSpacing: 8, children: _emojis.map((e) => GestureDetector(
        onTap: () => setState(() => _selectedEmoji = e),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 48, height: 48,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: _selectedEmoji == e ? SplitzColors.accentPrimary.withOpacity(0.15) : (isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.03)),
            border: Border.all(color: _selectedEmoji == e ? SplitzColors.accentPrimary : Colors.transparent, width: 2),
          ),
          child: Center(child: Text(e, style: const TextStyle(fontSize: 22))),
        ),
      )).toList()),
      const SizedBox(height: 24),
      TextFormField(controller: _nameCtrl, decoration: const InputDecoration(labelText: 'Group Name', hintText: 'e.g. Goa Trip 2024'), style: TextStyle(fontFamily: 'DMSans', color: isDark ? SplitzColors.darkText : SplitzColors.lightText)),
      const SizedBox(height: 16),
      TextFormField(controller: _descCtrl, decoration: const InputDecoration(labelText: 'Description (optional)', hintText: 'What is this group for?'), maxLines: 2, style: TextStyle(fontFamily: 'DMSans', color: isDark ? SplitzColors.darkText : SplitzColors.lightText)),
      const SizedBox(height: 32),
      SplitzButton(label: 'Create Group', onPressed: _create, isLoading: _loading, isFullWidth: true),
    ]).animate().fadeIn(duration: 400.ms);
  }

  Widget _successView() {
    return Column(children: [
      const SizedBox(height: 32),
      const Icon(Icons.check_circle_rounded, size: 72, color: SplitzColors.success).animate().scale(begin: const Offset(0, 0), end: const Offset(1, 1), duration: 500.ms, curve: Curves.elasticOut),
      const SizedBox(height: 24),
      Text('Group created!', style: const TextStyle(fontFamily: 'ClashDisplay', fontSize: 24, fontWeight: FontWeight.w700)).animate().fadeIn(delay: 300.ms),
      const SizedBox(height: 8),
      Text('Share this code with your friends', style: TextStyle(fontFamily: 'DMSans', fontSize: 14, color: Colors.grey)).animate().fadeIn(delay: 400.ms),
      const SizedBox(height: 32),
      if (_createdCode != null) InviteCodeWidget(code: _createdCode!).animate().fadeIn(delay: 500.ms).slideY(begin: 0.1, end: 0),
      const SizedBox(height: 32),
      SplitzButton(label: 'Go to Group', onPressed: () => context.pop(), isFullWidth: true).animate().fadeIn(delay: 600.ms),
    ]);
  }
}
