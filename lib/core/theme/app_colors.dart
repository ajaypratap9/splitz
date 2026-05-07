import 'package:flutter/material.dart';

class SplitzColors {
  // Dark mode
  static const darkBg = Color(0xFF0A0A0F);
  static const darkBgSecondary = Color(0xFF12121A);
  static const darkSurface = Color(0xFF1A1A2E);
  static const darkCardBg = Color(0x0DFFFFFF);
  static const darkBorder = Color(0x14FFFFFF);
  static const darkText = Color(0xFFFFFFFF);
  static const darkTextSecondary = Color(0xB3FFFFFF);
  static const darkTextTertiary = Color(0x66FFFFFF);

  // Light mode
  static const lightBg = Color(0xFFF5F5FF);
  static const lightBgSecondary = Color(0xFFEEEEF8);
  static const lightSurface = Color(0xFFFFFFFF);
  static const lightCardBg = Color(0xD9FFFFFF);
  static const lightBorder = Color(0x14000000);
  static const lightText = Color(0xFF0A0A0F);
  static const lightTextSecondary = Color(0xB30A0A0F);
  static const lightTextTertiary = Color(0x660A0A0F);

  // Accent (shared)
  static const accentPrimary = Color(0xFF6C63FF);
  static const accentSecondary = Color(0xFF00D9F5);
  static const success = Color(0xFF00E5A0);
  static const warning = Color(0xFFFFB800);
  static const error = Color(0xFFFF4D6D);

  // Category colors
  static const categoryFood = Color(0xFFFF8C42);
  static const categoryTravel = Color(0xFF4DA8DA);
  static const categoryShopping = Color(0xFF9B59B6);
  static const categoryEntertainment = Color(0xFFE91E8C);
  static const categoryUtilities = Color(0xFF00B4D8);
  static const categoryGeneral = Color(0xFF6B7280);

  // Gradients
  static const splitzGradient = LinearGradient(
    colors: [accentPrimary, accentSecondary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const splitzGradientVertical = LinearGradient(
    colors: [accentPrimary, accentSecondary],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const darkBgGradient = LinearGradient(
    colors: [darkBg, darkBgSecondary],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const successGradient = LinearGradient(
    colors: [Color(0xFF00E5A0), Color(0xFF00B4D8)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const errorGradient = LinearGradient(
    colors: [Color(0xFFFF4D6D), Color(0xFFFF6B6B)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static Color getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'food':
        return categoryFood;
      case 'travel':
        return categoryTravel;
      case 'shopping':
        return categoryShopping;
      case 'entertainment':
        return categoryEntertainment;
      case 'utilities':
        return categoryUtilities;
      default:
        return categoryGeneral;
    }
  }

  static IconData getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'food':
        return Icons.restaurant_rounded;
      case 'travel':
        return Icons.flight_rounded;
      case 'shopping':
        return Icons.shopping_bag_rounded;
      case 'entertainment':
        return Icons.movie_rounded;
      case 'utilities':
        return Icons.bolt_rounded;
      default:
        return Icons.receipt_long_rounded;
    }
  }
}
