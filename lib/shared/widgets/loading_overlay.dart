import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class LoadingOverlay extends StatelessWidget {
  final bool isLoading;
  final Widget child;
  final String? message;

  const LoadingOverlay({super.key, required this.isLoading, required this.child, this.message});

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      child,
      if (isLoading) Positioned.fill(
        child: Container(
          color: Colors.black.withOpacity(0.4),
          child: Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
            const CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(SplitzColors.accentPrimary)),
            if (message != null) ...[const SizedBox(height: 16), Text(message!, style: const TextStyle(fontFamily: 'DMSans', color: Colors.white, fontSize: 14))],
          ])),
        ),
      ),
    ]);
  }
}
