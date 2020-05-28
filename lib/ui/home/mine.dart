import 'package:app/entry/config.dart';
import 'package:app/entry/routes.dart';
import 'package:app/constants/app_theme.dart';
import 'package:app/constants/images.dart';
import 'package:app/models/dto/user/site_broadcast_dto.dart';
import 'package:app/utils/custom_toast.dart';
import 'package:app/utils/install_apk.dart';
import 'package:app/utils/screen_adapter.dart';
import 'package:app/vmodel/user_info_vmodel.dart';
import 'package:app/widgets/layout/action_box_widget.dart';
import 'package:app/widgets/layout/action_row_widget.dart';
import 'package:app/widgets/basic/iconfont_widget.dart';
import 'package:app/widgets/overwrite/custom_app_bar_widget.dart';
import 'package:common_utils/common_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:fluwx_no_pay/fluwx_no_pay.dart' as fluwx;

class Mine extends StatefulWidget {
  Mine({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MineState();
}

class _MineState extends State<Mine> {
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  bool get _isLogin {
    return Provider.of<UserInfoVModel>(context).isLogin;
  }

  // 门店是否能够直播
  SiteBroadcastDTO _siteBroadcast;
  String _status;

  @override
  void initState() {
    super.initState();
    new Future.delayed(Duration.zero, () async {
      await Provider.of<UserInfoVModel>(context).getUserOtherInfo();
      _siteBroadcast = await Provider.of<UserInfoVModel>(context).checkBroadcast();
      if (_siteBroadcast == null) {
        _status = null;
      } else {
        _status = _siteBroadcast.type;
      }
      await Provider.of<UserInfoVModel>(context).getTotalMoney();
    });
  }

  void _onRefresh() async {
    await Provider.of<UserInfoVModel>(context).getTotalMoney();
    // 刷新门店是否能直播
    _siteBroadcast = await Provider.of<UserInfoVModel>(context).checkBroadcast();
    if (_siteBroadcast == null) {
      _status = null;
    } else {
      _status = _siteBroadcast.type;
    }
    setState(() {});
    // 刷新个人信息
    bool flag = await Provider.of<UserInfoVModel>(context).getUserOtherInfo(true);
    if (flag) {
      _refreshController.refreshCompleted();
    } else {
      _refreshController.refreshFailed();
    }
  }

  @override
  Widget build(BuildContext context) {
    final _dataInfo = Provider.of<UserInfoVModel>(context);

    final _refreshLoadingTextStyle = TextStyle(
      color: AppColors.grey,
      fontSize: ScreenAdapter.fontSize(12.0),
    );

    //  我的头部模块
    Widget _header = Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(
            ScreenAdapter.width(20.0),
          ),
          bottomRight: Radius.circular(
            ScreenAdapter.width(20.0),
          ),),
        color: AppColors.primaryRed,),
      padding: EdgeInsets.only(
        top: ScreenAdapter.height(38.0),
        bottom: ScreenAdapter.height(48.0),
        left: ScreenAdapter.width(13.0),
      ),
      child: GestureDetector(
        onTap: () {
          if (!_isLogin) {
            Navigator.of(context).pushNamed(Routes.login);
          }
        },
        child: Row(
          children: <Widget>[
            Container(
              width: ScreenAdapter.width(60.0),
              height: ScreenAdapter.width(60.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(
                    ScreenAdapter.width(30.0),
                  ),
                ),
                border: Border.all(
                  color: Colors.white,
                  width: ScreenAdapter.borderWidth(),
                ),
              ),
              child: ClipOval(
                child: Image(
                  fit: BoxFit.cover,
                  color: AppColors.pink,
                  colorBlendMode: BlendMode.dstATop,
                  image: _isLogin &&
                          _dataInfo.userInfo.headerImg != null &&
                          _dataInfo.userInfo.headerImg.isNotEmpty
                      ? NetworkImage(_dataInfo.userInfo.headerImg)
                      : AssetImage(Images.mine_head_portrait_default),
                ),
              ),
            ),
            SizedBox(
              width: ScreenAdapter.width(15.0),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        '${_isLogin ? _dataInfo.userInfo.shopName ?? '--' : '点击快速登录'}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: ScreenAdapter.fontSize(18.0),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: ScreenAdapter.height(5.0)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(children: <Widget>[
                        GestureDetector(
                          child: Text(
                            '直播 ${_dataInfo.liveTime}'.padRight(15),
                            style: TextStyle(
                              color: AppColors.greyF4,
                              fontSize: ScreenAdapter.fontSize(13.0),
                            ),
                          ),
                          onTap: () {
                            Navigator.of(context).pushNamed(Routes.live_list);
                          },
                        ),
                        GestureDetector(
                          child: Text(
                            '粉丝 ${_dataInfo.fans}',
                            style: TextStyle(
                              color: AppColors.greyF4,
                              fontSize: ScreenAdapter.fontSize(13.0),
                            ),
                          ),
                          onTap: () {
                            Navigator.of(context).pushNamed(Routes.fans);
                          },
                        ),
                      ],),
                      Visibility(
                        child: Padding(
                          padding: EdgeInsets.only(
                            right: ScreenAdapter.width(12.0),
                          ),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context)
                                  .pushNamed(Routes.personal_homepage);
                            },
                            child: Text(
                              '个人主页 >',
                              style: TextStyle(
                                color: AppColors.yellow,
                                fontSize: ScreenAdapter.fontSize(13.0),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        visible: _isLogin,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

    Widget _tipsBuild(type){
      switch(type){
        case 'INFO':
          return RichText(
              text: TextSpan(style: TextStyle(color: AppColors.Color_FC6737,
                  fontSize: ScreenAdapter.fontSize(12.0)),
                  children: [
                    TextSpan(text: "您有一个${_siteBroadcast?.msg??""}开始的直播，"),
                    TextSpan(
                        text: "立即查看 >>", recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.of(context).pushNamed(Routes.live_list);
                      }
                    ),
                  ]));
          break;
        case 'SITE':
          return Text("您的账号已停用直播功能，如有疑问，请联系官方管理人员", style: TextStyle(color: AppColors.Color_FC6737, fontSize: ScreenAdapter.fontSize(12.0)),);
          break;
        case 'LIVE':
          return Text("${_siteBroadcast?.msg??""}，如有疑问，请联系官方管理人员", style: TextStyle(color: AppColors.Color_FC6737, fontSize: ScreenAdapter.fontSize(12.0)),);
          break;
      }
    }

    // 提醒直播头部
    Widget _tipRemind(String type) {
      return Visibility(
        child: Container(
            padding: EdgeInsets.only(left: ScreenAdapter.width(12.0)),
            alignment: Alignment.centerLeft,
            height: ScreenAdapter.height(30.0),
            color: AppColors.Color_FDEAE4,
            child: _tipsBuild(type)),
        visible: !TextUtil.isEmpty(_status),);
    }

    // 累计收入模块
    Widget _totalMoneyModule = Container(
      alignment: Alignment.center,
      height: ScreenAdapter.height(83),
      width: ScreenAdapter.width(),
      margin: EdgeInsets.only(
        top: ScreenAdapter.height(12.0),
        left: ScreenAdapter.width(12.0),
        right: ScreenAdapter.width(12.0),
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
              Radius.circular(5.0)
          ),
          color: AppColors.white),
      child: GestureDetector(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("累计收入>", style: TextStyle(color: AppColors.black999, fontSize: ScreenAdapter.fontSize(15)),),
            Text.rich(TextSpan(children: [
              TextSpan(text: "¥", style: TextStyle(color: AppColors.Color_F9515A, fontSize: ScreenAdapter.fontSize(15))),
              TextSpan(
                  text: '${_dataInfo.totalMoney}', style: TextStyle(color: AppColors.Color_F9515A, fontSize: ScreenAdapter.fontSize(30))),
            ]))
          ],),
        onTap: () {
          if(_dataInfo.isLogin) {
            Navigator.of(context).pushNamed(
                Routes.homeproduct_detail,
                arguments: {'url': "${Config.inst.webUrl}/#/recommend"});
          }
        },
      ),
    );

    // 功能模块
    Widget _functionModule = Container(
        alignment: Alignment.center,
        height: ScreenAdapter.height(83),
        width: ScreenAdapter.width(),
        margin: EdgeInsets.only(
          top: ScreenAdapter.height(1.0),
          left: ScreenAdapter.width(12.0),
          right: ScreenAdapter.width(12.0),
        ),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
                Radius.circular(5.0)
            ),
            color: AppColors.white),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Expanded(
              child: _buildItemFunction(Images.icon_product_manager, "商品管理", () => {
                     Navigator.of(context).pushNamed(
                        Routes.homeproduct_detail,
                        arguments: {'url': "${Config.inst.webUrl}/#/goodsmanage/list"})
              }), flex: 1,
            ),
            Expanded(child: _buildItemFunction(Images.icon_my_live, "我的直播", () => {
              Navigator.of(context).pushNamed(Routes.live_list)
            }), flex: 1,),
            Expanded(child: _buildItemFunction(Images.icon_create_live, "创建直播", () {
              Provider.of<UserInfoVModel>(context).checkBeginBroadcast().then((value) {
                if(value.success) {
                  Navigator.of(context).pushNamed(Routes.live_create);
                } else {
                  Navigator.of(context).pushNamed(Routes.live_create_close, arguments: {'message': value.message});
                }
              });
            }), flex: 1,),
          ],)
    );

    SystemUiOverlayStyle overlayStyle =
        SystemUiOverlayStyle.light.copyWith(statusBarColor: Colors.transparent);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: overlayStyle,
      child: Scaffold(
        appBar: CustomAppBar(
          title: new Text('我的'),
          displayLeading: false,
        ),
        backgroundColor: AppColors.white,
        body: Padding(
          padding: EdgeInsets.only(
            top: ScreenAdapter.height(0),
          ),
          child: Container(
            height: double.infinity,
            child: SmartRefresher(
              physics: ClampingScrollPhysics(),
              controller: _refreshController,
              enablePullDown: true,
              enablePullUp: false,
              onRefresh: _onRefresh,
              header: CustomHeader(
                height: ScreenAdapter.height(60.0),
                builder: (context, mode) {
                  Widget body;
                  switch (mode) {
                    case RefreshStatus.idle:
                      body = Text("下拉刷新", style: _refreshLoadingTextStyle);
                      break;
                    case RefreshStatus.refreshing:
                      body = Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            width: ScreenAdapter.width(25.0),
                            child: AspectRatio(
                              aspectRatio: 1,
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation(
                                  AppColors.primaryRed,
                                ),
                                strokeWidth: 2.0,
                              ),
                            ),
                          ),
                          SizedBox(width: ScreenAdapter.width(10.0)),
                          Text('加载中', style: _refreshLoadingTextStyle),
                        ],
                      );
                      break;
                    case RefreshStatus.canRefresh:
                      body = Text("松开刷新", style: _refreshLoadingTextStyle);
                      break;
                    case RefreshStatus.failed:
                      body = Text("刷新失败", style: _refreshLoadingTextStyle);
                      break;
                    case RefreshStatus.completed:
                      body = Text("刷新完毕", style: _refreshLoadingTextStyle);
                      break;
                    default:
                      return Container();
                  }
                  return Container(
                    height: ScreenAdapter.height(60.0),
                    child: Center(
                      child: body,
                    ),
                  );
                },
              ),
              child: Container(
                height: double.infinity,
                color: AppColors.greyF4,
                child: SingleChildScrollView(
                  physics: NeverScrollableScrollPhysics(),
                  child: Column(
                    children: <Widget>[
                      _tipRemind(_status),
                      Stack(
                        overflow: Overflow.visible,
                        alignment: Alignment.topCenter,
                        children: <Widget>[
                          _header,
                          Container(
                            margin: EdgeInsets.only(top: ScreenAdapter.height(100.0)),
                            child: Column(
                              children: <Widget>[
                                _totalMoneyModule,
                                _functionModule,
                                Container(
                                  width: ScreenAdapter.width(),
                                  margin: EdgeInsets.only(left: ScreenAdapter.width(12.0), right: ScreenAdapter.width(12.0)),
                                  padding: EdgeInsets.only(top: ScreenAdapter.height(12.0)),
                                  child: ActionRow(
                                    title: '设置',
                                    icon: IconFont.setting,
                                    onPressed: () {
                                      Navigator.of(context).pushNamed(Routes.setting);
                                    },
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildItemFunction(String image, String text, GestureTapCallback onClick) {
    return GestureDetector(
      child: Container(
        color: AppColors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(image, width: ScreenAdapter.width(27.0), height: ScreenAdapter.height(24.0),),
            Divider(height: ScreenAdapter.height(6.0), color: AppColors.white,),
            Text(text, style: TextStyle(fontSize: ScreenAdapter.fontSize(13.0),
                color: AppColors.black666),)
          ],),
      ),
      onTap: onClick,
    );
  }

}
