package hautv.fami.dynamic_icon

import android.content.ComponentName
import android.content.Context
import android.content.pm.PackageManager
import androidx.annotation.NonNull

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** DynamicIconPlugin */
class DynamicIconPlugin : FlutterPlugin, MethodCallHandler {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel
    private lateinit var context: Context

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "dynamic_icon")
        channel.setMethodCallHandler(this)
//    context = binding.applicationContext
        context = flutterPluginBinding.applicationContext
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            "changeIcon" -> {
                val iconName = call.argument<String>("iconName") ?: ""
                changeIcon(iconName, result)
            }

            "getCurrentIcon" -> result.success(getCurrentAlias())
            "getAvailableIcons" -> result.success(getAliasList())
            else -> result.notImplemented()
        }
    }

    //
    private fun getAliasList(): List<String> {
        val pm = context.packageManager
        val pkg = context.packageName
        val aliases = mutableListOf<String>()
        try {
            val packageInfo = pm.getPackageInfo(
                pkg,
                PackageManager.GET_ACTIVITIES or PackageManager.GET_DISABLED_COMPONENTS
            )
            for (activity in packageInfo.activities) {
                if (activity.name.startsWith("$pkg.")) {
                    aliases.add(activity.name.removePrefix("$pkg."))
                }
            }
        } catch (e: Exception) {
            e.printStackTrace()
        }
        return aliases
    }

    private fun getCurrentAlias(): String? {
        val pm = context.packageManager
        val pkg = context.packageName
        val aliases = getAliasList()
        for (alias in aliases) {
            val state = pm.getComponentEnabledSetting(ComponentName(pkg, "$pkg.$alias"))
            if (state == PackageManager.COMPONENT_ENABLED_STATE_ENABLED) {
                return alias
            }
        }
        return null
    }

    private fun changeIcon(alias: String, result: MethodChannel.Result) {
        val pm = context.packageManager
        val pkg = context.packageName
        val current = getCurrentAlias()
        val aliases = getAliasList()

        if (!aliases.contains(alias)) {
            result.error("INVALID_ICON", "Alias $alias not found in manifest", null)
            return
        }

        aliases.forEach {
            val state = if (it == alias) PackageManager.COMPONENT_ENABLED_STATE_ENABLED
            else PackageManager.COMPONENT_ENABLED_STATE_DISABLED
            pm.setComponentEnabledSetting(
                ComponentName(pkg, "$pkg.$it"),
                state,
                PackageManager.DONT_KILL_APP
            )
        }

        result.success(true)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }
}
