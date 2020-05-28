import 'package:app/entry/app.dart';
import 'package:app/entry/config.dart';
import 'package:app/utils/log.dart';
import 'package:app/utils/sp_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:package_info/package_info.dart';

Future<void> main() async {
  Config.fill(
      dbName: "tv",

      /// 施本地
//      apiUrl:'http://192.168.1.4:8080',
      /// 曹本地
//      apiUrl: 'http://192.168.1.149:8080',
      /// 珍珍本地
      //      webUrl: 'http://fxstore.9daye.cn',

      /// 测试地址
      apiUrl: 'http://tv.api.9daye.cn',
      webUrl: 'http://fxstore.9daye.cn',
      socketUrl: 'https://chat.9daye.cn',

      /// 正式地址
//      apiUrl: 'http://tv.api.9daye.com.cn',
//      webUrl: 'http://fxstore.9daye.com.cn',
//      socketUrl: 'https://chat.9daye.com.cn' ,

      logLevel: LogLevel.debug,
      appId: "wxfd04e16c3e6972d7",
      miniUsername: "gh_4f1a63282616",

      /// 小程序的ID
      ndymallUrlString: "ndymall://",
      ndymallIOSAppId: 1441399208,
      ndymallAndPackageName: "com.czh.ndymall");

  WidgetsFlutterBinding.ensureInitialized();
  await SpUtil.getInstance();
  start();
}
