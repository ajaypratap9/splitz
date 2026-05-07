import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class CategoryChip extends StatelessWidget {
  final String category;
  final bool isSelected;
  final VoidCallback? onTap;

  const CategoryChip({super.key, required this.category, this.isSelected = false, this.onTap});

  @override
  Widget build(BuildContext context) {
    final color = SplitzColors.getCategoryColor(category);
    final icon = SplitzColors.getCategoryIcon(category);
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.15) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? color : Colors.grey.withOpacity(0.3), width: isSelected ? 1.5 : 1),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(icon, size: 16, color: isSelected ? color : Colors.grey),
          const SizedBox(width: 6),
          Text(category[0].toUpperCase() + category.substring(1), style: TextStyle(fontFamily: 'DMSans', fontSize: 13, fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400, color: isSelected ? color : Colors.grey)),
        ]),
      ),
    );
  }
}
