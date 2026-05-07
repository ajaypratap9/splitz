import 'package:flutter/material.dart';
import '../../core/utils/currency_formatter.dart';

class AnimatedCounter extends StatelessWidget {
  final double value;
  final TextStyle? style;
  final String prefix;
  final int durationMs;
  final int decimalPlaces;

  const AnimatedCounter({
    super.key,
    required this.value,
    this.style,
    this.prefix = '₹',
    this.durationMs = 800,
    this.decimalPlaces = 2,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: value),
      duration: Duration(milliseconds: durationMs),
      curve: Curves.easeOutCubic,
      builder: (context, animValue, child) {
        final formatted = CurrencyFormatter.formatIndian(animValue);
        return Text(formatted, style: style ?? Theme.of(context).textTheme.headlineLarge);
      },
    );
  }
}
