package org.velvetpulse.app

import android.content.ComponentName
import android.content.Intent
import android.content.pm.PackageManager
import android.os.PowerManager
import android.view.WindowManager
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

// FlutterFragmentActivity wird von local_auth (Fingerabdruck) benötigt.
class MainActivity : FlutterFragmentActivity() {
    // Hält die CPU bei ausgeschaltetem Bildschirm wach, solange eine lange Wiedergabe läuft (lib/services/wach_halten.dart).
    private var wachSperre: PowerManager.WakeLock? = null
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
        // Teil-Wachhaltesperre für lange Wiedergaben (Audioreihe, Reisen): ohne sie bleibt der Takt bei ausgeschaltetem
        // Bildschirm stehen, und die nächste Szene beginnt zu spät. Endet nach vier Stunden von selbst.
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "velvetpulse/wach")
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "halten" -> {
                        val pm = getSystemService(POWER_SERVICE) as PowerManager
                        wachSperre?.let { if (it.isHeld) it.release() }
                        wachSperre = pm.newWakeLock(PowerManager.PARTIAL_WAKE_LOCK, "velvetpulse:wiedergabe").apply {
                            setReferenceCounted(false)
                            acquire(4 * 60 * 60 * 1000L)
                        }
                        result.success(null)
                    }
                    "freigeben" -> {
                        wachSperre?.let { if (it.isHeld) it.release() }
                        wachSperre = null
                        result.success(null)
                    }
                    else -> result.notImplemented()
                }
            }        // Öffnet das Android-Teilen-Menü (Messenger, Mail …) mit einem fertigen Text.
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "velvetpulse/share")
            .setMethodCallHandler { call, result ->
                if (call.method == "shareText") {
                    val send = Intent(Intent.ACTION_SEND).apply {
                        type = "text/plain"
                        putExtra(Intent.EXTRA_TEXT, call.argument<String>("text"))
                        putExtra(Intent.EXTRA_SUBJECT, call.argument<String>("subject"))
                    }
                    startActivity(Intent.createChooser(send, call.argument<String>("subject")))
                    result.success(null)
                } else {
                    result.notImplemented()
                }
            }
    }

    override fun onDestroy() {
        wachSperre?.let { if (it.isHeld) it.release() }
        wachSperre = null
        super.onDestroy()
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
