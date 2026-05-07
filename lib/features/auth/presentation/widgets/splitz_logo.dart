import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class SplitzLogo extends StatelessWidget {
  final double size;
  final bool showTagline;

  const SplitzLogo({
    super.key,
    this.size = 40,
    this.showTagline = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ShaderMask(
          shaderCallback: (bounds) => SplitzColors.splitzGradient.createShader(
            Rect.fromLTWH(0, 0, bounds.width, bounds.height),
          ),
          child: Text(
            'Splitz',
            style: TextStyle(
              fontFamily: 'ClashDisplay',
              fontSize: size,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              letterSpacing: -1.5,
              height: 1.1,
            ),
          ),
        ),
        if (showTagline) ...[
          const SizedBox(height: 8),
          Text(
            'Split smarter. Settle faster.',
            style: TextStyle(
              fontFamily: 'DMSans',
              fontSize: size * 0.35,
              fontWeight: FontWeight.w400,
              color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.6),
              letterSpacing: 1.5,
            ),
          ),
        ],
      ],
    );
  }
}

/// CustomPainter version of the SplitzLogo for advanced rendering
class SplitzLogoPainter extends CustomPainter {
  final double progress;

  SplitzLogoPainter({this.progress = 1.0});

  @override
  void paint(Canvas canvas, Size size) {
    final gradient = const LinearGradient(
      colors: [SplitzColors.accentPrimary, SplitzColors.accentSecondary],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    final paint = Paint()
      ..shader = gradient.createShader(
        Rect.fromLTWH(0, 0, size.width, size.height),
      )
      ..style = PaintingStyle.fill;

    // Draw lightning bolt S shape
    final path = Path();
    final w = size.width;
    final h = size.height;

    // Lightning bolt integrated S
    path.moveTo(w * 0.65, h * 0.05);
    path.lineTo(w * 0.25, h * 0.05);
    path.cubicTo(w * 0.1, h * 0.05, w * 0.05, h * 0.15, w * 0.1, h * 0.25);
    path.lineTo(w * 0.55, h * 0.42);
    // Lightning bolt angle
    path.lineTo(w * 0.35, h * 0.5);
    path.lineTo(w * 0.7, h * 0.5);
    path.lineTo(w * 0.5, h * 0.58);
    path.lineTo(w * 0.9, h * 0.75);
    path.cubicTo(w * 0.95, h * 0.85, w * 0.9, h * 0.95, w * 0.75, h * 0.95);
    path.lineTo(w * 0.35, h * 0.95);

    // Apply progress clipping for animation
    canvas.save();
    canvas.clipRect(
      Rect.fromLTWH(0, 0, w * progress, h),
    );
    canvas.drawPath(path, paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant SplitzLogoPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
