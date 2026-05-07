import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';

class GlassCard extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final EdgeInsets padding;
  final double? width;
  final double? height;
  final LinearGradient? gradient;
  final VoidCallback? onTap;

  const GlassCard({
    super.key,
    required this.child,
    this.borderRadius = 16,
    this.padding = const EdgeInsets.all(16),
    this.width,
    this.height,
    this.gradient,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardWidget = ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: width,
          height: height,
          padding: padding,
          decoration: BoxDecoration(
            color: isDark ? Colors.white.withOpacity(0.05) : Colors.white.withOpacity(0.85),
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(color: isDark ? Colors.white.withOpacity(0.08) : Colors.black.withOpacity(0.08)),
            gradient: gradient,
            boxShadow: isDark ? [BoxShadow(color: SplitzColors.accentPrimary.withOpacity(0.03), blurRadius: 15, spreadRadius: 1)] : [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, spreadRadius: 1)],
          ),
          child: child,
        ),
      ),
    );
    if (onTap != null) return GestureDetector(onTap: onTap, child: cardWidget);
    return cardWidget;
  }
}
