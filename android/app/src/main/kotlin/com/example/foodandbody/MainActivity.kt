package com.example.foodandbody

import android.view.View
import android.widget.Toast
import com.google.ar.core.ArCoreApk
import com.google.ar.core.exceptions.UnavailableException
import io.flutter.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.platform.PlatformView

class MainActivity: FlutterActivity() {
    private val CHANNEL = "ar.core.platform"
    private var isSupported = false
//    private lateinit var cameraView: CameraView

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        flutterEngine.platformViewsController.registry.registerViewFactory("ar.core.platform", CameraViewFactory(activity, flutterEngine.dartExecutor))
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method.equals("isARCoreSupported")) {
                isSupported = isARCoreSupportedAndUpToDate()
                Log.d("isARCoreSupported" ,"" + isSupported)
                result.success(isSupported)
            }}
//            else if (call.method.equals("createSession")) {
//                if (isSupported) {
//                    try {
//                        getCameraView().createSession()
//                    } catch (e: Exception) {
//                        Log.d("ARCore:" ,"creating session failure")
//                        result.success(false)
//                    }
//                    Log.d("ARCore:" ,"creating session completed")
//                    result.success(true)
//                }
//            }
//            else if (call.method.equals("openCamera")) {
//                try {
////                    getCameraView().openCamera()
//                } catch (e: Exception) {
//                    result.success(false)
//                }
//                result.success(true)
//            }
//            else if (call.method.equals(("closeSession"))) {
////                session!!.close()
//                result.success(true)
//            }
//            else {
//                result.notImplemented()
//            }
        }
//    }

//    private fun getCameraView(): CameraView {
//        return cameraView
//    }
//
    private fun isARCoreSupportedAndUpToDate(): Boolean {
        return when (ArCoreApk.getInstance().checkAvailability(this)) {
            ArCoreApk.Availability.SUPPORTED_INSTALLED -> true
            ArCoreApk.Availability.SUPPORTED_APK_TOO_OLD, ArCoreApk.Availability.SUPPORTED_NOT_INSTALLED -> {
                try {
                    when (ArCoreApk.getInstance().requestInstall(this, true)) {
                        ArCoreApk.InstallStatus.INSTALL_REQUESTED -> {
                            Log.d("ARCore:", "ARCore installation requested.")
                            false
                        }
                        ArCoreApk.InstallStatus.INSTALLED -> true
                    }
                } catch (e: UnavailableException) {
                    Log.d("ARCore:", "ARCore not installed", e)
                    false
                }
            }
            ArCoreApk.Availability.UNSUPPORTED_DEVICE_NOT_CAPABLE -> false
            ArCoreApk.Availability.UNKNOWN_CHECKING, ArCoreApk.Availability.UNKNOWN_ERROR, ArCoreApk.Availability.UNKNOWN_TIMED_OUT -> false
        }
    }
//
    override fun onRequestPermissionsResult(requestCode: Int, permissions: Array<out String>, grantResults: IntArray) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        if (!CameraPermissionHelper.hasCameraPermission(this)) {
            Toast.makeText(this, "Camera permission is needed to run this application", Toast.LENGTH_LONG).show()
            if (!CameraPermissionHelper.shouldShowRequestPermissionRationale(this)) {
                // Permission denied with checking "Do not ask again".
                CameraPermissionHelper.launchPermissionSettings(this)
            }
            finish()
        }
    }

//    override fun getView(): View {
//        return getCameraView().view
//    }
//
//    override fun dispose() {
//        return getCameraView().dispose()
//    }
}
