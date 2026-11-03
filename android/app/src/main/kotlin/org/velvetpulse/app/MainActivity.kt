package org.velvetpulse.app

import android.content.ComponentName
import android.content.Intent
import android.content.pm.PackageManager
import android.os.PowerManager
import android.os.Build
import android.view.WindowManager
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

// FlutterFragmentActivity wird von local_auth (Fingerabdruck) benötigt.
class MainActivity : FlutterFragmentActivity() {
    private var schlafBerechtigung: MethodChannel.Result? = null
    private val schlafAnfrage = 20963
    // Hält die CPU bei ausgeschaltetem Bildschirm wach, solange eine lange Wiedergabe läuft (lib/services/wach_halten.dart).
    private var wachSperre: PowerManager.WakeLock? = null
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "velvetpulse/schlafdaten")
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "status" -> result.success(mapOf("verfuegbar" to SchlafdatenLeser.verfuegbar(this),
                        "berechtigt" to (Build.VERSION.SDK_INT >= 34 && checkSelfPermission(SchlafdatenLeser.BERECHTIGUNG) == PackageManager.PERMISSION_GRANTED)))
                    "berechtigen" -> {
                        if (!SchlafdatenLeser.verfuegbar(this)) result.success(false)
                        else if (schlafBerechtigung != null) result.error("beschaeftigt", null, null)
                        else if (checkSelfPermission(SchlafdatenLeser.BERECHTIGUNG) == PackageManager.PERMISSION_GRANTED) result.success(true)
                        else {
                            schlafBerechtigung = result
                            try {
                                requestPermissions(arrayOf(SchlafdatenLeser.BERECHTIGUNG), schlafAnfrage)
                            } catch (e: Exception) {
                                schlafBerechtigung = null
                                result.error("berechtigung_fehlt", null, null)
                            }
                        }
                    }
                    "einstellungen" -> try {
                        SchlafdatenLeser.einstellungen(this); result.success(null)
                    } catch (e: Exception) { result.error("einstellungen", null, null) }
                    "lesen" -> {
                        val von = call.argument<Number>("startMs")?.toLong()
                        val bis = call.argument<Number>("endeMs")?.toLong()
                        if (von == null || bis == null) result.error("zeitraum", null, null)
                        else SchlafdatenLeser.lesen(this, von, bis, object : SchlafdatenLeser.Antwort {
                            override fun fertig(daten: MutableList<MutableMap<String, Any>>?) { result.success(daten) }
                            override fun fehler(code: String?) { result.error(code ?: "lesefehler", null, null) }
                        })
                    }
                    else -> result.notImplemented()
                }
            }
        val wiedergabe = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "velvetpulse/wiedergabe")
        WiedergabeService.steuerung = WiedergabeService.Steuerung { aktion ->
            runOnUiThread { wiedergabe.invokeMethod(aktion, null) }
        }
        wiedergabe.setMethodCallHandler { call, result ->
            if (call.method != "zustand") { result.notImplemented(); return@setMethodCallHandler }
            val aktiv = call.argument<Boolean>("aktiv") == true
            val intent = Intent(this, WiedergabeService::class.java)
            try {
            if (!aktiv) {
                stopService(intent)
            } else {
                intent.putExtra("spielt", call.argument<Boolean>("spielt") == true)
                for (feld in listOf("titel", "pause", "beenden")) intent.putExtra(feld, call.argument<String>(feld))
                intent.putExtra("position", call.argument<Number>("position")?.toLong() ?: 0L)
                if (Build.VERSION.SDK_INT >= 26) startForegroundService(intent) else startService(intent)
            }
            result.success(null)
            } catch (e: Exception) {
                result.error("wiedergabe_service", e.javaClass.simpleName, null)
            }
        }
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
        schlafBerechtigung?.error("abgebrochen", null, null)
        schlafBerechtigung = null
        WiedergabeService.steuerung = null
        stopService(Intent(this, WiedergabeService::class.java))
        wachSperre?.let { if (it.isHeld) it.release() }
        wachSperre = null
        super.onDestroy()
    }

    override fun onRequestPermissionsResult(requestCode: Int, permissions: Array<out String>, grantResults: IntArray) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        if (requestCode == schlafAnfrage) {
            schlafBerechtigung?.success(grantResults.isNotEmpty() && grantResults.all { it == PackageManager.PERMISSION_GRANTED })
            schlafBerechtigung = null
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
