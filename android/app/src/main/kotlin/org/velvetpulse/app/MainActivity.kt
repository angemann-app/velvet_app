package org.velvetpulse.app

import android.content.ComponentName
import android.content.pm.PackageManager
import android.view.WindowManager
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

// FlutterFragmentActivity wird von local_auth (Fingerabdruck) benötigt.
class MainActivity : FlutterFragmentActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "velvetpulse/privacy")
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    // Verbirgt Inhalte in der App-Übersicht und verhindert Screenshots.
                    "setSecure" -> {
                        if (call.arguments as Boolean) {
                            window.addFlags(WindowManager.LayoutParams.FLAG_SECURE)
                        } else {
                            window.clearFlags(WindowManager.LayoutParams.FLAG_SECURE)
                        }
                        result.success(null)
                    }
                    // Schaltet zwischen den Starter-Einträgen "VelvetPulse" und "Pulse" um.
                    "setDiscreetIcon" -> {
                        val discreet = call.arguments as Boolean
                        setLauncherEnabled("LauncherDefault", !discreet)
                        setLauncherEnabled("LauncherDiscreet", discreet)
                        result.success(null)
                    }
                    else -> result.notImplemented()
                }
            }
    }

    private fun setLauncherEnabled(alias: String, enabled: Boolean) {
        packageManager.setComponentEnabledSetting(
            ComponentName(this, "$packageName.$alias"),
            if (enabled) PackageManager.COMPONENT_ENABLED_STATE_ENABLED
            else PackageManager.COMPONENT_ENABLED_STATE_DISABLED,
            PackageManager.DONT_KILL_APP,
        )
    }
}
