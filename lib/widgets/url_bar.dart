import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../utils/url_helper.dart';

class UrlBar extends StatefulWidget {
  final String currentUrl;
  final Function(String) onUrlSubmitted;
  final bool isLoading;
  final double loadingProgress;
  final VoidCallback? onBookmarkPressed;
  final VoidCallback? onUserScriptPressed;
  final bool showActions;

  const UrlBar({
    super.key,
    required this.currentUrl,
    required this.onUrlSubmitted,
    required this.isLoading,
    required this.loadingProgress,
    this.onBookmarkPressed,
    this.onUserScriptPressed,
    this.showActions = false,
  });

  @override
  State<UrlBar> createState() => _UrlBarState();
}

class _UrlBarState extends State<UrlBar> with TickerProviderStateMixin {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode = FocusNode();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    
    _focusNode.addListener(() {
      setState(() {
        _isEditing = _focusNode.hasFocus;
      });
      
      if (_focusNode.hasFocus) {
        _animationController.forward();
        _controller.text = widget.currentUrl;
        _controller.selection = TextSelection(
          baseOffset: 0,
          extentOffset: _controller.text.length,
        );
      } else {
        _animationController.reverse();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(UrlBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_isEditing && widget.currentUrl != oldWidget.currentUrl) {
      _controller.text = UrlHelper.getDisplayUrl(widget.currentUrl);
    }
  }

  void _onSubmitted(String value) {
    _focusNode.unfocus();
    widget.onUrlSubmitted(value);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 8, 12, 8),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppColors.urlBarBackground,
              borderRadius: BorderRadius.circular(12),
              border: _isEditing ? Border.all(
                color: AppColors.primary,
                width: 1.5,
              ) : null,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(_isEditing ? 0.2 : 0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                // Search/URL icon
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Icon(
                    _isEditing ? Icons.search : _getSecurityIcon(),
                    size: 16,
                    color: _isEditing 
                        ? AppColors.primary 
                        : _getSecurityColor(),
                  ),
                ),
                
                // URL/Search text field
                Expanded(
                  child: Container(
                    height: 36,
                    alignment: Alignment.centerLeft,
                    child: TextField(
                      controller: _controller,
                      focusNode: _focusNode,
                      onSubmitted: _onSubmitted,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w400,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Search or enter URL',
                        hintStyle: const TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w400,
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                ),
                
                // Action buttons
                if (widget.showActions) ...[
                  // Bookmark button
                  if (widget.onBookmarkPressed != null)
                    _ActionButton(
                      icon: Icons.bookmark_border,
                      onPressed: widget.onBookmarkPressed!,
                      size: 16,
                    ),
                  
                  // User Script button
                  if (widget.onUserScriptPressed != null)
                    _ActionButton(
                      icon: Icons.code,
                      onPressed: widget.onUserScriptPressed!,
                      size: 16,
                    ),
                ],
                
                // Clear button (when editing)
                if (_isEditing && _controller.text.isNotEmpty)
                  _ActionButton(
                    icon: Icons.clear,
                    onPressed: () {
                      _controller.clear();
                      setState(() {});
                    },
                    size: 16,
                  ),
                
                const SizedBox(width: 4),
              ],
            ),
          ),
          
          // Loading progress bar
          if (widget.isLoading && widget.loadingProgress > 0)
            Container(
              height: 2,
              margin: const EdgeInsets.fromLTRB(12, 4, 12, 0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(1),
                child: LinearProgressIndicator(
                  value: widget.loadingProgress,
                  backgroundColor: AppColors.border,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppColors.loadingBar,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  IconData _getSecurityIcon() {
    if (widget.currentUrl.isEmpty) return Icons.search;
    if (widget.currentUrl.startsWith('https://')) {
      return Icons.lock;
    } else if (widget.currentUrl.startsWith('http://')) {
      return Icons.lock_open;
    }
    return Icons.language;
  }

  Color _getSecurityColor() {
    if (widget.currentUrl.isEmpty) return AppColors.iconSecondary;
    if (widget.currentUrl.startsWith('https://')) {
      return AppColors.success;
    } else if (widget.currentUrl.startsWith('http://')) {
      return AppColors.warning;
    }
    return AppColors.iconSecondary;
  }
}

class _ActionButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final double size;

  const _ActionButton({
    required this.icon,
    required this.onPressed,
    required this.size,
  });

  @override
  State<_ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<_ActionButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.85).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() => _isPressed = true);
        _controller.forward();
      },
      onTapUp: (_) {
        setState(() => _isPressed = false);
        _controller.reverse();
        widget.onPressed();
      },
      onTapCancel: () {
        setState(() => _isPressed = false);
        _controller.reverse();
      },
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: _isPressed 
                    ? AppColors.primaryTransparent 
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(
                widget.icon,
                size: widget.size,
                color: _isPressed 
                    ? AppColors.primary 
                    : AppColors.iconSecondary,
              ),
            ),
          );
        },
      ),
    );
  }
}