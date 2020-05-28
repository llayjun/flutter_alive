import 'package:app/constants/images.dart';
import 'package:app/entry/config.dart';
import 'package:app/entry/routes.dart';
import 'package:app/repository/constant/local_cache_keys.dart';
import 'package:app/repository/local_repo.dart';
import 'package:app/utils/screen_adapter.dart';
import 'package:app/vmodel/user_info_vmodel.dart';
import 'package:flutter/material.dart';
import 'package:app/widgets/overwrite/custom_app_bar_widget.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Release extends StatefulWidget {
  Release({Key key}) : super();

  @override
  State<StatefulWidget> createState() => _ReleaseState();
}

class _ReleaseState extends State<Release> with AutomaticKeepAliveClientMixin {

  @override
  void initState() {
    super.initState();
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  WebViewController _controller;
  String token = '';
  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    Container loadingContainer = Container(
        child: Center(
      child: CircularProgressIndicator()
    ));
    return Scaffold(
        appBar: CustomAppBar(
          title: new Text('九大爷商城'),
          displayLeading: false,
        ),
        body: Container(
          child: SafeArea(
              child: Stack(
            children: <Widget>[
              WebView(
                initialUrl: '${Config.inst.webUrl}/#/home',
                javascriptMode: JavascriptMode.unrestricted,
                onWebViewCreated: (controller) {
                  _controller = controller;
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
                          token = prefs.getString(LocalCacheKeys.loggedInToken);
                          _controller
                              .evaluateJavascript(
                                  "getTokenCallBack('${token}')")
                              .then((result) {});
                        });
                      }),
                  JavascriptChannel(
                      name: 'nextStep',
                      onMessageReceived: (JavascriptMessage message) {
                        print('~~~~~~~~ ${message.message}');
                        String url =
                            '${Config.inst.webUrl}/#${message.message}';
                        Navigator.of(context).pushNamed(
                            Routes.homeproduct_detail,
                            arguments: {'url': url});
                      }),

                  JavascriptChannel(
                      name: 'logOut',
                      onMessageReceived: (JavascriptMessage message) {
                        /// 登陆页面
                        print('*********${message.message}');
                        Provider.of<UserInfoVModel>(context).logout().then(
                              (succ) {
                            if (succ) {
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                Routes.boot,
                                    (Route<dynamic> route) => false,
                              );
                            }
                          },
                        );
                      }),
                ].toSet(),
              ),
              Visibility(
                child: loadingContainer,
                visible: isLoading,
              ),
            ],
          )),
        ));
  }
}
