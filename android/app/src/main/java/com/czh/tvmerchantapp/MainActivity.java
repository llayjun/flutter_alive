package com.czh.tvmerchantapp;

import android.os.Bundle;

import com.czh.tvmerchantapp.live.AlilivePlugin;

import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    GeneratedPluginRegistrant.registerWith(this);
    registerAlivePlugin(this);
  }

  void registerAlivePlugin(PluginRegistry registrar) {
        // 注册调用原生阿里直播
        AlilivePlugin.registerWith(registrar.registrarFor(AlilivePlugin.CHANNEL));
    }

}
