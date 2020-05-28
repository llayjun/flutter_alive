package com.czh.tvmerchantapp

import com.blankj.utilcode.util.Utils
import com.czh.tvmerchantapp.base.Api
import com.umeng.analytics.MobclickAgent
import com.umeng.commonsdk.UMConfigure
import io.flutter.app.FlutterApplication
import io.socket.client.IO
import io.socket.client.Socket
import io.socket.engineio.client.transports.WebSocket

class MyFlutterApplication : FlutterApplication() {

    private var mSocket: Socket? = null

    override fun onCreate() {
        super.onCreate()
        Utils.init(this)
        // 初始化SDK
        UMConfigure.init(this, "5e8a899d570df3db4a000024", "Umeng", UMConfigure.DEVICE_TYPE_PHONE, null)
        // 打开统计SDK调试模式
        UMConfigure.setLogEnabled(BuildConfig.DEBUG)
        // 选用AUTO页面采集模式
        MobclickAgent.setPageCollectionMode(MobclickAgent.PageMode.AUTO);
        val options = IO.Options()
        options.transports = arrayOf(WebSocket.NAME)
        mSocket = IO.socket(Api.SOCKET_URL, options)
    }

    fun getSocket(): Socket? {
        return mSocket
    }
}