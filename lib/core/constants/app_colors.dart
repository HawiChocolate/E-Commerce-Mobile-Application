import 'package:flutter/material.dart';

/// Centralized color palette pulled from the food delivery design mockups.
/// Never hardcode a Color literal in a widget — always reference AppColors.
class AppColors {
  AppColors._(); // prevent instantiation

  // Backgrounds
  static const Color background = Color(0xFFF7D9CE);   // blush/salmon behind screens
  static const Color surface = Color(0xFFFFFFFF);       // cards, sheets
  static const Color surfaceMuted = Color(0xFFFAFAFA);  // subtle off-white surface

  // Brand / CTA
  static const Color primary = Color(0xFF1A1A1A);       // near-black buttons
  static const Color accent = Color(0xFFF4511E);        // orange-red badges, stepper +

  // Text
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF8D8D8D);
  static const Color textOnPrimary = Color(0xFFFFFFFF); // text on black buttons

  // Status
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFE53935);
  static const Color rating = Color(0xFFFFB800);        // gold star

  // Borders / dividers
  static const Color border = Color(0xFFE0E0E0);
}