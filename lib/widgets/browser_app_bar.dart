import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class BrowserAppBar extends StatelessWidget {
  final String title;
  final bool isBookmarked;
  final VoidCallback onBookmarkToggle;
  final VoidCallback onShowDeveloperTools;
  final bool showBookmarkButton;

  const BrowserAppBar({
    super.key,
    required this.title,
    required this.isBookmarked,
    required this.onBookmarkToggle,
    required this.onShowDeveloperTools,
    this.showBookmarkButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(
          bottom: BorderSide(
            color: AppColors.border,
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        children: [
          // Title
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          
          // Action buttons
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Bookmark button
              if (showBookmarkButton)
                _IconButton(
                  icon: isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                  onPressed: onBookmarkToggle,
                  color: isBookmarked ? AppColors.primary : AppColors.iconSecondary,
                ),
              
              const SizedBox(width: 8),
              
              // Developer tools button
              _IconButton(
                icon: Icons.code,
                onPressed: onShowDeveloperTools,
                color: AppColors.iconSecondary,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _IconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final Color color;

  const _IconButton({
    required this.icon,
    required this.onPressed,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(8),
        child: Icon(
          icon,
          size: 20,
          color: color,
        ),
      ),
    );
  }
}