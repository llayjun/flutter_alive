
import 'package:app/constants/strings.dart';
import 'package:app/entry/config.dart';
import 'package:flutter/services.dart';

typedef GetBackValue = Future<void> Function(dynamic value);

class ChannelReact {

  static ChannelReact instance;
  static ChannelReact getInstance() {
    if (null == instance) instance = ChannelReact();
    return instance;
  }

  static const platform = const MethodChannel(Strings.react_channelname);

  /// flutter调用原生
  void jumpToBoast(String methodName, GetBackValue backValue,{dynamic param}) async{
    try {
      final result = await platform.invokeMethod(methodName, param);
      backValue(result);
    } on PlatformException catch (e) {
      print(e);
    }
  }

  /// 原生调用flutter，获取apiUrl
  Future<dynamic> getUrl(MethodCall methodCall) async {
    switch (methodCall.method) {
      case 'getUrl':
        return Config.inst.apiUrl;
    }
  }

}
