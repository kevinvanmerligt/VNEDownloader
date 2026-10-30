package com.vnedownloader.vnedownloader

import android.os.Build
import android.os.Bundle
import android.view.Display
import io.flutter.embedding.android.FlutterActivity

class MainActivity : FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        enableHighRefreshRate()
    }

    override fun onResume() {
        super.onResume()
        enableHighRefreshRate()
    }

    /**
     * Unlocks maximum available refresh rates (60Hz, 90Hz, 120Hz, 144Hz)
     * on compatible modern Android displays for ultra-smooth UI animations.
     */
    private fun enableHighRefreshRate() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            try {
                val currentWindow = window ?: return
                val currentDisplay = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
                    display
                } else {
                    @Suppress("DEPRECATION")
                    currentWindow.windowManager.defaultDisplay
                } ?: return

                val modes = currentDisplay.supportedModes ?: return
                var maxRateMode: Display.Mode? = null
                var maxRate = 60f

                for (mode in modes) {
                    if (mode.refreshRate > maxRate) {
                        maxRate = mode.refreshRate
                        maxRateMode = mode
                    }
                }

                if (maxRateMode != null) {
                    val params = currentWindow.attributes
                    params.preferredDisplayModeId = maxRateMode.modeId
                    currentWindow.attributes = params
                }
            } catch (_: Exception) {
                // Graceful fallback to default system refresh rate
            }
        }
    }
}
