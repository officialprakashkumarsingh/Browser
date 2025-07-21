# Browseitt - Modern iOS-Style Web Browser

A minimalistic, fast, and feature-rich web browser built with Flutter, designed with iOS-style interface and smooth animations.

## 🚀 What's New

### Major Changes Implemented

#### ✅ **Interface Redesign**
- **Removed App Bar**: Cleaner, more immersive browsing experience
- **Removed Welcome Message**: Direct access to quick access grid
- **iOS-Style Design**: Rounded corners, glass effects, and smooth animations
- **Transparent Color Scheme**: Dim green theme with transparency throughout
- **Smaller Icons**: More compact and refined visual elements
- **HTML-Style Icons**: Emoji-based icons for better visual appeal

#### ✅ **New Features**

##### 🔧 **User Script Support**
- Add custom JavaScript scripts for any website
- Domain-specific script execution
- Enable/disable scripts individually
- Built-in script manager with intuitive UI
- Automatic script injection on page load

##### 🎨 **Enhanced UI/UX**
- Smooth fade-in animations without external packages
- Interactive button press animations
- Glass morphism effects
- iOS-style navigation and interactions
- Improved touch targets and visual feedback

##### ⚡ **Performance Optimizations**
- Removed developer tools for better performance
- Removed JavaScript console features
- Faster WebView initialization
- Optimized memory usage
- Smooth 60fps animations

##### 🌐 **Browser Features**
- Enhanced security indicators in URL bar
- Better mobile/desktop user agent switching
- Improved bookmark management
- Quick access to popular websites
- Edge-to-edge display support

## 🎯 Key Features

### Core Browser Functionality
- **Fast WebView**: Optimized for speed and performance
- **Bookmark Management**: Save and organize your favorite sites
- **Desktop/Mobile Mode**: Switch user agents for better compatibility
- **Security Indicators**: Visual HTTPS/HTTP status in URL bar
- **Quick Access Grid**: One-tap access to popular websites

### User Scripts
- **Custom JavaScript**: Inject your own scripts into websites
- **Domain Filtering**: Target specific websites or use wildcards
- **Script Management**: Easy enable/disable toggle
- **Safe Execution**: Error handling to prevent crashes
- **Persistent Storage**: Scripts saved across app restarts

### Modern Design
- **iOS-Style Interface**: Native iOS look and feel
- **Dim Green Theme**: Consistent color scheme throughout
- **Glass Effects**: Modern transparency and blur effects
- **Smooth Animations**: 60fps transitions and interactions
- **Compact Layout**: Optimized for mobile screens

## 📱 Interface Overview

### Home Screen
- **Quick Access Grid**: 3x3 grid with emoji icons for popular sites
- **Recent Bookmarks**: Quick access to saved pages
- **Smooth Animations**: Fade-in effects and interactive feedback

### Browser View
- **Clean URL Bar**: Security indicators and action buttons
- **Floating Bottom Bar**: iOS-style navigation with emoji icons
- **User Script Access**: Quick toggle for script management
- **Bookmark Integration**: One-tap bookmark adding/removing

### User Script Manager
- **Add Scripts**: Simple form for script creation
- **Manage Scripts**: Enable/disable with visual indicators
- **Domain Targeting**: Flexible domain matching
- **Script Editor**: Multi-line JavaScript input

## 🔧 Technical Improvements

### Performance Enhancements
- Removed heavy developer tools
- Optimized WebView settings
- Efficient animation controllers
- Reduced memory footprint
- Faster startup times

### Code Quality
- Modern Flutter architecture
- Clean separation of concerns
- Consistent error handling
- Optimized widget rebuilds
- Type-safe implementations

### User Experience
- Haptic feedback on interactions
- Visual state indicators
- Smooth page transitions
- Intuitive navigation patterns
- Accessible design elements

## 🎨 Design System

### Color Palette
- **Primary**: Dim green (#34A853) with transparency
- **Background**: Light gray with transparency
- **Surface**: White with glass effects
- **Text**: Hierarchical grayscale system
- **Icons**: Contextual color coding

### Typography
- **Font**: SF Pro Display (iOS-style)
- **Hierarchy**: Clear size and weight system
- **Readability**: Optimized for mobile screens

### Animations
- **Duration**: 150-300ms for optimal feel
- **Curves**: iOS-style easing functions
- **Feedback**: Visual and interactive responses
- **Performance**: 60fps smooth animations

## 🚀 Performance Features

### Fast Browsing
- Optimized WebView configuration
- Efficient user script injection
- Minimal UI overhead
- Quick navigation responses

### Memory Management
- Automatic cleanup of animations
- Efficient state management
- Reduced widget tree complexity
- Optimized image handling

### Battery Optimization
- Minimal background processing
- Efficient animation controllers
- Smart resource management
- Optimized network requests

## 📋 User Script Examples

### Remove Ads
```javascript
// Remove common ad elements
document.querySelectorAll('.ad, .advertisement, [class*="ads"]').forEach(el => el.remove());
```

### Dark Mode Toggle
```javascript
// Toggle dark mode on any website
document.body.style.filter = document.body.style.filter ? '' : 'invert(1) hue-rotate(180deg)';
```

### Auto-scroll
```javascript
// Auto-scroll for reading
setInterval(() => window.scrollBy(0, 1), 50);
```

## 🔒 Privacy & Security

### User Scripts
- Sandboxed execution environment
- Error handling prevents crashes
- No access to sensitive APIs
- Local storage only

### Browsing
- No tracking or analytics
- Local bookmark storage
- Secure HTTPS indicators
- Private by design

## 🎯 Future Enhancements

### Planned Features
- Tab management system
- Download manager
- Reading mode
- Ad blocker integration
- Sync across devices

### Performance Goals
- Sub-second startup time
- Instant page switching
- Smooth 120fps animations
- Minimal memory usage

## 🛠️ Development

### Requirements
- Flutter 3.10.0+
- Dart 3.0.0+
- iOS 11.0+ / Android 5.0+

### Dependencies
- `webview_flutter`: ^4.4.2
- `shared_preferences`: ^2.2.2
- `url_launcher`: ^6.2.1
- Standard Flutter packages only

### Build
```bash
flutter pub get
flutter run
```

## 📄 License

This project is open source and available under the MIT License.

---

**Browseitt** - Fast, Beautiful, Powerful 🚀