import 'package:flutter/material.dart';
import '../constants/app_colors.dart';   // Make sure this path is correct

class AppTextStyles {
  static const String headingFont = 'Syne';
  static const String bodyFont = 'DM Sans';

  // Heading styles
  static TextStyle heading({
    double size = 24,
    FontWeight weight = FontWeight.w800,
    Color color = AppColors.ink,
    double letterSpacing = -0.6,
  }) {
    return TextStyle(
      fontFamily: headingFont,
      fontSize: size,
      fontWeight: weight,
      color: color,
      letterSpacing: letterSpacing,
      height: 1.1,
    );
  }

  // Body styles
  static TextStyle body({
    double size = 15,
    FontWeight weight = FontWeight.w400,
    Color color = AppColors.ink2,
    double letterSpacing = 0,
  }) {
    return TextStyle(
      fontFamily: bodyFont,
      fontSize: size,
      fontWeight: weight,
      color: color,
      letterSpacing: letterSpacing,
      height: 1.6,
    );
  }

  // Label style (uppercase removed - we will uppercase the text when using it)
  static TextStyle label({
    double size = 11,
    FontWeight weight = FontWeight.w700,
    Color color = AppColors.ink3,
    double letterSpacing = 1.1,
  }) {
    return TextStyle(
      fontFamily: bodyFont,
      fontSize: size,
      fontWeight: weight,
      color: color,
      letterSpacing: letterSpacing,
    );
  }
}