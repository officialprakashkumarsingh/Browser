import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../widgets/browser_bottom_bar.dart';
import '../widgets/url_bar.dart';
import '../widgets/home_page.dart';
import '../widgets/userscript_manager.dart';
import '../services/bookmark_service.dart';
import '../services/userscript_service.dart';
import '../utils/url_helper.dart';
import '../utils/app_colors.dart';

class BrowserScreen extends StatefulWidget {
  const BrowserScreen({super.key});

  @override
  State<BrowserScreen> createState() => _BrowserScreenState();
}

class _BrowserScreenState extends State<BrowserScreen> with TickerProviderStateMixin {
  late WebViewController _controller;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  
  String _currentUrl = '';
  String _currentTitle = '';
  bool _isLoading = false;
  bool _canGoBack = false;
  bool _canGoForward = false;
  bool _showHomePage = true;
  bool _showUserScriptManager = false;
  bool _isDesktopMode = false;
  double _loadingProgress = 0.0;
  
  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _initializeWebView();
    _initializeServices();
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  void _initializeServices() {
    BookmarkService.instance.initialize();
    UserScriptService.instance.initialize();
  }

  void _initializeWebView() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setUserAgent(_isDesktopMode ? _getDesktopUserAgent() : _getMobileUserAgent())
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
            await _injectUserScripts(url);
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

  String _getMobileUserAgent() {
    return 'Mozilla/5.0 (iPhone; CPU iPhone OS 17_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.0 Mobile/15E148 Safari/604.1';
  }

  Future<void> _injectUserScripts(String url) async {
    try {
      final domain = Uri.parse(url).host;
      final script = UserScriptService.instance.getInjectableScript(domain);
      if (script.isNotEmpty) {
        await _controller.runJavaScript(script);
      }
    } catch (e) {
      // Silently handle errors
    }
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
    _controller.setUserAgent(_isDesktopMode ? _getDesktopUserAgent() : _getMobileUserAgent());
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

  void _toggleUserScriptManager() {
    setState(() {
      _showUserScriptManager = !_showUserScriptManager;
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

  void _showBookmarkDialog() {
    if (_currentUrl.isEmpty) return;
    
    showDialog(
      context: context,
      barrierColor: AppColors.overlay,
      builder: (context) => Dialog(
        backgroundColor: AppColors.glassBackground,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primaryTransparent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.bookmark,
                      size: 20,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _currentTitle.isNotEmpty ? _currentTitle : 'Bookmark',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          UrlHelper.getDisplayUrl(_currentUrl),
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        _toggleBookmark();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        BookmarkService.instance.isBookmarked(_currentUrl) 
                            ? 'Remove' 
                            : 'Add',
                        style: const TextStyle(fontSize: 13),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            children: [
              // URL Bar only (no app bar)
              UrlBar(
                currentUrl: _currentUrl,
                onUrlSubmitted: _navigateToUrl,
                isLoading: _isLoading,
                loadingProgress: _loadingProgress,
                onBookmarkPressed: _showBookmarkDialog,
                onUserScriptPressed: _toggleUserScriptManager,
                showActions: !_showHomePage,
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
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(12),
                        ),
                        child: WebViewWidget(controller: _controller),
                      ),
                    
                    // User Script Manager Overlay
                    if (_showUserScriptManager)
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: UserScriptManager(
                          onClose: () => setState(() => _showUserScriptManager = false),
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
      ),
    );
  }
}