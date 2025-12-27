import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF6B4E3D);
  static const Color secondary = Color(0xFFD4A574);
  static const Color accent = Color(0xFFF5E6D3);
  static const Color background = Color(0xFFFAF9F7);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color text = Color(0xFF2C2C2C);
  static const Color textSecondary = Color(0xFF757575);
  static const Color error = Color(0xFFE53E3E);
  static const Color success = Color(0xFF38A169);
  static const Color warning = Color(0xFFD69E2E);
}

class AppTextStyles {
  static const TextStyle heading1 = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.text,
  );
  
  static const TextStyle heading2 = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: AppColors.text,
  );
  
  static const TextStyle heading3 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.text,
  );
  
  static const TextStyle body1 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.text,
  );
  
  static const TextStyle body2 = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
  );
  
  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
  );
}

class AppDimensions {
  static const double padding = 16.0;
  static const double margin = 8.0;
  static const double borderRadius = 12.0;
  static const double cardElevation = 4.0;
}