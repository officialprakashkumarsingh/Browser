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
        
        // App bar theme (though we removed app bars)
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          foregroundColor: AppColors.textPrimary,
          elevation: 0,
          scrolledUnderElevation: 0,
          systemOverlayStyle: SystemUiOverlayStyle.dark,
        ),
        
        // Scaffold theme with transparent background
        scaffoldBackgroundColor: AppColors.background,
        
        // Button themes for consistent styling
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            elevation: 0,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: AppColors.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        
        // Dialog theme for user scripts and bookmarks
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
        
        // Text themes for better consistency
        textTheme: const TextTheme(
          headlineSmall: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
          bodyLarge: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w400,
          ),
          bodyMedium: TextStyle(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w400,
          ),
          bodySmall: TextStyle(
            color: AppColors.textTertiary,
            fontWeight: FontWeight.w400,
          ),
        ),
        
        // Icon theme
        iconTheme: const IconThemeData(
          color: AppColors.iconPrimary,
          size: 20,
        ),
        
        // Input decoration theme
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.surfaceVariant,
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
            borderSide: const BorderSide(color: AppColors.primary),
          ),
          contentPadding: const EdgeInsets.all(12),
        ),
        
        // Page transitions for smoother navigation
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
            TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          },
        ),
        
        // Splash color and highlight color
        splashColor: AppColors.primaryTransparent,
        highlightColor: AppColors.primaryTransparent,
        
        // Visual density for better touch targets
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const BrowserScreen(),
    );
  }
}