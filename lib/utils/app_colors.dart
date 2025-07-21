import 'package:flutter/material.dart';

class AppColors {
  // Primary colors - dim green theme with transparency
  static const Color background = Color(0xF0F8F8F8); // Semi-transparent light gray
  static const Color surface = Color(0xF0FFFFFF); // Semi-transparent white
  static const Color surfaceVariant = Color(0xF0F0F0F0); // Semi-transparent variant
  
  // Text colors with transparency
  static const Color textPrimary = Color(0xE0000000); // Semi-transparent black
  static const Color textSecondary = Color(0xB0666666); // Semi-transparent gray
  static const Color textTertiary = Color(0x80999999); // More transparent gray
  
  // Dim green accent colors with transparency
  static const Color primary = Color(0xE034A853); // Dim green with transparency
  static const Color primaryDim = Color(0xD0228B42); // Darker dim green
  static const Color primaryLight = Color(0xC048C964); // Lighter dim green
  static const Color primaryTransparent = Color(0x3034A853); // Very transparent green
  
  // Border and divider colors with transparency
  static const Color border = Color(0x60E0E0E0); // Transparent border
  static const Color divider = Color(0x40F0F0F0); // Very transparent divider
  
  // Icon colors with transparency
  static const Color iconPrimary = Color(0xD0000000); // Semi-transparent black
  static const Color iconSecondary = Color(0xA0666666); // Semi-transparent gray
  static const Color iconInactive = Color(0x60999999); // Transparent inactive
  static const Color iconAccent = Color(0xE034A853); // Dim green accent
  
  // Status colors with transparency
  static const Color error = Color(0xE0FF3B30); // Semi-transparent red
  static const Color warning = Color(0xE0FF9500); // Semi-transparent orange
  static const Color success = Color(0xE034A853); // Semi-transparent green
  
  // Button colors with transparency
  static const Color buttonBackground = Color(0xE0F8F8F8); // Semi-transparent light
  static const Color buttonText = Color(0xE034A853); // Dim green text
  static const Color buttonPressed = Color(0x2034A853); // Transparent pressed state
  
  // WebView and URL bar with transparency
  static const Color loadingBar = Color(0xE034A853); // Dim green loading
  static const Color urlBarBackground = Color(0xF0F8F8F8); // Semi-transparent URL bar
  static const Color overlay = Color(0x40000000); // Dark overlay for modals
  
  // iOS-style glass effect colors
  static const Color glassBackground = Color(0xF0FFFFFF); // Glass-like white
  static const Color glassBorder = Color(0x30FFFFFF); // Glass border
}