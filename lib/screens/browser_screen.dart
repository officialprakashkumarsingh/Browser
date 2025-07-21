import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../widgets/browser_app_bar.dart';
import '../widgets/browser_bottom_bar.dart';
import '../widgets/url_bar.dart';
import '../widgets/home_page.dart';
import '../widgets/developer_tools.dart';
import '../services/bookmark_service.dart';
import '../utils/url_helper.dart';
import '../utils/app_colors.dart';

class BrowserScreen extends StatefulWidget {
  const BrowserScreen({super.key});

  @override
  State<BrowserScreen> createState() => _BrowserScreenState();
}

class _BrowserScreenState extends State<BrowserScreen> {
  late WebViewController _controller;
  String _currentUrl = '';
  String _currentTitle = '';
  bool _isLoading = false;
  bool _canGoBack = false;
  bool _canGoForward = false;
  bool _showHomePage = true;
  bool _showDeveloperTools = false;
  bool _isDesktopMode = false;
  double _loadingProgress = 0.0;
  
  @override
  void initState() {
    super.initState();
    _initializeWebView();
    BookmarkService.instance.initialize();
  }

  void _initializeWebView() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setUserAgent(_isDesktopMode ? _getDesktopUserAgent() : null)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            setState(() {
              _loadingProgress = progress / 100.0;
              _isLoading = progress < 100;
            });
          },
          onPageStarted: (String url) {
            setState(() {
              _currentUrl = url;
              _isLoading = true;
              _showHomePage = false;
            });
          },
          onPageFinished: (String url) async {
            setState(() {
              _currentUrl = url;
              _isLoading = false;
            });
            await _updateNavigationState();
            await _updatePageTitle();
          },
          onUrlChange: (UrlChange change) {
            if (change.url != null) {
              setState(() {
                _currentUrl = change.url!;
              });
            }
          },
        ),
      );
  }

  String _getDesktopUserAgent() {
    return 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36';
  }

  Future<void> _updateNavigationState() async {
    final canGoBack = await _controller.canGoBack();
    final canGoForward = await _controller.canGoForward();
    setState(() {
      _canGoBack = canGoBack;
      _canGoForward = canGoForward;
    });
  }

  Future<void> _updatePageTitle() async {
    try {
      final title = await _controller.getTitle();
      setState(() {
        _currentTitle = title ?? UrlHelper.extractDomain(_currentUrl);
      });
    } catch (e) {
      setState(() {
        _currentTitle = UrlHelper.extractDomain(_currentUrl);
      });
    }
  }

  void _navigateToUrl(String input) {
    if (input.trim().isEmpty) return;
    
    final url = UrlHelper.formatUrl(input);
    _controller.loadRequest(Uri.parse(url));
    setState(() {
      _showHomePage = false;
    });
  }

  void _goBack() {
    if (_canGoBack) {
      _controller.goBack();
    }
  }

  void _goForward() {
    if (_canGoForward) {
      _controller.goForward();
    }
  }

  void _reload() {
    if (_showHomePage) {
      setState(() {
        _showHomePage = true;
      });
    } else {
      _controller.reload();
    }
  }

  void _toggleDesktopMode() {
    setState(() {
      _isDesktopMode = !_isDesktopMode;
    });
    _controller.setUserAgent(_isDesktopMode ? _getDesktopUserAgent() : null);
    if (!_showHomePage) {
      _controller.reload();
    }
  }

  void _showHome() {
    setState(() {
      _showHomePage = true;
      _currentUrl = '';
      _currentTitle = '';
      _isLoading = false;
      _loadingProgress = 0.0;
    });
  }

  void _toggleDeveloperTools() {
    setState(() {
      _showDeveloperTools = !_showDeveloperTools;
    });
  }

  Future<void> _toggleBookmark() async {
    if (_currentUrl.isEmpty) return;
    
    final bookmarkService = BookmarkService.instance;
    if (bookmarkService.isBookmarked(_currentUrl)) {
      final bookmark = bookmarkService.getBookmarkByUrl(_currentUrl);
      if (bookmark != null) {
        await bookmarkService.removeBookmark(bookmark.id);
      }
    } else {
      await bookmarkService.addBookmark(
        _currentTitle.isNotEmpty ? _currentTitle : UrlHelper.extractDomain(_currentUrl),
        _currentUrl,
        favicon: UrlHelper.getFaviconUrl(_currentUrl),
      );
    }
    setState(() {}); // Refresh UI
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Custom App Bar
            BrowserAppBar(
              title: _showHomePage ? 'Browseitt' : _currentTitle,
              isBookmarked: BookmarkService.instance.isBookmarked(_currentUrl),
              onBookmarkToggle: _toggleBookmark,
              onShowDeveloperTools: _toggleDeveloperTools,
              showBookmarkButton: !_showHomePage,
            ),
            
            // URL Bar
            UrlBar(
              currentUrl: _currentUrl,
              onUrlSubmitted: _navigateToUrl,
              isLoading: _isLoading,
              loadingProgress: _loadingProgress,
            ),
            
            // Content Area
            Expanded(
              child: Stack(
                children: [
                  // WebView or Home Page
                  if (_showHomePage)
                    HomePage(
                      onUrlSelected: _navigateToUrl,
                    )
                  else
                    WebViewWidget(controller: _controller),
                  
                  // Developer Tools Overlay
                  if (_showDeveloperTools)
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: DeveloperTools(
                        currentUrl: _currentUrl,
                        controller: _controller,
                        onClose: () => setState(() => _showDeveloperTools = false),
                      ),
                    ),
                ],
              ),
            ),
            
            // Bottom Navigation Bar
            BrowserBottomBar(
              canGoBack: _canGoBack,
              canGoForward: _canGoForward,
              isDesktopMode: _isDesktopMode,
              onGoBack: _goBack,
              onGoForward: _goForward,
              onReload: _reload,
              onHome: _showHome,
              onToggleDesktopMode: _toggleDesktopMode,
            ),
          ],
        ),
      ),
    );
  }
}