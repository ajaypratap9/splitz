import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/invite_code_generator.dart';
import '../../../../shared/widgets/glass_card.dart';

class InviteCodeWidget extends StatelessWidget {
  final String code;
  const InviteCodeWidget({super.key, required this.code});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(children: [
        Text('Invite Code', style: TextStyle(fontFamily: 'DMSans', fontSize: 13, color: isDark ? SplitzColors.darkTextSecondary : SplitzColors.lightTextSecondary)),
        const SizedBox(height: 12),
        ShaderMask(
          shaderCallback: (b) => SplitzColors.splitzGradient.createShader(Rect.fromLTWH(0, 0, b.width, b.height)),
          child: Text(InviteCodeGenerator.formatForDisplay(code), style: const TextStyle(fontFamily: 'JetBrainsMono', fontSize: 32, fontWeight: FontWeight.w700, color: Colors.white, letterSpacing: 6)),
        ),
        const SizedBox(height: 16),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          _ActionBtn(icon: Icons.copy_rounded, label: 'Copy', onTap: () { Clipboard.setData(ClipboardData(text: code)); ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Code copied!'))); }),
          const SizedBox(width: 16),
          _ActionBtn(icon: Icons.share_rounded, label: 'Share', onTap: () { Share.share('Join my Splitz group! Use code: $code'); }),
        ]),
      ]),
    );
  }
}

class _ActionBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _ActionBtn({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(color: SplitzColors.accentPrimary.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
        child: Row(children: [
          Icon(icon, size: 16, color: SplitzColors.accentPrimary),
          const SizedBox(width: 6),
          Text(label, style: const TextStyle(fontFamily: 'DMSans', fontSize: 13, fontWeight: FontWeight.w600, color: SplitzColors.accentPrimary)),
        ]),
      ),
    );
  }
}
