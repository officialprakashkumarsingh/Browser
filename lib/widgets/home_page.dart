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

class _HomePageState extends State<HomePage> {
  List<Bookmark> _bookmarks = [];
  final List<QuickAccess> _quickAccess = [
    QuickAccess('Google', 'https://google.com', Icons.search),
    QuickAccess('GitHub', 'https://github.com', Icons.code),
    QuickAccess('Stack Overflow', 'https://stackoverflow.com', Icons.help_outline),
    QuickAccess('Flutter', 'https://flutter.dev', Icons.widgets),
    QuickAccess('MDN', 'https://developer.mozilla.org', Icons.article),
    QuickAccess('YouTube', 'https://youtube.com', Icons.play_circle_outline),
  ];

  @override
  void initState() {
    super.initState();
    _loadBookmarks();
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
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome section
            const SizedBox(height: 20),
            const Text(
              'Welcome to Browseitt',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Fast, minimalistic browsing',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary,
              ),
            ),
            
            const SizedBox(height: 40),
            
            // Quick Access
            const Text(
              'Quick Access',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1.0,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: _quickAccess.length,
              itemBuilder: (context, index) {
                final item = _quickAccess[index];
                return _QuickAccessTile(
                  item: item,
                  onTap: () => widget.onUrlSelected(item.url),
                );
              },
            ),
            
            // Bookmarks section
            if (_bookmarks.isNotEmpty) ...[
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Bookmarks',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  GestureDetector(
                    onTap: _showBookmarksSheet,
                    child: const Text(
                      'See All',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
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
          ],
        ),
      ),
    );
  }

  void _showBookmarksSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'All Bookmarks',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
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
  final IconData icon;

  QuickAccess(this.name, this.url, this.icon);
}

class _QuickAccessTile extends StatelessWidget {
  final QuickAccess item;
  final VoidCallback onTap;

  const _QuickAccessTile({
    required this.item,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.border,
            width: 0.5,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              item.icon,
              size: 32,
              color: AppColors.iconPrimary,
            ),
            const SizedBox(height: 8),
            Text(
              item.name,
              style: const TextStyle(
                fontSize: 12,
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
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        leading: Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: AppColors.surfaceVariant,
            borderRadius: BorderRadius.circular(6),
          ),
          child: const Icon(
            Icons.bookmark,
            size: 16,
            color: AppColors.primary,
          ),
        ),
        title: Text(
          bookmark.title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          UrlHelper.getDisplayUrl(bookmark.url),
          style: const TextStyle(
            fontSize: 13,
            color: AppColors.textSecondary,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: GestureDetector(
          onTap: onDelete,
          child: const Icon(
            Icons.delete_outline,
            size: 18,
            color: AppColors.iconSecondary,
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}