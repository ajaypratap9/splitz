import 'package:flutter/material.dart';

class SplitzSpacing {
  // Base spacing unit = 4
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double xxl = 24;
  static const double xxxl = 32;
  static const double huge = 40;
  static const double massive = 48;
  static const double giant = 64;

  // Padding
  static const EdgeInsets paddingXs = EdgeInsets.all(4);
  static const EdgeInsets paddingSm = EdgeInsets.all(8);
  static const EdgeInsets paddingMd = EdgeInsets.all(12);
  static const EdgeInsets paddingLg = EdgeInsets.all(16);
  static const EdgeInsets paddingXl = EdgeInsets.all(20);
  static const EdgeInsets paddingXxl = EdgeInsets.all(24);

  // Horizontal padding
  static const EdgeInsets paddingHorizontalLg = EdgeInsets.symmetric(horizontal: 16);
  static const EdgeInsets paddingHorizontalXl = EdgeInsets.symmetric(horizontal: 20);
  static const EdgeInsets paddingHorizontalXxl = EdgeInsets.symmetric(horizontal: 24);

  // Screen padding
  static const EdgeInsets screenPadding = EdgeInsets.symmetric(horizontal: 20, vertical: 16);
  static const EdgeInsets screenPaddingHorizontal = EdgeInsets.symmetric(horizontal: 20);

  // Border radius
  static const double radiusSm = 8;
  static const double radiusMd = 12;
  static const double radiusLg = 16;
  static const double radiusXl = 20;
  static const double radiusXxl = 24;
  static const double radiusFull = 100;

  static BorderRadius borderRadiusSm = BorderRadius.circular(radiusSm);
  static BorderRadius borderRadiusMd = BorderRadius.circular(radiusMd);
  static BorderRadius borderRadiusLg = BorderRadius.circular(radiusLg);
  static BorderRadius borderRadiusXl = BorderRadius.circular(radiusXl);
  static BorderRadius borderRadiusXxl = BorderRadius.circular(radiusXxl);
  static BorderRadius borderRadiusFull = BorderRadius.circular(radiusFull);

  // Gap widgets
  static const SizedBox vGapXs = SizedBox(height: 4);
  static const SizedBox vGapSm = SizedBox(height: 8);
  static const SizedBox vGapMd = SizedBox(height: 12);
  static const SizedBox vGapLg = SizedBox(height: 16);
  static const SizedBox vGapXl = SizedBox(height: 20);
  static const SizedBox vGapXxl = SizedBox(height: 24);
  static const SizedBox vGapXxxl = SizedBox(height: 32);
  static const SizedBox vGapHuge = SizedBox(height: 40);

  static const SizedBox hGapXs = SizedBox(width: 4);
  static const SizedBox hGapSm = SizedBox(width: 8);
  static const SizedBox hGapMd = SizedBox(width: 12);
  static const SizedBox hGapLg = SizedBox(width: 16);
  static const SizedBox hGapXl = SizedBox(width: 20);
  static const SizedBox hGapXxl = SizedBox(width: 24);
}
