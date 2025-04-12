/// A Flutter plugin for dynamically changing your app's icon on iOS and Android.
///
/// This plugin allows you to:
/// - Change your app icon at runtime to any of your predefined alternative icons
/// - Get the current active icon
/// - Get a list of all available alternative icons
/// - Reset to the default app icon
import 'dynamic_icon_platform_interface.dart';

/// The main entry point for the Dynamic Icon plugin.
///
/// Use this class to interact with app icon functionality on iOS and Android.
class DynamicIcon {
  /// Changes the app icon to the specified alternative icon.
  ///
  /// [iconName] must be one of the pre-configured alternative icons.
  /// - For iOS, the icon must be added to the app bundle with proper entries in Info.plist.
  /// - For Android, the icon must be added as a mipmap resource and configured as an activity-alias.
  ///
  /// Throws a [PlatformException] if the icon change fails.
  ///
  /// Example:
  /// ```dart
  /// try {
  ///   await DynamicIcon().setIcon('christmas_icon');
  ///   print('App icon changed successfully');
  /// } catch (e) {
  ///   print('Failed to change app icon: $e');
  /// }
  /// ```
  Future<void> setIcon(String iconName) {
    return DynamicIconPlatform.instance.changeIcon(iconName);
  }

  /// Gets the name of the currently active app icon.
  ///
  /// Returns the name of the current icon, or `null` if using the default icon.
  ///
  /// Example:
  /// ```dart
  /// String? currentIcon = await DynamicIcon().getCurrentIcon();
  /// print('Current icon: ${currentIcon ?? 'Default'}');
  /// ```
  Future<String?> getCurrentIcon() {
    return DynamicIconPlatform.instance.getCurrentIcon();
  }

  /// Gets a list of all available alternative icons.
  ///
  /// Returns a list of icon names that can be used with [setIcon].
  /// This list does not include the default icon.
  ///
  /// Example:
  /// ```dart
  /// List<String>? icons = await DynamicIcon().getAvailableIcons();
  /// print('Available icons: $icons');
  /// ```
  Future<List<String>?> getAvailableIcons() {
    return DynamicIconPlatform.instance.getAvailableIcons();
  }

  /// Resets the app icon to the default icon.
  ///
  /// This restores the original app icon that was set when the app was installed.
  ///
  /// Example:
  /// ```dart
  /// await DynamicIcon().reset();
  /// print('App icon reset to default');
  /// ```
  Future<void> reset() {
    return DynamicIconPlatform.instance.reset();
  }
}
