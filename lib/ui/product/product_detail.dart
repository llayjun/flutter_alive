import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:app/constants/app_theme.dart';
import 'package:app/constants/images.dart';
import 'package:app/constants/strings.dart';
import 'package:app/entry/config.dart';
import 'package:app/entry/routes.dart';
import 'package:app/repository/constant/local_cache_keys.dart';
import 'package:app/repository/local_repo.dart';
import 'package:app/utils/custom_toast.dart';
import 'package:app/utils/screen_adapter.dart';
import 'package:app/utils/sp_util.dart';
import 'package:app/vmodel/user_info_vmodel.dart';
import 'package:app/widgets/basic/iconfont_widget.dart';
import 'package:app/widgets/overwrite/custom_app_bar_widget.dart';
import 'package:common_utils/common_utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fluwx_no_pay/fluwx_no_pay.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ProductDetailPage extends StatefulWidget {
  final String url;

  ProductDetailPage({Key key, this.url}) : super(key: key);

  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  @override
  void initState() {
    super.initState();
    _initFluwx();
  }

  @override
  void dispose() {
    super.dispose();
  }

  bool result = false;
  bool isLoading = true;

  _initFluwx() async {
    await registerWxApi(
        appId: "wxfd04e16c3e6972d7",
        doOnAndroid: true,
        doOnIOS: true,
        universalLink: "https://linkurl.9daye.com.cn/");
    result = await isWeChatInstalled;
    print("is installed $result");
  }

  WebViewController _controller;
  String navTitle = '';
  bool ishideRight = true;
  bool isList = true;
  String token = '';

  @override
  Widget build(BuildContext context) {
    Container loadingContainer =
        Container(child: Center(child: CircularProgressIndicator()));
    // TODO: implement build

    return Scaffold(
        appBar: CustomAppBar(
          leading: IconButton(
            iconSize: Theme.of(context).appBarTheme.iconTheme.size,
            icon: const Icon(IconFont.go_back),
            onPressed: () {
              onPop(context);
            },
          ),
          title: Text(this.navTitle),
          actions: <Widget>[
            Visibility(
              child: GestureDetector(
                onTap: () {
                  _controller
                      .evaluateJavascript("rightClick('aaaaaa')")
                      .then((result) {
                  });
                },
                child: Padding(
                  padding: EdgeInsets.only(right: ScreenAdapter.width(10)),
                  child: Image.asset(
                    isList ? Images.icon_ver_list : Images.icon_hev_list,
                    width: 20,
                    height: 20,
                  ),
                ),
              ),
              visible: !ishideRight,
            )
          ],
        ),
        body: SafeArea(
          child: Container(
              color: AppColors.white,
              child: Stack(
                children: <Widget>[
                  ScrollConfiguration(
                    behavior: OverScrollBehavior(),
                    child: WebView(
                      initialUrl: widget.url,
                      javascriptMode: JavascriptMode.unrestricted,
                      onWebViewCreated: (controller) {
                        _controller = controller;
                        controller.canGoBack().then((res) {
                          controller.goBack();
                        });
                        controller.canGoForward().then((res) {
                          controller.goForward();
                        });
                      },
                      onPageFinished: (url) {
                        setState(() {
                          isLoading = false;
                        });
                      },
                      onPageStarted: (url) {},
                      navigationDelegate: (NavigationRequest request) {
                        if (request.url.startsWith("myapp://")) {
                          return NavigationDecision.prevent;
                        }
                        return NavigationDecision.navigate;
                      },
                      javascriptChannels: <JavascriptChannel>[
                        JavascriptChannel(
                            name: 'getToken',
                            onMessageReceived: (JavascriptMessage message) {
                              LocalRepo.inst.prefs.then((prefs) {
                                token = prefs
                                    .getString(LocalCacheKeys.loggedInToken);
                                _controller
                                    .evaluateJavascript(
                                    "getTokenCallBack('${token}')")
                                    .then((result) {});
                              });
                            }),
                        JavascriptChannel(
                            name: 'setNavBar',
                            onMessageReceived: (JavascriptMessage message) {
                              Map myMap = json.decode(message.message);
                              setState(() {
                                this.navTitle = myMap['navTitle'];
                                if (myMap.keys.contains('isList')) {
                                  ishideRight = false;
                                  isList = myMap['isList'];
                                } else {
                                  ishideRight = true;
                                }
                              });
                            }),
                        JavascriptChannel(
                            name: 'nextStep',
                            onMessageReceived: (JavascriptMessage message) {
                              String url =
                                  '${Config.inst.webUrl}/#${message.message}';
                              Navigator.of(context).pushNamed(
                                  Routes.homeproduct_detail,
                                  arguments: {'url': url});
                            }),
                        JavascriptChannel(
                            name: 'shareLink',
                            onMessageReceived: (JavascriptMessage message) {
                              Map myMap = json.decode(message.message);
                              if (result) {
                                _share(myMap['link'], myMap['title'],
                                    myMap['thumbnail'], myMap['description']);
                              } else {
                                CustomToast.showToast(msg: "抱歉！暂无分享渠道", gravity: ToastGravity.CENTER);
                              }
                            }),
                        JavascriptChannel(
                            name: 'getUserInfo',
                            onMessageReceived: (JavascriptMessage message) {
                              Map _map = Map();
                              _map['userName'] =
                                  SpUtil.getString(LocalCacheKeys.userName);
                              _map['userIcon'] =
                                  SpUtil.getString(LocalCacheKeys.userIcon);
                              _map['siteId'] =
                                  SpUtil.getString(LocalCacheKeys.siteId);
                              print('~~~~~~~~~ ${json.encode(_map)}');
                              _controller
                                  .evaluateJavascript(
                                  "getUserInfoCallBack('${json.encode(_map)}')")
                                  .then((result) {});
                            }),
                        JavascriptChannel(
                            name: 'logOut',
                            onMessageReceived: (JavascriptMessage message) {
                              /// 登陆页面
                              Provider.of<UserInfoVModel>(context)
                                  .logout()
                                  .then(
                                    (succ) {
                                  if (succ) {
                                    Navigator.of(context)
                                        .pushNamedAndRemoveUntil(
                                      Routes.boot,
                                          (Route<dynamic> route) => false,
                                    );
                                  }
                                },
                              );
                            }),
                        JavascriptChannel(
                            name: 'shareImage',
                            onMessageReceived:
                                (JavascriptMessage message) async {
                              print('~~~~~~~~**** ${message.message}');

                              String url = message.message;
                              var response = await Dio().get(url,
                                  options: Options(
                                      responseType: ResponseType.bytes));
                              ImageGallerySaver.saveImage(
                                Uint8List.fromList(
                                  response.data,
                                ),
                              ).then((value) {
                                CustomToast.showToast(
                                    msg: Strings
                                        .live_create_wx_code_doc_saving_success,
                                    gravity: ToastGravity.CENTER);
                              }).catchError((error) {
                                CustomToast.showToast(
                                    msg: Strings
                                        .live_create_wx_code_doc_saving_fail,
                                    gravity: ToastGravity.CENTER);
                              });
                            })
                      ].toSet(),
                      gestureRecognizers: {
                        Factory(() => VerticalDragGestureRecognizer())
                      },
                    ),
                  ),

                  Visibility(
                    child: loadingContainer,
                    visible: isLoading,
                  ),
                ],
              )),
        ));
  }

  /// 返回箭头监听
  onPop(BuildContext context) {
    _controller?.canGoBack()?.then((value) {
      if (value) {
        _controller?.goBack();
      } else {
        Navigator.of(context).pop();
      }
    });
  }

  void _share(String url, String title, String thumnail, String description) {
    var model = WeChatShareWebPageModel(url,
        title: title,
        thumbnail: WeChatImage.network(thumnail),
        scene: WeChatScene.SESSION,
        description: description);
    shareToWeChat(model).then((value) {}, onError: () {});
  }
}


class OverScrollBehavior extends ScrollBehavior{

  @override
  Widget buildViewportChrome(BuildContext context, Widget child, AxisDirection axisDirection) {
    switch (getPlatform(context)) {
      case TargetPlatform.iOS:
        return child;
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
        return GlowingOverscrollIndicator(
          child: child,
          //不显示头部水波纹
          showLeading: false,
          //不显示尾部水波纹
          showTrailing: false,
          axisDirection: axisDirection,
          color: Theme.of(context).accentColor,
        );
    }
    return null;
  }

  ScrollPhysics getScrollPhysics(BuildContext context) {
    switch (getPlatform(context)) {
      case TargetPlatform.iOS:
        return const NeverScrollableScrollPhysics();
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
        return const ClampingScrollPhysics();
    }
    return null;
  }

}
