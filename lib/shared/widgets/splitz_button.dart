import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';

class SplitzButton extends StatefulWidget {
  final String label;
  final VoidCallback onPressed;
  final bool isLoading;
  final bool isFullWidth;
  final bool isOutlined;
  final IconData? icon;
  final double? width;
  final double height;

  const SplitzButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.isFullWidth = false,
    this.isOutlined = false,
    this.icon,
    this.width,
    this.height = 52,
  });

  @override
  State<SplitzButton> createState() => _SplitzButtonState();
}

class _SplitzButtonState extends State<SplitzButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 150));
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.96).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() { _controller.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) => Transform.scale(scale: _scaleAnimation.value, child: child),
      child: GestureDetector(
        onTapDown: (_) => _controller.forward(),
        onTapUp: (_) { _controller.reverse(); if (!widget.isLoading) widget.onPressed(); },
        onTapCancel: () => _controller.reverse(),
        child: Container(
          width: widget.isFullWidth ? double.infinity : widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            gradient: widget.isOutlined ? null : SplitzColors.splitzGradient,
            borderRadius: SplitzSpacing.borderRadiusMd,
            border: widget.isOutlined ? Border.all(color: SplitzColors.accentPrimary) : null,
            boxShadow: widget.isOutlined ? null : [
              BoxShadow(color: SplitzColors.accentPrimary.withOpacity(0.3), blurRadius: 12, offset: const Offset(0, 4)),
            ],
          ),
          child: Center(
            child: widget.isLoading
                ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2.5, valueColor: AlwaysStoppedAnimation<Color>(Colors.white)))
                : Row(mainAxisSize: MainAxisSize.min, children: [
                    if (widget.icon != null) ...[Icon(widget.icon, color: widget.isOutlined ? SplitzColors.accentPrimary : Colors.white, size: 20), const SizedBox(width: 8)],
                    Text(widget.label, style: TextStyle(fontFamily: 'DMSans', fontSize: 15, fontWeight: FontWeight.w600, color: widget.isOutlined ? SplitzColors.accentPrimary : Colors.white, letterSpacing: 0.3)),
                  ]),
          ),
        ),
      ),
    );
  }
}

class AnimatedBuilder extends AnimatedWidget {
  final Widget Function(BuildContext, Widget?) builder;
  final Widget? child;
  const AnimatedBuilder({super.key, required Animation<double> animation, required this.builder, this.child}) : super(listenable: animation);
  @override
  Widget build(BuildContext context) => builder(context, child);
}
