# Dynamic Icon

<p align="center">
  <img src="https://miro.medium.com/v2/resize:fit:1400/format:webp/1*yW2XJOV3WbLN1ufOzZQVlQ.png" alt="Dynamic Icon" width="600"/>
</p>

[![pub package](https://img.shields.io/pub/v/dynamic_icon.svg)](https://pub.dev/packages/dynamic_icon)

A Flutter plugin that allows changing your app's icon dynamically on iOS and Android.

## Features

- Change your app icon at runtime
- Get the current active icon
- Get a list of all available alternative icons
- Reset to the default app icon

## Platform Support

| Android | iOS |
|---------|-----|
| ✅      | ✅   |

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  dynamic_icon: ^latest_version
```

### iOS Setup

1. Add alternative icons to your iOS project in Xcode.
2. Open your project in Xcode: `open ios/Runner.xcworkspace`
3. Add alternative icon assets to the Assets.xcassets:
   - In Xcode, right-click on Assets.xcassets and select "New App Icon"
   - Name it according to the icon name you'll use in your code (e.g., "icon_name_1")
   - Drag and drop your icon images into the appropriate slots for different device sizes
   - Repeat for each alternative icon you want to use

4. Enable alternative icons in build settings:
   - In Xcode, select your project in the Project Navigator
   - Select your target and go to the "Build Settings" tab
   - Search for "Include All App Icon Assets"
   - Change the setting to "Yes"

<p align="center">
  <img src="https://github.com/hautvfami/dynamic_icon/blob/main/example/captures/image.png?raw=true" alt="Include All App Icon Assets" width="600"/>
</p>

### Android Setup

1. Add alternative icons to your Android project:
   - Create your icon image files in various resolutions for different screen densities
   - Place them in the appropriate mipmap folders in your Android project:
     ```
     android/app/src/main/res/mipmap-mdpi/icon_name_1.png
     android/app/src/main/res/mipmap-hdpi/icon_name_1.png
     android/app/src/main/res/mipmap-xhdpi/icon_name_1.png
     android/app/src/main/res/mipmap-xxhdpi/icon_name_1.png
     android/app/src/main/res/mipmap-xxxhdpi/icon_name_1.png
     ```
   - Repeat for each alternative icon (icon_name_2, etc.)
   - Ensure each icon follows Android's adaptive icon format if targeting newer Android versions

2. Create activity-aliases in your `AndroidManifest.xml`:

```xml
<manifest ...>
    <application ...>
        <!-- Default Activity -->
        <activity 
            android:name=".MainActivity"
            android:exported="true"
            android:theme="@style/LaunchTheme"
            android:configChanges="orientation|keyboardHidden|keyboard|screenSize|smallestScreenSize|locale|layoutDirection|fontScale|screenLayout|density|uiMode"
            android:hardwareAccelerated="true"
            android:windowSoftInputMode="adjustResize">
            <meta-data
                android:name="io.flutter.embedding.android.NormalTheme"
                android:resource="@style/NormalTheme" />
            <intent-filter>
                <action android:name="android.intent.action.MAIN" />
                <category android:name="android.intent.category.LAUNCHER" />
            </intent-filter>
        </activity>
        
        <!-- Alternative Icon 1 -->
        <activity-alias
            android:name=".icon_name_1"
            android:enabled="false"
            android:icon="@mipmap/icon_name_1"
            android:targetActivity=".MainActivity"
            android:exported="true">
            <intent-filter>
                <action android:name="android.intent.action.MAIN" />
                <category android:name="android.intent.category.LAUNCHER" />
            </intent-filter>
        </activity-alias>
        
        <!-- Alternative Icon 2 -->
        <activity-alias
            android:name=".icon_name_2"
            android:enabled="false"
            android:icon="@mipmap/icon_name_2"
            android:targetActivity=".MainActivity"
            android:exported="true">
            <intent-filter>
                <action android:name="android.intent.action.MAIN" />
                <category android:name="android.intent.category.LAUNCHER" />
            </intent-filter>
        </activity-alias>
    </application>
</manifest>
```

## Usage

Import the package:

```dart
import 'package:dynamic_icon/dynamic_icon.dart';
```

### Get available icons

```dart
final DynamicIcon dynamicIcon = DynamicIcon();
List<String> icons = await dynamicIcon.getAvailableIcons();
print(icons); // ['icon_name_1', 'icon_name_2', ...]
```

### Get current icon

```dart
String? currentIcon = await dynamicIcon.getCurrentIcon();
print(currentIcon); // 'icon_name_1' or null for default icon
```

### Change app icon

```dart
try {
  await dynamicIcon.setIcon('icon_name_1');
  print('App icon changed successfully');
} catch (e) {
  print('Failed to change app icon: $e');
}
```

### Reset to default icon

```dart
try {
  await dynamicIcon.reset();
  print('App icon reset to default');
} catch (e) {
  print('Failed to reset app icon: $e');
}
```

## Complete Example

```dart
import 'package:flutter/material.dart';
import 'package:dynamic_icon/dynamic_icon.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _dynamicIconPlugin = DynamicIcon();
  List<String>? icons;
  String? currentIcon;

  Future<void> _loadCurrentIcon() async {
    final icon = await _dynamicIconPlugin.getCurrentIcon();
    setState(() => currentIcon = icon);
  }

  @override
  void initState() {
    super.initState();
    _loadCurrentIcon();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Dynamic Icon'),
          centerTitle: true,
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Current Icon: ${currentIcon ?? "Default"}',
                        style: Theme.of(context).textTheme.titleMedium,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: () async {
                          final availableIcons = await _dynamicIconPlugin.getAvailableIcons();
                          setState(() => icons = availableIcons);
                          await _loadCurrentIcon();
                        },
                        icon: const Icon(Icons.refresh),
                        label: const Text('Load Available Icons'),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton.icon(
                        onPressed: () async {
                          await _dynamicIconPlugin.reset();
                          await _loadCurrentIcon();
                        },
                        icon: const Icon(Icons.restore),
                        label: const Text('Reset to Default Icon'),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              if (icons != null) ...[
                Text(
                  'Available Icons',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 3,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: icons!.length,
                    itemBuilder: (context, index) {
                      final iconName = icons![index];
                      final isSelected = iconName == currentIcon;
                      return ElevatedButton(
                        onPressed: () async {
                          await _dynamicIconPlugin.setIcon(iconName);
                          await _loadCurrentIcon();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isSelected 
                              ? Theme.of(context).colorScheme.primaryContainer
                              : null,
                        ),
                        child: Text(iconName),
                      );
                    },
                  ),
                ),
              ] else
                const Expanded(
                  child: Center(
                    child: Text('Press "Load Available Icons" to see options'),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
```

## Icon Requirements

### iOS
- The icons must be added to the app bundle and proper entries in Info.plist.
- Recommended sizes: 
  - iPhone: 60x60pt (@2x: 120x120px, @3x: 180x180px)
  - iPad: 76x76pt (@2x: 152x152px)
  - iPad Pro: 83.5x83.5pt (@2x: 167x167px)
- Ensure you provide all required sizes in Xcode's App Icon asset catalog
- Icons should be in PNG format with a transparent background
- Follow [Apple's Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines/app-icons) for icon design

### Android
- Icons should be provided as mipmap resources in your project:
  - mipmap-mdpi: 48x48px
  - mipmap-hdpi: 72x72px
  - mipmap-xhdpi: 96x96px
  - mipmap-xxhdpi: 144x144px
  - mipmap-xxxhdpi: 192x192px
- For Android 8.0 (API level 26) and higher, consider using [Adaptive Icons](https://developer.android.com/guide/practices/ui_guidelines/icon_design_adaptive)
  - Provide both foreground and background layers
  - Use the appropriate drawable-v26 folders
- For older Android versions, use traditional PNG icons
- Follow [Google's Material Design guidelines](https://m3.material.io/styles/icons/overview) for icon design

## Creating Icons

### Tools for Creating App Icons
- [Icon Kitchen](https://icon.kitchen/) - Free online tool for creating app icons
- [App Icon Generator](https://appicon.co/) - Generate icons for all required sizes
- [Adobe Express](https://www.adobe.com/express/create/icon) - Create professional app icons
- [Figma](https://www.figma.com/) - Design your icons and export in various sizes
- [Sketch](https://www.sketch.com/) - Popular tool for icon design on macOS

### Best Practices
- Keep your icon designs simple and recognizable
- Test your icons on different backgrounds and device themes
- Ensure sufficient contrast for visibility
- Consider using a consistent theme across your alternative icons
- For seasonal or promotional icons, maintain brand recognition

## Limitations

- On iOS, the icon change may not be immediate. The system handles the timing of the change.
- On Android, the icon change requires activity aliases and might not work on all devices.
- The app may briefly disappear from the launcher during icon changes on some devices.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Author

- **Name:** HauTV
- **Google Play Store:** [Developer Profile](https://play.google.com/store/apps/dev?id=5934859685596356830)
- **LinkedIn:** [https://www.linkedin.com/in/hautv/](https://www.linkedin.com/in/hautv/)

