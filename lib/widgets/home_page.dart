import 'package:flutter/material.dart';
import '../models/bookmark.dart';
import '../services/bookmark_service.dart';
import '../utils/app_colors.dart';
import '../utils/url_helper.dart';

class HomePage extends StatefulWidget {
  final Function(String) onUrlSelected;

  const HomePage({
    super.key,
    required this.onUrlSelected,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  List<Bookmark> _bookmarks = [];
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  
  final List<QuickAccess> _quickAccess = [
    QuickAccess('Google', 'https://google.com', '🔍'),
    QuickAccess('GitHub', 'https://github.com', '📁'),
    QuickAccess('Stack Overflow', 'https://stackoverflow.com', '❓'),
    QuickAccess('Flutter', 'https://flutter.dev', '📱'),
    QuickAccess('MDN', 'https://developer.mozilla.org', '📚'),
    QuickAccess('YouTube', 'https://youtube.com', '📺'),
    QuickAccess('Reddit', 'https://reddit.com', '💬'),
    QuickAccess('Twitter', 'https://twitter.com', '🐦'),
    QuickAccess('Facebook', 'https://facebook.com', '👥'),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _loadBookmarks();
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _loadBookmarks() {
    setState(() {
      _bookmarks = BookmarkService.instance.bookmarks;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              
              // Quick Access Grid
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 1.0,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: _quickAccess.length,
                itemBuilder: (context, index) {
                  final item = _quickAccess[index];
                  return _QuickAccessTile(
                    item: item,
                    onTap: () => widget.onUrlSelected(item.url),
                    animationDelay: index * 50,
                  );
                },
              ),
              
              // Bookmarks section
              if (_bookmarks.isNotEmpty) ...[
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Bookmarks',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    GestureDetector(
                      onTap: _showBookmarksSheet,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primaryTransparent,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          'See All',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _bookmarks.take(5).length,
                  itemBuilder: (context, index) {
                    final bookmark = _bookmarks[index];
                    return _BookmarkTile(
                      bookmark: bookmark,
                      onTap: () => widget.onUrlSelected(bookmark.url),
                      onDelete: () => _deleteBookmark(bookmark.id),
                    );
                  },
                ),
              ],
              
              const SizedBox(height: 80), // Extra space for bottom bar
            ],
          ),
        ),
      ),
    );
  }

  void _showBookmarksSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.7,
          decoration: BoxDecoration(
            color: AppColors.glassBackground,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            border: Border.all(color: AppColors.glassBorder, width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, -8),
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: AppColors.border, width: 1),
                  ),
                ),
                child: Row(
                  children: [
                    const Text(
                      'All Bookmarks',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(
                        Icons.close,
                        size: 18,
                        color: AppColors.iconSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _bookmarks.length,
                  itemBuilder: (context, index) {
                    final bookmark = _bookmarks[index];
                    return _BookmarkTile(
                      bookmark: bookmark,
                      onTap: () {
                        Navigator.pop(context);
                        widget.onUrlSelected(bookmark.url);
                      },
                      onDelete: () => _deleteBookmark(bookmark.id),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _deleteBookmark(String id) async {
    await BookmarkService.instance.removeBookmark(id);
    _loadBookmarks();
  }
}

class QuickAccess {
  final String name;
  final String url;
  final String emoji;

  QuickAccess(this.name, this.url, this.emoji);
}

class _QuickAccessTile extends StatefulWidget {
  final QuickAccess item;
  final VoidCallback onTap;
  final int animationDelay;

  const _QuickAccessTile({
    required this.item,
    required this.onTap,
    required this.animationDelay,
  });

  @override
  State<_QuickAccessTile> createState() => _QuickAccessTileState();
}

class _QuickAccessTileState extends State<_QuickAccessTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
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
        widget.onTap();
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
              decoration: BoxDecoration(
                color: _isPressed 
                    ? AppColors.primaryTransparent 
                    : AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _isPressed ? AppColors.primary : AppColors.border,
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.item.emoji,
                    style: const TextStyle(fontSize: 28),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    widget.item.name,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _BookmarkTile extends StatelessWidget {
  final Bookmark bookmark;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _BookmarkTile({
    required this.bookmark,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
        leading: Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: AppColors.primaryTransparent,
            borderRadius: BorderRadius.circular(6),
          ),
          child: const Center(
            child: Text(
              '🔖',
              style: TextStyle(fontSize: 14),
            ),
          ),
        ),
        title: Text(
          bookmark.title,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          UrlHelper.getDisplayUrl(bookmark.url),
          style: const TextStyle(
            fontSize: 11,
            color: AppColors.textSecondary,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: GestureDetector(
          onTap: onDelete,
          child: Container(
            padding: const EdgeInsets.all(6),
            child: const Icon(
              Icons.close,
              size: 14,
              color: AppColors.iconSecondary,
            ),
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}