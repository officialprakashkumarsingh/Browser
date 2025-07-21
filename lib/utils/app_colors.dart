import 'package:flutter/material.dart';

class AppColors {
  // Primary colors - pure white theme with minimal accents
  static const Color background = Colors.white; // Pure white background
  static const Color surface = Colors.white; // Pure white surface
  static const Color surfaceVariant = Color(0xFFFAFAFA); // Very light off-white
  
  // Text colors - clean hierarchy
  static const Color textPrimary = Color(0xFF000000); // Pure black
  static const Color textSecondary = Color(0xFF666666); // Medium gray
  static const Color textTertiary = Color(0xFF999999); // Light gray
  
  // Minimal accent colors - removing green
  static const Color primary = Color(0xFF007AFF); // iOS blue
  static const Color primaryDim = Color(0xFF0056CC); // Darker blue
  static const Color primaryLight = Color(0xFF4DA3FF); // Lighter blue
  static const Color primaryTransparent = Color(0x1A007AFF); // Very transparent blue
  
  // Border and divider colors - very subtle
  static const Color border = Color(0xFFE5E5E5); // Light border
  static const Color divider = Color(0xFFF0F0F0); // Very light divider
  
  // Icon colors - clean hierarchy
  static const Color iconPrimary = Color(0xFF000000); // Pure black
  static const Color iconSecondary = Color(0xFF666666); // Medium gray
  static const Color iconInactive = Color(0xFFCCCCCC); // Light inactive
  static const Color iconAccent = Color(0xFF007AFF); // iOS blue accent
  
  // Status colors - iOS style
  static const Color error = Color(0xFFFF3B30); // iOS red
  static const Color warning = Color(0xFFFF9500); // iOS orange
  static const Color success = Color(0xFF34C759); // iOS green
  
  // Button colors - clean and minimal
  static const Color buttonBackground = Colors.white; // Pure white
  static const Color buttonText = Color(0xFF007AFF); // iOS blue text
  static const Color buttonPressed = Color(0x1A007AFF); // Transparent pressed state
  
  // WebView and URL bar - pure white
  static const Color loadingBar = Color(0xFF007AFF); // iOS blue loading
  static const Color urlBarBackground = Colors.white; // Pure white URL bar
  static const Color overlay = Color(0x40000000); // Dark overlay for modals
  
  // iOS-style minimal colors
  static const Color glassBackground = Colors.white; // Pure white glass
  static const Color glassBorder = Color(0xFFE5E5E5); // Light glass border
}