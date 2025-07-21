# Browseitt - Minimalistic iOS-Style Web Browser

A super-fast, minimalistic web browser built with Flutter/Dart, designed to feel like a native Swift iOS app.

## Features

- ✨ iOS-style minimalistic design with neutral colors (white, grey, dim green)
- 🚀 Super-fast performance optimized
- 📱 Native iOS feel without Cupertino widgets
- 🔧 Developer tools for networking
- 🖥️ Desktop mode support
- 📜 JavaScript support
- 🔍 Search functionality
- 📚 Bookmarks management
- 🏠 Home page with favorites
- 🔒 Privacy-focused browsing

## Dependencies (pubspec.yaml)

```yaml
name: browseitt
description: A minimalistic iOS-style web browser
version: 1.0.0+1

environment:
  sdk: '>=3.0.0 <4.0.0'
  flutter: ">=3.10.0"

dependencies:
  flutter:
    sdk: flutter
  webview_flutter: ^4.4.2
  url_launcher: ^6.2.1
  shared_preferences: ^2.2.2
  connectivity_plus: ^5.0.1
  flutter_svg: ^2.0.9
  http: ^1.1.0
  
dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.0

flutter:
  uses-material-design: true
  assets:
    - assets/icons/
```

## Android Manifest Permissions (android/app/src/main/AndroidManifest.xml)

```xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
```

## iOS Permissions (ios/Runner/Info.plist)

```xml
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSAllowsArbitraryLoads</key>
    <true/>
</dict>
<key>io.flutter.embedded_views_preview</key>
<true/>
```

## Build & Run

```bash
flutter pub get
flutter run
```

## Design Philosophy

- Minimalistic design inspired by iOS Safari
- Neutral color palette (whites, greys, dim green accents)
- Small icons and text for clean appearance
- No gradients - flat design approach
- Fast and responsive user experience