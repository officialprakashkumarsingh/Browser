import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/browser_screen.dart';
import 'utils/app_colors.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Set status bar style to match iOS with transparency
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );
  
  // Enable edge-to-edge display
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.edgeToEdge,
  );
  
  runApp(const BrowseittApp());
}

class BrowseittApp extends StatelessWidget {
  const BrowseittApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Browseitt',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          brightness: Brightness.light,
          background: AppColors.background,
          surface: AppColors.surface,
          primary: AppColors.primary,
          onPrimary: Colors.white,
          onSurface: AppColors.textPrimary,
          onBackground: AppColors.textPrimary,
        ),
        useMaterial3: true,
        fontFamily: 'SF Pro Display', // iOS-style font
        
        // App bar theme - minimal and clean
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          foregroundColor: AppColors.textPrimary,
          elevation: 0,
          scrolledUnderElevation: 0,
          systemOverlayStyle: SystemUiOverlayStyle.dark,
        ),
        
        // Scaffold theme with pure white background
        scaffoldBackgroundColor: AppColors.background,
        
        // Button themes for consistent iOS-style
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            elevation: 0,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
        
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: AppColors.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
        
        // Dialog theme for clean modals
        dialogTheme: DialogTheme(
          backgroundColor: AppColors.glassBackground,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        
        // Bottom sheet theme
        bottomSheetTheme: const BottomSheetThemeData(
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
        ),
        
        // Text themes for better hierarchy
        textTheme: const TextTheme(
          headlineSmall: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
          bodyLarge: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w400,
            fontSize: 16,
          ),
          bodyMedium: TextStyle(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w400,
            fontSize: 14,
          ),
          bodySmall: TextStyle(
            color: AppColors.textTertiary,
            fontWeight: FontWeight.w400,
            fontSize: 12,
          ),
        ),
        
        // Icon theme with consistent sizing
        iconTheme: const IconThemeData(
          color: AppColors.iconPrimary,
          size: 20,
        ),
        
        // Input decoration theme for consistent styling
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppColors.border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppColors.border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppColors.primary, width: 2),
          ),
          contentPadding: const EdgeInsets.all(12),
          hintStyle: const TextStyle(color: AppColors.textTertiary),
        ),
        
        // iOS-style page transitions for smoother navigation
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
            TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          },
        ),
        
        // Splash and highlight colors - minimal and clean
        splashColor: AppColors.primaryTransparent,
        highlightColor: AppColors.primaryTransparent,
        
        // Visual density for optimal touch targets
        visualDensity: VisualDensity.adaptivePlatformDensity,
        
        // Card theme for consistent containers
        cardTheme: CardTheme(
          color: AppColors.surface,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: AppColors.border),
          ),
        ),
        
        // Divider theme for subtle separators
        dividerTheme: const DividerThemeData(
          color: AppColors.divider,
          thickness: 1,
        ),
      ),
      home: const BrowserScreen(),
    );
  }
}