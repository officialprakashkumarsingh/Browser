import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class BrowserBottomBar extends StatelessWidget {
  final bool canGoBack;
  final bool canGoForward;
  final bool isDesktopMode;
  final VoidCallback onGoBack;
  final VoidCallback onGoForward;
  final VoidCallback onReload;
  final VoidCallback onHome;
  final VoidCallback onToggleDesktopMode;

  const BrowserBottomBar({
    super.key,
    required this.canGoBack,
    required this.canGoForward,
    required this.isDesktopMode,
    required this.onGoBack,
    required this.onGoForward,
    required this.onReload,
    required this.onHome,
    required this.onToggleDesktopMode,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(
          top: BorderSide(
            color: AppColors.border,
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Back button
          _NavButton(
            icon: Icons.arrow_back_ios,
            isEnabled: canGoBack,
            onPressed: onGoBack,
          ),
          
          // Forward button
          _NavButton(
            icon: Icons.arrow_forward_ios,
            isEnabled: canGoForward,
            onPressed: onGoForward,
          ),
          
          // Reload button
          _NavButton(
            icon: Icons.refresh,
            isEnabled: true,
            onPressed: onReload,
          ),
          
          // Home button
          _NavButton(
            icon: Icons.home_outlined,
            isEnabled: true,
            onPressed: onHome,
          ),
          
          // Desktop mode toggle
          _NavButton(
            icon: isDesktopMode ? Icons.smartphone : Icons.desktop_mac,
            isEnabled: true,
            onPressed: onToggleDesktopMode,
            isActive: isDesktopMode,
          ),
        ],
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  final IconData icon;
  final bool isEnabled;
  final bool isActive;
  final VoidCallback onPressed;

  const _NavButton({
    required this.icon,
    required this.isEnabled,
    required this.onPressed,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isEnabled ? onPressed : null,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Icon(
          icon,
          size: 22,
          color: isActive
              ? AppColors.primary
              : isEnabled
                  ? AppColors.iconPrimary
                  : AppColors.iconInactive,
        ),
      ),
    );
  }
}