import 'package:app/constants/app_theme.dart';
import 'package:app/constants/images.dart';
import 'package:app/constants/strings.dart';
import 'package:app/entry/routes.dart';
import 'package:app/repository/channel_react.dart';
import 'package:app/repository/constant/local_cache_keys.dart';
import 'package:app/repository/local_repo.dart';
import 'package:app/utils/screen_adapter.dart';
import 'package:app/vmodel/user_info_vmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

// todo dot过渡动画
class MySwiperPaginationBuilder extends SwiperPlugin {
  final Key key;
  const MySwiperPaginationBuilder({this.key});

  @override
  Widget build(BuildContext context, SwiperPluginConfig config) {
    List<Widget> list = [];

    int itemCount = config.itemCount;
    int activeIndex = config.activeIndex;

    for (int i = 0; i < itemCount; ++i) {
      bool active = i == activeIndex;
      list.add(
        Container(
          margin: EdgeInsets.all(4.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4.0),
            child: AnimatedContainer(
              duration: Duration(milliseconds: 200),
              color: active
                  ? const Color(0xFFF24C5A)
                  : const Color.fromRGBO(153, 153, 153, 0.5),
              width: active ? 20.0 : 8.0,
              height: 8.0,
            ),
          ),
        ),
      );
    }

    return Row(
      key: key,
      mainAxisSize: MainAxisSize.min,
      children: list,
    );
  }
}

class BootScreen extends StatefulWidget {
  BootScreen();
  @override
  _BootScreenState createState() => _BootScreenState();
}

class _BootScreenState extends State<BootScreen> {
  @override
  void initState() {
    super.initState();
    _redirect();
  }

  void _redirect() async {
    // 如果是已经登录了就重定向到home页
    SharedPreferences prefs = await LocalRepo.inst.prefs;
    if (prefs.getBool(LocalCacheKeys.isLoggedIn) ?? false) {
      Provider.of<UserInfoVModel>(context).getBasicInfo();
      Navigator.of(context).pushReplacementNamed(Routes.home);
    }
  }

  void _login() {
    Navigator.of(context).pushNamed(Routes.login);
  }

  void _tempNotLogin() {
    // todo 暂不登录，跳到哪里
    Navigator.of(context).pushNamed(Routes.home);
  }

  Widget _swiperBuilder(BuildContext context, int index) {
    return new Image(
      alignment: Alignment.topCenter,
      fit: BoxFit.contain,
      width: double.infinity,
      image: new AssetImage(
        Images.boot_banner[index],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height - ScreenAdapter.height(120.0),
              child: Swiper(
                itemBuilder: _swiperBuilder,
                itemCount: 2,
                pagination: new SwiperPagination(
                  alignment: Alignment.bottomCenter,
                  margin: const EdgeInsets.only(bottom: 20.0),
                  builder: MySwiperPaginationBuilder(),
                ),
                scrollDirection: Axis.horizontal,
                autoplay: true,
              ),
            ),
            new MaterialButton(
              child: new Text(
                Strings.login_btn_sign_in,
                style: new TextStyle(
                  color: AppColors.white,
                  fontSize: ScreenAdapter.fontSize(17.0),
                ),
              ),
              minWidth: ScreenAdapter.width(300.0),
              height: ScreenAdapter.height(44.0),
              shape: RoundedRectangleBorder(
                side: BorderSide.none,
                borderRadius: BorderRadius.all(
                  Radius.circular(22.0),
                ),
              ),
              color: AppColors.primaryRed,
              onPressed: _login,
            ),
//            new FlatButton(
//              child: new Text(
//                Strings.login_btn_temp_not_sign_in,
//                style: new TextStyle(
//                  color: AppColors.black666,
//                  fontSize: ScreenAdapter.fontSize(14.0),
//                ),
//              ),
//              onPressed: _tempNotLogin,
//            )
          ],
        ),
      )
    );
  }
}
