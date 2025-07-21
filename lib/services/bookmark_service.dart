import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/bookmark.dart';

class BookmarkService {
  static const String _bookmarksKey = 'browseitt_bookmarks';
  
  static BookmarkService? _instance;
  static BookmarkService get instance => _instance ??= BookmarkService._();
  
  BookmarkService._();
  
  List<Bookmark> _bookmarks = [];
  List<Bookmark> get bookmarks => List.unmodifiable(_bookmarks);

  Future<void> initialize() async {
    await _loadBookmarks();
  }

  Future<void> _loadBookmarks() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final bookmarksJson = prefs.getString(_bookmarksKey);
      
      if (bookmarksJson != null) {
        final List<dynamic> bookmarksList = jsonDecode(bookmarksJson);
        _bookmarks = bookmarksList
            .map((json) => Bookmark.fromJson(json))
            .toList();
      }
    } catch (e) {
      // Handle error silently, start with empty bookmarks
      _bookmarks = [];
    }
  }

  Future<void> _saveBookmarks() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final bookmarksJson = jsonEncode(
        _bookmarks.map((bookmark) => bookmark.toJson()).toList(),
      );
      await prefs.setString(_bookmarksKey, bookmarksJson);
    } catch (e) {
      // Handle error silently
    }
  }

  Future<void> addBookmark(String title, String url, {String? favicon}) async {
    final bookmark = Bookmark(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title.trim(),
      url: url.trim(),
      favicon: favicon,
      createdAt: DateTime.now(),
    );
    
    _bookmarks.insert(0, bookmark);
    await _saveBookmarks();
  }

  Future<void> removeBookmark(String id) async {
    _bookmarks.removeWhere((bookmark) => bookmark.id == id);
    await _saveBookmarks();
  }

  bool isBookmarked(String url) {
    return _bookmarks.any((bookmark) => bookmark.url == url);
  }

  Bookmark? getBookmarkByUrl(String url) {
    try {
      return _bookmarks.firstWhere((bookmark) => bookmark.url == url);
    } catch (e) {
      return null;
    }
  }

  Future<void> clearAllBookmarks() async {
    _bookmarks.clear();
    await _saveBookmarks();
  }

  List<Bookmark> searchBookmarks(String query) {
    if (query.trim().isEmpty) return bookmarks;
    
    final lowerQuery = query.toLowerCase();
    return _bookmarks.where((bookmark) {
      return bookmark.title.toLowerCase().contains(lowerQuery) ||
             bookmark.url.toLowerCase().contains(lowerQuery);
    }).toList();
  }
}