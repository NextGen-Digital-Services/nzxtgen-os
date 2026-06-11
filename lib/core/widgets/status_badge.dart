import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

enum StatusType {
  active,
  pending,
  completed,
  cancelled,
  premium,
}

class StatusBadge extends StatelessWidget {
  final String label;
  final StatusType type;

  const StatusBadge({
    super.key,
    required this.label,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color textColor;

    switch (type) {
      case StatusType.active:
        bgColor = AppColors.secondary.withValues(alpha: 0.15); // Teal Muted
        textColor = AppColors.secondary;
        break;
      case StatusType.pending:
        bgColor = AppColors.warning.withValues(alpha: 0.15); // Warning Muted
        textColor = AppColors.warning;
        break;
      case StatusType.completed:
        bgColor = AppColors.secondary; // Teal background
        textColor = AppColors.textInverse; // Inverse text
        break;
      case StatusType.cancelled:
        bgColor = AppColors.error.withValues(alpha: 0.15); // Error Muted
        textColor = AppColors.error;
        break;
      case StatusType.premium:
        bgColor = AppColors.tertiary.withValues(alpha: 0.15); // Plasma Pink Muted
        textColor = AppColors.tertiary;
        break;
    }

    return Container(
      height: 24,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(9999),
      ),
      child: Center(
        child: Text(
          label.toUpperCase(),
          style: TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
            color: textColor,
          ),
        ),
      ),
    );
  }
}
