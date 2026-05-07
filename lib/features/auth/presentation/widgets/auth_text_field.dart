import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';

class AuthTextField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String? hint;
  final IconData? prefixIcon;
  final bool isPassword;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final bool autofocus;

  const AuthTextField({
    super.key,
    required this.controller,
    required this.label,
    this.hint,
    this.prefixIcon,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.onChanged,
    this.autofocus = false,
  });

  @override
  State<AuthTextField> createState() => _AuthTextFieldState();
}

class _AuthTextFieldState extends State<AuthTextField>
    with SingleTickerProviderStateMixin {
  bool _obscureText = true;
  bool _isFocused = false;
  late AnimationController _animController;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _glowAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnimatedBuilder(
      animation: _glowAnimation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: SplitzSpacing.borderRadiusMd,
            boxShadow: _isFocused
                ? [
                    BoxShadow(
                      color: SplitzColors.accentPrimary.withOpacity(0.15 * _glowAnimation.value),
                      blurRadius: 12 * _glowAnimation.value,
                      spreadRadius: 2 * _glowAnimation.value,
                    ),
                  ]
                : [],
          ),
          child: child,
        );
      },
      child: Focus(
        onFocusChange: (focused) {
          setState(() => _isFocused = focused);
          if (focused) {
            _animController.forward();
          } else {
            _animController.reverse();
          }
        },
        child: TextFormField(
          controller: widget.controller,
          obscureText: widget.isPassword && _obscureText,
          keyboardType: widget.keyboardType,
          validator: widget.validator,
          onChanged: widget.onChanged,
          autofocus: widget.autofocus,
          style: TextStyle(
            fontFamily: 'DMSans',
            fontSize: 15,
            color: isDark ? SplitzColors.darkText : SplitzColors.lightText,
          ),
          decoration: InputDecoration(
            labelText: widget.label,
            hintText: widget.hint,
            prefixIcon: widget.prefixIcon != null
                ? Icon(
                    widget.prefixIcon,
                    size: 20,
                    color: _isFocused
                        ? SplitzColors.accentPrimary
                        : (isDark
                            ? SplitzColors.darkTextTertiary
                            : SplitzColors.lightTextTertiary),
                  )
                : null,
            suffixIcon: widget.isPassword
                ? IconButton(
                    icon: Icon(
                      _obscureText
                          ? Icons.visibility_off_rounded
                          : Icons.visibility_rounded,
                      size: 20,
                      color: isDark
                          ? SplitzColors.darkTextTertiary
                          : SplitzColors.lightTextTertiary,
                    ),
                    onPressed: () {
                      setState(() => _obscureText = !_obscureText);
                    },
                  )
                : null,
          ),
        ),
      ),
    );
  }
}
