import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'dynamic_icon_method_channel.dart';

abstract class DynamicIconPlatform extends PlatformInterface {
  /// Constructs a DynamicIconPlatform.
  DynamicIconPlatform() : super(token: _token);

  static final Object _token = Object();

  static DynamicIconPlatform _instance = MethodChannelDynamicIcon();

  /// The default instance of [DynamicIconPlatform] to use.
  ///
  /// Defaults to [MethodChannelDynamicIcon].
  static DynamicIconPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [DynamicIconPlatform] when
  /// they register themselves.
  static set instance(DynamicIconPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<void> reset() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<void> changeIcon(String iconName) {
    throw UnimplementedError('setIcon() has not been implemented.');
  }

  // Kiểm tra icon hiện tại
  // final current = await DynamicAppIcon.getCurrentIcon();
  Future<String?> getCurrentIcon() {
    throw UnimplementedError('getCurrentIcon() has not been implemented.');
  }

  // Lấy danh sách alias sẵn có
  // final icons = await DynamicAppIcon.getAvailableIcons();
  Future<List<String>?> getAvailableIcons() {
    throw UnimplementedError('getAvailableIcons() has not been implemented.');
  }
}
