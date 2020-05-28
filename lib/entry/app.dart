import 'dart:async';

import 'package:app/repository/constant/local_cache_keys.dart';
import 'package:app/repository/local_repo.dart';
import 'package:app/utils/custom_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:app/constants/app_theme.dart';
import 'package:app/constants/strings.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:app/utils/localizations/chinese_cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'routes.dart';
import 'providers.dart';
import 'package:fluwx_no_pay/fluwx_no_pay.dart' as fluwx;
import 'package:app/entry/config.dart';

start() {
  fluwx.registerWxApi(appId: Config.inst.appId);
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    DeviceOrientation.landscapeRight,
    DeviceOrientation.landscapeLeft,
  ]).then((_) async {
    runApp(MyApp());
  });
}

class MyApp extends StatefulWidget {
  MyApp() : super();

  @override
  _MyApp createState() => _MyApp();
}

class _MyApp extends State<MyApp> {
  var _authCheckFuture;
  bool _isLogin;

  @override
  void initState() {
    super.initState();
    _authCheckFuture = _authCheck();
  }

  Future<bool> _authCheck() async {
    SharedPreferences prefs = await LocalRepo.inst.prefs;
    return prefs.getBool(LocalCacheKeys.isLoggedIn) ?? false;
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
      ),
    );
    return _withProviders(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        title: Strings.appName,
        theme: themeData,
        // initialRoute: Routes.boot,
        onGenerateRoute: _onGenerateRoute,
        routes: const <String, WidgetBuilder>{},
        // home: BootScreen(),
        locale: const Locale('zh'),
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          DefaultCupertinoLocalizations.delegate,
          ChineseCupertinoLocalizations.delegate,
        ],
        supportedLocales: [
          const Locale('zh', 'CH'),
          const Locale('en', 'US'),
        ],
      ),
    );
  }

  Widget _withProviders(Widget child) {
    return MultiProvider(
      providers: providers,
      child: child,
    );
  }

  /// 构造路由守卫
  Route _onGenerateRoute(RouteSettings settings) {
    String _name = settings.name;
    Function _pageContentBuilder = Routes.routes[_name];

    if (_pageContentBuilder == null) {
      _name = Routes.boot;
    }
    _pageContentBuilder = Routes.routes[_name];
    _authCheck().then((result) {
      if (result != _isLogin) {
        _isLogin = result;
        _authCheckFuture = _authCheck();
      }
    });
    Widget _builder = FutureBuilder<bool>(
      future: _authCheckFuture,
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (Routes.whiteList.indexOf(_name) <= -1 && !snapshot.data) {
            CustomToast.showToast(msg: Strings.tips_plz_login, gravity: ToastGravity.CENTER);
            _name = Routes.login;
            return Routes.routes[_name](
              context,
            );
          }
          if (settings.arguments != null) {
            return _pageContentBuilder(
              context,
              arguments: settings.arguments,
            );
          } else {
            return _pageContentBuilder(
              context,
            );
          }
        }

        /// 当auth check还在进行中是渲染loading组件
        return Container(
          width: double.infinity,
          height: double.infinity,
          alignment: Alignment.center,
          color: AppColors.white,
          child: CircularProgressIndicator(),
        );
      },
    );
    return MaterialPageRoute(
      settings: RouteSettings(
        name: _name,
      ),
      builder: (context) => _builder,
    );
  }
}
