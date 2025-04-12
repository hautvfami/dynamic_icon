import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'dynamic_icon_platform_interface.dart';

/// An implementation of [DynamicIconPlatform] that uses method channels.
class MethodChannelDynamicIcon extends DynamicIconPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('dynamic_icon');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<void> changeIcon(String iconName) async {
    try {
      await methodChannel.invokeMethod('changeIcon', {'iconName': iconName});
    } on PlatformException catch (e) {
      debugPrint('Failed to set icon: ${e.message}');
    }
  }

  @override
  Future<String?> getCurrentIcon() async {
    try {
      final currentIcon = await methodChannel.invokeMethod<String>('getCurrentIcon');
      return currentIcon;
    } on PlatformException catch (e) {
      debugPrint('Failed to get current icon: ${e.message}');
      return null;
    }
  }

  @override
  Future<List<String>?> getAvailableIcons() async {
    try {
      final icons = await methodChannel.invokeMethod<List>('getAvailableIcons');
      print('Available icons: ${icons}');
      return icons?.map((e)=> e.toString()).toList();
    } on PlatformException catch (e) {
      debugPrint('Failed to get available icons: ${e.message}');
      return null;
    }
  }
}
