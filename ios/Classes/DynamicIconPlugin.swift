import Flutter
import UIKit

public class DynamicIconPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "dynamic_icon", binaryMessenger: registrar.messenger())
    let instance = DynamicIconPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getPlatformVersion":
      result("iOS " + UIDevice.current.systemVersion)
    case "changeIcon":
      guard let args = call.arguments as? [String: Any],
            let iconName = args["iconName"] as? String else {
        result(FlutterError(code: "INVALID_ARGUMENTS", message: "Missing or invalid arguments", details: nil))
        return
      }
      changeIcon(iconName: iconName, result: result)
    case "getCurrentIcon":
      getCurrentIcon(result: result)
    case "getAvailableIcons":
      getAvailableIcons(result: result)
    default:
      result(FlutterMethodNotImplemented)
    }
  }

   
  private func changeIcon(iconName: String, result: @escaping FlutterResult) {
    // Check if alternate icons are supported by the device
    if !UIApplication.shared.supportsAlternateIcons {
        result(FlutterError(code: "UNSUPPORTED", message: "This device doesn't support alternate icons", details: nil))
        return
    }
    
    // Add specific case for "default" icon
    let iconNameToSet: String? = (iconName == "default" || iconName == ".") ? nil : iconName
    
    // Debug information
    print("Attempting to change icon to: \(String(describing: iconNameToSet ?? "default"))")
    
    // Run on main thread to avoid sandboxing issues
    DispatchQueue.main.async {
        UIApplication.shared.setAlternateIconName(iconNameToSet) { error in
            if let error = error {
                print("Icon change failed with error: \(error.localizedDescription)")
                result(FlutterError(code: "ICON_CHANGE_FAILED", message: error.localizedDescription, details: nil))
            } else {
                print("Successfully changed app icon to: \(String(describing: iconNameToSet ?? "default"))")
                result(true)
            }
        }
    }
  }
  
  private func getCurrentIcon(result: @escaping FlutterResult) {
    if !UIApplication.shared.supportsAlternateIcons {
      result(FlutterError(code: "UNSUPPORTED", message: "This device doesn't support alternate icons", details: nil))
      return
    }
    
    // Return the current icon name or "default" if using the primary icon
    result(UIApplication.shared.alternateIconName ?? "default")
  }
  
  private func getAvailableIcons(result: @escaping FlutterResult) {
    if !UIApplication.shared.supportsAlternateIcons {
      result(FlutterError(code: "UNSUPPORTED", message: "This device doesn't support alternate icons", details: nil))
      return
    }
    
    // Get info dictionary from main bundle
    guard let infoDictionary = Bundle.main.infoDictionary,
          let alternateIcons = infoDictionary["CFBundleIcons~ipad"] as? [String: Any] ?? 
                              infoDictionary["CFBundleIcons"] as? [String: Any],
          let alternateIconsDict = alternateIcons["CFBundleAlternateIcons"] as? [String: Any] else {
      // Return just the default icon if no alternate icons are defined
      result(["default"])
      return
    }
    
    // Get all icon names and add "default" for the primary icon
    var iconNames = ["default"]
    iconNames.append(contentsOf: alternateIconsDict.keys)
    
    result(iconNames)
  }
}
