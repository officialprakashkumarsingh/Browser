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
  final VoidCallback? onUserScriptPressed;

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
    this.onUserScriptPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 8),
      decoration: BoxDecoration(
        color: AppColors.glassBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.glassBorder, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Reload button
          _NavButton(
            icon: Icons.refresh,
            isEnabled: true,
            onPressed: onReload,
          ),
          
          // Home button
          _NavButton(
            icon: Icons.home,
            isEnabled: true,
            onPressed: onHome,
          ),
          
          // Desktop mode toggle
          _NavButton(
            icon: isDesktopMode ? Icons.phone_iphone : Icons.desktop_mac,
            isEnabled: true,
            onPressed: onToggleDesktopMode,
            isActive: isDesktopMode,
          ),
          
          // User Script button
          if (onUserScriptPressed != null)
            _NavButton(
              icon: Icons.code,
              isEnabled: true,
              onPressed: onUserScriptPressed!,
            ),
        ],
      ),
    );
  }
}

class _NavButton extends StatefulWidget {
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
  State<_NavButton> createState() => _NavButtonState();
}

class _NavButtonState extends State<_NavButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 120),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.85).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _opacityAnimation = Tween<double>(begin: 1.0, end: 0.7).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: widget.isEnabled ? (_) {
        setState(() => _isPressed = true);
        _animationController.forward();
      } : null,
      onTapUp: widget.isEnabled ? (_) {
        setState(() => _isPressed = false);
        _animationController.reverse();
        widget.onPressed();
      } : null,
      onTapCancel: widget.isEnabled ? () {
        setState(() => _isPressed = false);
        _animationController.reverse();
      } : null,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Opacity(
              opacity: widget.isEnabled 
                  ? _opacityAnimation.value 
                  : 0.4,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: _isPressed || widget.isActive
                      ? AppColors.primaryTransparent
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  widget.icon,
                  size: 18,
                  color: widget.isActive
                      ? AppColors.primary
                      : widget.isEnabled
                          ? AppColors.iconPrimary
                          : AppColors.iconInactive,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}