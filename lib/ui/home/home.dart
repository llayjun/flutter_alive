import 'dart:io';
import 'dart:math';

import 'package:app/constants/app_theme.dart';
import 'package:app/constants/images.dart';
import 'package:app/entry/config.dart';
import 'package:app/entry/routes.dart';
import 'package:app/services/sys_service.dart';
import 'package:app/ui/live/create.dart';
import 'package:app/utils/custom_toast.dart';
import 'package:app/utils/screen_adapter.dart';
import 'package:app/vmodel/user_info_vmodel.dart';
import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'mine.dart';
import 'release.dart';

enum PlatformType {
  ANDROID,
  IOS,
}

enum Stage {
  TEST,
  PRODUCTION,
}

class HomeScreen extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  PageController _pageController;
  List<Widget> pages = List<Widget>();
  SysService _sysService = SysService();
  DateTime lastPopTime;

  @override
  void initState() {
    super.initState();
    pages..add(Release())..add(Container())..add(Mine());
    _pageController = PageController();
    _initgetLastVersion();
  }

  void _initgetLastVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    _sysService
        .getLastVersion(
            Platform.isAndroid ? PlatformType.ANDROID : PlatformType.IOS,
            Stage.PRODUCTION)
        .then((value) {
      print('!!!!!!!!!!!!!!!!!! ${value}');
      if (TextUtil.isEmpty(value)) return;
      print("currentVersionName${packageInfo.version}");
      print("ServiceVersionName${value.toString()}");
      if (value.compareTo(packageInfo.version) == 1) {
        Future.delayed(Duration.zero, () {
          showDialog(
              context: context,
              barrierDismissible: true,
              builder: (_) {
                return Center(
                  child: Container(
                    height: ScreenAdapter.height(150.0),
                    width: ScreenAdapter.width(250.0),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Column(
                      children: <Widget>[
                        Container(
                          alignment: Alignment.center,
                          height: ScreenAdapter.height(40),
                          child: Text(
                            "版本更新",
                            style: TextStyle(
                              fontSize: ScreenAdapter.fontSize(18.0),
                              color: AppColors.black43,
                              fontWeight: FontWeight.normal,
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.all(ScreenAdapter.width(20)),
                            child: Center(
                              child: Text(
                                "更新到最新版本${"V" + value}",
                                style: TextStyle(
                                  fontSize: ScreenAdapter.fontSize(16.0),
                                  color: AppColors.black43,
                                  fontWeight: FontWeight.normal,
                                  decoration: TextDecoration.none,
                                ),
                              ),
                            ),
                          ),
                        ),

                        Divider(
                          color: AppColors.Color_F0F0F0,
                          height: 1,
                        ),

                        Container(
                          height: ScreenAdapter.height(40),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                  child: Center(
                                      child: GestureDetector(
                                child: Text(
                                  "取消",
                                  style: TextStyle(
                                    fontSize: ScreenAdapter.fontSize(15.0),
                                    color: AppColors.black666,
                                    fontWeight: FontWeight.normal,
                                    decoration: TextDecoration.none,
                                  ),
                                ),
                                onTap: () {
                                  Navigator.pop(context);
                                },
                              ))),
                              Container(
                                color: AppColors.Color_F0F0F0,
                                width: 1,
                              ),
                              Expanded(
                                  child: Center(
                                      child: GestureDetector(
                                child: Text(
                                  "确定",
                                  style: TextStyle(
                                    fontSize: ScreenAdapter.fontSize(15.0),
                                    color: AppColors.Color_F9515A,
                                    fontWeight: FontWeight.normal,
                                    decoration: TextDecoration.none,
                                  ),
                                ),
                                onTap: () {
                                  if(Platform.isIOS) {

                                  }else {
                                    launch(Config.inst.apiUrl +
                                        '/platform/app/android');
                                  }

                                  Navigator.pop(context);
                                },
                              ))),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
              });
        });
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  double get textSize {
    return ScreenAdapter.fontSize(11.0);
  }

  BottomNavigationBarItem _buildBarItem(
      String _text, String _icon, String _activeIcon,
      {int tag}) {
    if (tag == 1) {
      return BottomNavigationBarItem(
        icon: Container(
          width: ScreenAdapter.width(27.0),
          height: ScreenAdapter.height(20.0),
          child: Text(''),
        ),
        title: Padding(
          padding: EdgeInsets.only(
            top: ScreenAdapter.height(4.0),
          ),
          child: Text(
            _text,
            style: TextStyle(
              inherit: false,
              color: AppColors.black666,
              fontSize: textSize,
            ),
          ),
        ),
      );
    } else {
      return BottomNavigationBarItem(
        icon: Image.asset(
          _icon,
          width: ScreenAdapter.width(27.0),
          height: ScreenAdapter.height(20.0),
        ),
        activeIcon: Image.asset(
          _activeIcon,
          width: ScreenAdapter.width(27.0),
          height: ScreenAdapter.height(20.0),
        ),
        title: Padding(
          padding: EdgeInsets.only(
            top: ScreenAdapter.height(4.0),
          ),
          child: Text(
            _text,
            style: TextStyle(
              inherit: false,
              color: AppColors.black666,
              fontSize: textSize,
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: AppColors.white,
            type: BottomNavigationBarType.fixed,
            selectedFontSize: textSize,
            unselectedFontSize: textSize,
            items: [
              _buildBarItem(
                  '找货', Images.icon_home_home_red, Images.icon_home_home_black),
              _buildBarItem('创建直播', '', '', tag: 1),
              _buildBarItem(
                  '我的', Images.icon_home_mine_red, Images.icon_home_mine_black),
            ],
            currentIndex: _currentIndex,
            onTap: (int index) {
              if (index == 1) {
                Provider.of<UserInfoVModel>(context).checkBeginBroadcast().then((value) {
                  if(value.success) {
                    Navigator.of(context).pushNamed(Routes.live_create);
                  } else {
                    Navigator.of(context).pushNamed(Routes.live_create_close, arguments: {'message': value.message});
                  }
                });
              } else {
                setState(() {
                  _currentIndex = index == 2 ? 2 : 0;
                });
                _pageController.jumpToPage(index == 2 ? 2 : 0);
              }
            },
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: AppColors.white,
            elevation: 0,
            highlightElevation: 0,
            onPressed: () {
              Provider.of<UserInfoVModel>(context).checkBeginBroadcast().then((value) {
                if(value.success) {
                  Navigator.of(context).pushNamed(Routes.live_create);
                } else {
                  Navigator.of(context).pushNamed(Routes.live_create_close, arguments: {'message': value.message});
                }
              });
            },
            child: DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.white,
              ),
              child: SizedBox(
                  height: 48,
                  width: 48,
                  child: Image.asset(Images.icon_home_createlive)),
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
          body: PageView.builder(
            physics: NeverScrollableScrollPhysics(),
            controller: _pageController,
            onPageChanged: (int index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemCount: pages.length,
            itemBuilder: (context, index) => pages[index],
          ),
        ),
        onWillPop: _doubleExit);
  }

  Future<bool> _doubleExit() async {
    // 点击返回键的操作
    if(lastPopTime == null || DateTime.now().difference(lastPopTime) > Duration(seconds: 2)){
      lastPopTime = DateTime.now();
      CustomToast.showToast(msg: "再按一次退出", gravity: ToastGravity.CENTER);
      return new Future.value(false);
    }else{
      lastPopTime = DateTime.now();
      // 退出app
      await SystemChannels.platform.invokeMethod('SystemNavigator.pop');
      exit(0);
      return new Future.value(true);
    }
  }

}
