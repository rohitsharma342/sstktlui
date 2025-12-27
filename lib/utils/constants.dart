import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFFBD0084);
  static const Color secondary = Color(0xFF6C757D);
  static const Color accent = Color(0xFFF8F9FA);
  static const Color text = Color(0xFF212529);
  static const Color textSecondary = Color(0xFF6C757D);
  static const Color background = Color(0xFFFFFFFF);
  static const Color surface = Color(0xFFF8F9FA);
  static const Color error = Color(0xFFDC3545);
  static const Color success = Color(0xFF198754);
}

class AppDimensions {
  static const double padding = 16.0;
  static const double margin = 16.0;
  static const double borderRadius = 8.0;
  static const double cardElevation = 2.0;
}

class AppTextStyles {
  static const TextStyle heading1 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.text,
  );
  
  static const TextStyle heading2 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.text,
  );
  
  static const TextStyle body1 = TextStyle(
    fontSize: 16,
    color: AppColors.text,
  );
  
  static const TextStyle body2 = TextStyle(
    fontSize: 14,
    color: AppColors.textSecondary,
  );
  
  static const TextStyle caption = TextStyle(
    fontSize: 12,
    color: AppColors.textSecondary,
  );
}