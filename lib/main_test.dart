import 'package:app/entry/app.dart';
import 'package:app/entry/config.dart';
import 'package:app/utils/log.dart';
import 'package:flutter/cupertino.dart';

void main() {
  Config.fill(
    dbName: "tv",
    apiUrl: 'http://tvp.api.9daye.cn',
//    apiUrl: "http://192.168.1.149:8080",
//    apiUrl: "https://tv.test.9daye.cn",
//    webUrl: 'http://fxstorep.9daye.cn',
    webUrl: 'http://fxstore.9daye.cn',
    logLevel: LogLevel.info,
    appId: "wxd930ea5d5a258f4f",
    miniUsername: "gh_4f1a63282616",
  );
  WidgetsFlutterBinding.ensureInitialized();
  start();
}
