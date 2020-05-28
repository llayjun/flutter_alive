import 'dart:io';
import 'dart:math';

import 'package:app/constants/strings.dart';
import 'package:app/entry/routes.dart';
import 'package:app/repository/channel_react.dart';
import 'package:app/repository/constant/local_cache_keys.dart';
import 'package:app/repository/local_repo.dart';
import 'package:app/utils/custom_toast.dart';
import 'package:app/utils/log.dart';
import 'package:app/widgets/overwrite/custom_app_bar_widget.dart';
import 'package:common_utils/common_utils.dart';
import 'package:flutter/cupertino.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:app/constants/app_theme.dart';
import 'package:app/widgets/common/loading_wrap_widget.dart';
import 'package:app/widgets/basic/iconfont_widget.dart';
import 'package:app/ui/live/live_vmodel.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fluwx_no_pay/fluwx_no_pay.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:app/utils/screen_adapter.dart';
import 'package:app/widgets/overwrite/custom_single_child_scroll_view_widget.dart';
import 'package:app/models/dto/live/live_broadcast_dto.dart';
import 'package:fluwx_no_pay/fluwx_no_pay.dart' as fluwx;
import 'package:app/entry/config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LiveList {}

class LiveListScreen extends StatefulWidget {
  @override
  _LiveListScreenState createState() => _LiveListScreenState();
}

class _LiveListScreenState extends State<LiveListScreen> {
  // bool _fetching = false;
  /// 监听
  EventChannel eventChannel =
      EventChannel(Strings.flutter_sharename, const StandardMethodCodec());

  @override
  void initState() {
    super.initState();
    /// 注册让原生调用flutter的值
    ChannelReact.platform.setMethodCallHandler(ChannelReact.getInstance().getUrl);

    new Future.delayed(Duration.zero, () {
      Provider.of<LiveVModel>(context).fetchPagingData(true, "", "");
    });

    _initFluwx();

    eventChannel
        .receiveBroadcastStream()
        .listen(_onEvent, onError: _onError);

//    LocalRepo.inst.prefs.then((value) {
//      String userName = value.getString(LocalCacheKeys.userName);
//      if(userName == "781417628") {
//        show = false;
//      }
//    });

  }
  bool result = false;

  _initFluwx() async {
    await registerWxApi(
        appId: "wxfd04e16c3e6972d7",
        doOnAndroid: true,
        doOnIOS: true,
        universalLink: "https://linkurl.9daye.com.cn/");
    result = await isWeChatInstalled;
    print("is installed $result");
  }

  // 数据接收
  void _onEvent(Object value) {
    LogUtil.e("share_info" + value.toString());
    if(result) {
      Map myMap = value;
      WeChatScene scene = WeChatScene.SESSION;
      String _webPageUrl = "http://";
      String _thumbnail = myMap['url'];
      String _title = myMap['name'];
      String _userName = Config.inst.miniUsername;
      String _path = "/pages/live/detail/detail?roomId=${myMap['fileId']}";
      String _description = myMap['description'];

      var model = new WeChatShareMiniProgramModel(
          webPageUrl: _webPageUrl,
          userName: _userName,
          title: _title,
          path: _path,
          description: _description,
          thumbnail: WeChatImage.network(_thumbnail)
      );
      shareToWeChat(model);
    }else {
      CustomToast.showToast(msg: "抱歉！暂无分享渠道", gravity: ToastGravity.CENTER);
    }

  }


  void _onError(dynamic) {

  }



  Widget _buildTitle(LiveBroadcastDTO data) {
    Color _bgColor = Colors.transparent;
    Color _borderColor;
    Color _textColor;
    String _text;
    final _padding = ScreenAdapter.width(4.0);
    final _fontSize = ScreenAdapter.fontSize(12.0);
    switch (data.status) {
      case 'LIVE':
        _bgColor = AppColors.primaryRed;
        _borderColor = AppColors.primaryRed;
        _textColor = AppColors.white;
        _text = '直播中';
        break;
      case 'RECORDING':
        _bgColor = AppColors.greyD8;
        _borderColor = AppColors.greyD8;
        _textColor = AppColors.white;
        _text = '已结束';
        break;
      default:
        _borderColor = AppColors.primaryRed;
        _textColor = AppColors.primaryRed;
        _text = '待开始';
    }

    return RichText(
      text: TextSpan(
        children: <InlineSpan>[
          WidgetSpan(
            child: Container(
              padding: EdgeInsets.only(
                left: _padding,
                right: _padding,
              ),
              height: ScreenAdapter.height(18.0),
              decoration: BoxDecoration(
                color: _bgColor,
                border: Border.all(
                  width: ScreenAdapter.borderWidth(),
                  color: _borderColor,
                ),
                borderRadius: BorderRadius.circular(
                  ScreenAdapter.width(4.0),
                ),
              ),
              child: Text(
                _text,
                style: TextStyle(
                  color: _textColor,
                  fontSize: _fontSize,
                ),
              ),
            ),
          ),
          WidgetSpan(
            child: SizedBox(
              width: ScreenAdapter.width(5.0),
            ),
          ),
          TextSpan(
            text: data.title,
            style: TextStyle(
              fontSize: ScreenAdapter.fontSize(17.0),
              fontWeight: FontWeight.w600,
              color: const Color(0xFF434343),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, [String text = '']) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          height: ScreenAdapter.height(12.0),
          width: ScreenAdapter.width(26.0),
          child: Icon(
            icon,
            size: ScreenAdapter.fontSize(12.0),
            color: AppColors.greyD8,
            textDirection: TextDirection.rtl,
          ),
        ),
        Text(
          text,
          style: TextStyle(
            fontSize: ScreenAdapter.fontSize(12.0),
            color: AppColors.grey9C,
          ),
        ),
      ],
    );
  }

  Widget _buildBtn(IconData icon, String text, VoidCallback onPressed) {
    return GestureDetector(
        onTap: onPressed,
        child: Container(
          padding: EdgeInsets.only(
              top: ScreenAdapter.width(8.0), left: ScreenAdapter.width(8.0)),
          child: Row(
            children: <Widget>[
              SizedBox(
                width: ScreenAdapter.width(16.0),
              ),
              Container(
                width: ScreenAdapter.width(26.0),
                alignment: Alignment.centerRight,
                child: Icon(
                  icon,
                  size: ScreenAdapter.fontSize(16.0),
                  textDirection: TextDirection.rtl,
                  color: AppColors.black666,
                ),
              ),
              SizedBox(
                width: ScreenAdapter.width(4.0),
              ),
              Text(
                text,
                style: TextStyle(
                  fontSize: ScreenAdapter.fontSize(14.0),
                  color: AppColors.black666,
                ),
              ),
            ],
          ),
        ));
  }

  Widget _buildItem(LiveBroadcastDTO data) {
    return GestureDetector(
      onTap: () {
        Log.inst.info('todo: tap broadcast channel: ${data.id}');
        if (data.status != 'RECORDING') {
          return;
        }
        Navigator.of(context).pushNamed(
          Routes.live_record_detail,
          arguments: {'id': data.id},
        );
      },
      child: Container(
        margin: EdgeInsets.only(
          bottom: ScreenAdapter.height(10.0),
        ),
        color: AppColors.white,
        height: ScreenAdapter.height(140.0),
        padding: EdgeInsets.only(
          left: ScreenAdapter.width(12.0),
          right: ScreenAdapter.width(14.0),
          top: ScreenAdapter.width(21.0),
          bottom: ScreenAdapter.width(19.0),
        ),
        child: Row(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: AspectRatio(
                aspectRatio: 1,
                child: Image.network(
                  data.squareCover != null ? data.squareCover.url : "",
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(
              width: ScreenAdapter.width(10.0),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      // title
                      _buildTitle(data),
                      SizedBox(
                        height: ScreenAdapter.height(5.0),
                      ),
                      // time
                      Text(
                        '直播时间: ${data.beginTime}',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: ScreenAdapter.fontSize(12.0),
                          color: AppColors.black999,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Visibility(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            _buildInfoItem(
                              IconFont.live_visitor,
                              data.totalView.toString(),
                            ),
                            SizedBox(
                              width: ScreenAdapter.width(15.0),
                            ),
                            _buildInfoItem(
                              IconFont.live_thumb,
                              data.totalPraise.toString(),
                            ),
                          ],
                        ),
                        visible: data.status == 'RECORDING',
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Visibility(
                            child: _buildBtn(
                              IconFont.edit_live,
                              '编辑',
                              () {
                                int time = DateUtil.getDateMsByTimeStr(data.beginTime);
                                int nowTime = DateUtil.getNowDateMs();
                                int differTime = time - nowTime;
                                if(differTime > 60 * 5 * 1000) {
                                  Navigator.of(context).pushNamed(
                                    Routes.live_edit,
                                    arguments: {'id': data.id},
                                  );
                                } else {
                                  showDialog(
                                      context: context,
                                      barrierDismissible: false, // 点击外部不消失
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          content: Text(
                                            "直播即将开始，请勿修改",
                                            style: TextStyle(fontSize: ScreenAdapter.fontSize(15.0)),
                                            textAlign: TextAlign.center,
                                          ),
                                          actions: <Widget>[
                                            CupertinoButton(
                                              child: Text("知道了"),
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                            ),
                                          ],
                                        );
                                      });
                                }
                              },
                            ),
                            visible: data.status != 'RECORDING' &&
                                data.status != 'LIVE' &&
                                data.editTime < 1,
                          ),
                          SizedBox(width: 10,),
                          Visibility(
                            child: _buildBtn(
                              IconFont.visit_live,
                              '直播',
                              () async {
                                String token = '';
                                LocalRepo.inst.prefs.then((prefs) {
                                  token = prefs
                                      .getString(LocalCacheKeys.loggedInToken);

                                  if(Platform.isAndroid) {
                                    requestPermission().then((value) {
                                      if(value){
                                        /// 跳转安卓原生
                                        ChannelReact.getInstance().jumpToBoast(Strings.alilive, (value) {
                                          /// 刷新数据
                                          print('!!!!!!!!!!!!${value}');
                                          Provider.of<LiveVModel>(context).fetchPagingData(true, "", "");
                                        }, param: {'id': data.id, 'token': token});
                                      } else {
                                        CustomToast.showToast(msg: "需要开启权限", gravity: ToastGravity.CENTER);
                                      }
                                    });
                                  } else {
                                    /// 跳转iOS原生
                                    ChannelReact.getInstance().jumpToBoast(Strings.alilive, (value) {
                                      /// 刷新数据
                                      print('!!!!!!!!!!!!${value}');
                                      Provider.of<LiveVModel>(context).fetchPagingData(true, "", "");
                                    }, param: {'id': data.id, 'token': token});
                                  }
                                });

//                                ChannelReact.getInstance().jumpToBoast(
//                                    Strings.alilive, (value) {},
//                                    param:
//                                        "rtmp://push.tv.9daye.cn/boardcast/00002?auth_key=1582029253-0-0-2dbff8bacc02fd670a2ea5ee7b085318");
                              },
                            ),
                            visible: data.status == 'LIVE' ||
                                data.status == 'PENDING',
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var dataInfo = Provider.of<LiveVModel>(context);
    return Scaffold(
      appBar: CustomAppBar(
        title: Text('直播列表'),
      ),
      body: LoadingWrap(
        loading: dataInfo.loadingData,
        child: RefreshIndicator(
          onRefresh: () => dataInfo.fetchPagingData(true, "", ""),
          child: Container(
            height: double.infinity,
            child: CustomSingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              loading: dataInfo.loadingMore,
              finished: dataInfo.nothingMore,
              empty: dataInfo.liveList.length <= 0,
              onLoadMore: () => dataInfo.fetchPagingData(false, "", ""),
              child: Padding(
                padding: EdgeInsets.only(
                  top: ScreenAdapter.height(10.0),
                ),
                child: Column(
                  children: dataInfo.liveList
                      .map((item) => _buildItem(item))
                      .toList(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// 申请权限
Future<bool> requestPermission() async {
  bool canJump = true;
  // 申请权限
  Map<PermissionGroup, PermissionStatus> permissions = await PermissionHandler().requestPermissions([
    PermissionGroup.camera,
    PermissionGroup.mediaLibrary,
    PermissionGroup.storage]);
  permissions.forEach((key, value){
      if(value != PermissionStatus.granted) {
        canJump = false;
      }
  });
  return canJump;
}
