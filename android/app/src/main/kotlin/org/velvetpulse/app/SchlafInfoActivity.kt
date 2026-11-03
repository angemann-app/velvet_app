package org.velvetpulse.app

import io.flutter.embedding.android.FlutterFragmentActivity

/** Öffentlich aufrufbare Begründung enthält keine persönlichen Daten. */
class SchlafInfoActivity : FlutterFragmentActivity() {
    override fun getInitialRoute(): String = "/schlafdaten-info"
}
