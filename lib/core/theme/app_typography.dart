import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SplitzTypography {
  static TextStyle get displayLarge => const TextStyle(
        fontFamily: 'ClashDisplay',
        fontSize: 40,
        fontWeight: FontWeight.w700,
        letterSpacing: -1.5,
        height: 1.1,
      );

  static TextStyle get displayMedium => const TextStyle(
        fontFamily: 'ClashDisplay',
        fontSize: 32,
        fontWeight: FontWeight.w700,
        letterSpacing: -1.0,
        height: 1.2,
      );

  static TextStyle get displaySmall => const TextStyle(
        fontFamily: 'ClashDisplay',
        fontSize: 28,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.5,
        height: 1.2,
      );

  static TextStyle get headlineLarge => const TextStyle(
        fontFamily: 'ClashDisplay',
        fontSize: 24,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.5,
        height: 1.3,
      );

  static TextStyle get headlineMedium => const TextStyle(
        fontFamily: 'ClashDisplay',
        fontSize: 20,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.3,
        height: 1.3,
      );

  static TextStyle get headlineSmall => const TextStyle(
        fontFamily: 'ClashDisplay',
        fontSize: 18,
        fontWeight: FontWeight.w500,
        letterSpacing: 0,
        height: 1.3,
      );

  static TextStyle get titleLarge => GoogleFonts.dmSans(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        height: 1.4,
      );

  static TextStyle get titleMedium => GoogleFonts.dmSans(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
        height: 1.4,
      );

  static TextStyle get titleSmall => GoogleFonts.dmSans(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
        height: 1.4,
      );

  static TextStyle get bodyLarge => GoogleFonts.dmSans(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.15,
        height: 1.5,
      );

  static TextStyle get bodyMedium => GoogleFonts.dmSans(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.25,
        height: 1.5,
      );

  static TextStyle get bodySmall => GoogleFonts.dmSans(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.4,
        height: 1.5,
      );

  static TextStyle get labelLarge => GoogleFonts.dmSans(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
        height: 1.4,
      );

  static TextStyle get labelMedium => GoogleFonts.dmSans(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
        height: 1.4,
      );

  static TextStyle get labelSmall => GoogleFonts.dmSans(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
        height: 1.4,
      );

  static TextStyle get mono => const TextStyle(
        fontFamily: 'JetBrainsMono',
        fontSize: 14,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
        height: 1.5,
      );

  static TextStyle get monoLarge => const TextStyle(
        fontFamily: 'JetBrainsMono',
        fontSize: 28,
        fontWeight: FontWeight.w700,
        letterSpacing: -1,
        height: 1.2,
      );

  static TextStyle get amount => const TextStyle(
        fontFamily: 'JetBrainsMono',
        fontSize: 32,
        fontWeight: FontWeight.w700,
        letterSpacing: -1,
        height: 1.1,
      );
}
