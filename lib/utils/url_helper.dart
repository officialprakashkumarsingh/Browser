class UrlHelper {
  static const String defaultSearchEngine = 'https://www.google.com/search?q=';
  
  static String formatUrl(String input) {
    if (input.trim().isEmpty) return '';
    
    String trimmed = input.trim();
    
    // If it looks like a search query (no dots and no protocol)
    if (!trimmed.contains('.') && !trimmed.startsWith('http')) {
      return '$defaultSearchEngine${Uri.encodeComponent(trimmed)}';
    }
    
    // If it's already a complete URL
    if (trimmed.startsWith('http://') || trimmed.startsWith('https://')) {
      return trimmed;
    }
    
    // If it looks like a domain
    if (trimmed.contains('.')) {
      return 'https://$trimmed';
    }
    
    // Default to search
    return '$defaultSearchEngine${Uri.encodeComponent(trimmed)}';
  }
  
  static String extractDomain(String url) {
    try {
      final uri = Uri.parse(url);
      return uri.host;
    } catch (e) {
      return url;
    }
  }
  
  static String getDisplayUrl(String url) {
    try {
      final uri = Uri.parse(url);
      String display = uri.host;
      if (uri.path.isNotEmpty && uri.path != '/') {
        display += uri.path;
      }
      return display;
    } catch (e) {
      return url;
    }
  }
  
  static bool isValidUrl(String url) {
    try {
      final uri = Uri.parse(url);
      return uri.hasScheme && (uri.scheme == 'http' || uri.scheme == 'https');
    } catch (e) {
      return false;
    }
  }
  
  static String getFaviconUrl(String url) {
    try {
      final uri = Uri.parse(url);
      return '${uri.scheme}://${uri.host}/favicon.ico';
    } catch (e) {
      return '';
    }
  }
  
  static String cleanTitle(String title) {
    return title.trim().replaceAll(RegExp(r'\s+'), ' ');
  }
  
  static List<String> getDefaultBookmarks() {
    return [
      'https://google.com',
      'https://github.com',
      'https://stackoverflow.com',
      'https://developer.mozilla.org',
      'https://flutter.dev',
    ];
  }
}