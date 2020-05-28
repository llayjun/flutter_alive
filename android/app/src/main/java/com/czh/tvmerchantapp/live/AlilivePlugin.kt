package com.czh.tvmerchantapp.live

import android.content.Context
import android.content.Intent
import android.os.Build
import com.czh.tvmerchantapp.base.Api
import com.czh.tvmerchantapp.base.Constant
import com.czh.tvmerchantapp.live.pull.PlayActivity
import com.czh.tvmerchantapp.live.push.java.activity.ALiveActivity
import com.czh.tvmerchantapp.live.push.java.activity.MyAliveActivity
import com.czh.tvmerchantapp.net.FuelNetHelper
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.PluginRegistry.Registrar

/** AlilivePlugin */
public class AlilivePlugin : FlutterPlugin, MethodCallHandler {

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        val channel = MethodChannel(flutterPluginBinding.flutterEngine.dartExecutor, CHANNEL)
        context = flutterPluginBinding.applicationContext
        channel.setMethodCallHandler(AlilivePlugin())
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        methodResult = result
        when (call.method) {
            "getPlatformVersion" -> result.success("Android版本" + Build.VERSION.RELEASE)
            "jumpToBoard" -> {
                val token = call.argument<String>("token")
                Constant.token = token
                val id = call.argument<String>("id")
                val intent = Intent(context, ALiveActivity::class.java)
                intent.putExtra(ALiveActivity.ID_KEY, id)
                intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                context!!.startActivity(intent)
            }
            "jumpToLivePlay" -> {
                val boastUrl = call.arguments.toString()
                val intentBoast = Intent(context, PlayActivity::class.java)
                intentBoast.putExtra(PlayActivity.LIVE_URL_KEY, boastUrl)
                intentBoast.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                context!!.startActivity(intentBoast)
            }
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {}

    companion object {
        @JvmField
        val CHANNEL = "com.czh.tvmerchantapp/plugin"

        @JvmField
        val SHARE_CHANNEL = "com.czh.tvmerchantapp/shareplugin"

        @JvmField
        var context: Context? = null

        @JvmField
        var sharedEvents: EventChannel.EventSink? = null
        
        @JvmField
        var methodResult: MethodChannel.Result? = null

        @JvmStatic
        fun registerWith(registrar: Registrar) {
            val channel = MethodChannel(registrar.messenger(), CHANNEL)
            context = registrar.context()
            channel.setMethodCallHandler(AlilivePlugin())
            // 获取apiUrl
            channel.invokeMethod("getUrl", "", object :  MethodChannel.Result {
                override fun notImplemented() {
                }

                override fun error(errorCode: String?, errorMessage: String?, errorDetails: Any?) {
                }

                override fun success(result: Any?) {
                    println("apiUrl + ${result.toString()}")
                    Api.BASE_URL = result.toString()
                    FuelNetHelper.initFuel()
                }
            })
            var sharedChannel = EventChannel(registrar.messenger(), SHARE_CHANNEL)
            sharedChannel.setStreamHandler(object : EventChannel.StreamHandler{
                override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                    sharedEvents = events
                }

                override fun onCancel(arguments: Any?) {
                    
                }
            })
        }
    }
}
