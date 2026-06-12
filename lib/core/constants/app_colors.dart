import 'package:flutter/material.dart';

class AppColors {
  // Retro Pixel theme colors (Light background, dark red accents)
  static const Color background = Color(0xFFF6F5F5);
  static const Color backgroundDark = Color(0xFFEBEAEA);

  // Background and border for retro widgets
  static const Color cardBg = Color(0xFFFCF9F7);
  static const Color cardBorder = Color(0xFF701220);

  // Compatibility
  static const Color surface = cardBg;
  static const Color border = cardBorder;

  // Primary burgundy/red-brown
  static const Color primary = Color(0xFF701220);
  static const Color primaryDark = Color(0xFF500A13);
  static const Color accent = Color(0xFF0A2E1C); // Dark Green for question box

  // Action buttons
  static const Color answerYes = Color(0xFF701220); // Burgundy for primary confirmation
  static const Color answerNo = Color(0xFF5C514F);  // Gray-brown for secondary actions

  // Question container background (Forest Green)
  static const Color questionBg = Color(0xFF0A2E1C);
  static const Color questionBorder = Color(0xFF701220);

  // Particle color
  static const Color particle = Color(0xFFF3D8D8);

  // Texts
  static const Color textPrimary = Color(0xFF701220); // Burgundy for titles/headers
  static const Color textSecondary = Color(0xFF5C514F); // Gray/brown for description/body
  static const Color textDark = Color(0xFF1C1919);

  // Gradients (simplified/solid look to fit pixel art theme)
  static const LinearGradient tealGradient = LinearGradient(
    colors: [background, backgroundDark],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient magicGradient = LinearGradient(
    colors: [primary, primary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient darkBackgroundGradient = tealGradient;
}
