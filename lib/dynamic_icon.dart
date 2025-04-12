import 'dynamic_icon_platform_interface.dart';

class DynamicIcon {

  Future<void> setIcon(String iconName) {
    return DynamicIconPlatform.instance.changeIcon(iconName);
  }

  Future<String?> getCurrentIcon() {
    return DynamicIconPlatform.instance.getCurrentIcon();
  }

  Future<List<String>?> getAvailableIcons() {
    return DynamicIconPlatform.instance.getAvailableIcons();
  }
}
