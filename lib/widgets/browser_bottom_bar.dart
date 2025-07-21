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
      height: 48,
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 8),
      decoration: BoxDecoration(
        color: AppColors.glassBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.glassBorder, width: 0.5),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Back button
          _NavButton(
            emoji: '◀️',
            isEnabled: canGoBack,
            onPressed: onGoBack,
          ),
          
          // Forward button
          _NavButton(
            emoji: '▶️',
            isEnabled: canGoForward,
            onPressed: onGoForward,
          ),
          
          // Reload button
          _NavButton(
            emoji: '🔄',
            isEnabled: true,
            onPressed: onReload,
          ),
          
          // Home button
          _NavButton(
            emoji: '🏠',
            isEnabled: true,
            onPressed: onHome,
          ),
          
          // Desktop mode toggle
          _NavButton(
            emoji: isDesktopMode ? '📱' : '💻',
            isEnabled: true,
            onPressed: onToggleDesktopMode,
            isActive: isDesktopMode,
          ),
        ],
      ),
    );
  }
}

class _NavButton extends StatefulWidget {
  final String emoji;
  final bool isEnabled;
  final bool isActive;
  final VoidCallback onPressed;

  const _NavButton({
    required this.emoji,
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
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.9).animate(
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
                  : 0.3,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: _isPressed || widget.isActive
                      ? AppColors.primaryTransparent
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  widget.emoji,
                  style: TextStyle(
                    fontSize: 18,
                    color: widget.isActive
                        ? AppColors.primary
                        : widget.isEnabled
                            ? AppColors.textPrimary
                            : AppColors.textTertiary,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}