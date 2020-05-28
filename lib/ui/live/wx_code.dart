import 'dart:typed_data';

import 'package:app/constants/app_theme.dart';
import 'package:app/constants/images.dart';
import 'package:app/constants/strings.dart';
import 'package:app/entry/config.dart';
import 'package:app/entry/routes.dart';
import 'package:app/models/dto/live/live_broadcast_dto.dart';
import 'package:app/repository/constant/local_cache_keys.dart';
import 'package:app/utils/custom_toast.dart';
import 'package:app/utils/screen_adapter.dart';
import 'package:app/utils/sp_util.dart';
import 'package:app/widgets/common/loading_wrap_widget.dart';
import 'package:app/widgets/overwrite/custom_app_bar_widget.dart';
import 'package:common_utils/common_utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:fluwx_no_pay/fluwx_no_pay.dart' as fluwx;
import 'dart:ui' as ui;

class LiveCreateWxCodeScreen extends StatefulWidget {
  LiveCreateWxCodeScreen({Key key, this.arguments}) : super(key: key);

  final Map<String, dynamic> arguments;

  @override
  _LiveCreateWxCodeScreenState createState() => _LiveCreateWxCodeScreenState();
}

class _LiveCreateWxCodeScreenState extends State<LiveCreateWxCodeScreen> {
  bool _saving = false;

  LiveBroadcastDTO _liveBroadcastDto = LiveBroadcastDTO();

  void initState() {
    super.initState();
    PermissionHandler()
        .requestPermissions(<PermissionGroup>[PermissionGroup.storage]);

    _liveBroadcastDto = widget.arguments != null
        ? LiveBroadcastDTO.fromJson(widget.arguments)
        : LiveBroadcastDTO();
  }

  void _commit() async {
    setState(() {
      _saving = true;
    });
    String url = _liveBroadcastDto?.sharePosterPending;
    var response = await Dio().get(
      url,
      options: Options(
        responseType: ResponseType.bytes,
      ),
    );
    final result = await ImageGallerySaver.saveImage(
      Uint8List.fromList(response.data,),
    );
    setState(() {
      _saving = false;
    });
    if (!TextUtil.isEmpty(result)) {
      CustomToast.showToast(msg: Strings.live_create_wx_code_doc_saving_success, gravity: ToastGravity.CENTER);
    } else {
      CustomToast.showToast(msg: Strings.live_create_wx_code_doc_saving_fail, gravity: ToastGravity.CENTER);
    }
    /// 分享小程序暂时不开放
//    fluwx.launchWeChatMiniProgram(
//      username: Config.inst.miniUsername,
//      path: "/pages/live/detail/detail?roomId=${_liveBroadcastDto.id}",
//      // miniProgramType: fluwx.WXMiniProgramType.PREVIEW,
//    );
  }

  Future<Uint8List> _capturePng(globalKey) async {
    RenderRepaintBoundary boundary = globalKey.currentContext.findRenderObject();
    ui.Image image = await boundary.toImage();
    ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List picBytes = byteData.buffer.asUint8List();
    return picBytes;
  }

  GlobalKey globalKey = new GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Text(
          Strings.title_live_create_wx_code,
        ),
      ),
      backgroundColor: AppColors.white,
      body: LoadingWrap(
        saving: _saving,
        savingTips: Strings.live_create_wx_code_doc_loading_tips,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(padding: EdgeInsets.only(top: ScreenAdapter.height(20.0), bottom: ScreenAdapter.height(20.0)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Image.asset(
                    Images.live_create_wx_code_check,
                    width: ScreenAdapter.width(24.0),
                  ),
                  SizedBox(
                    width: ScreenAdapter.width(3.0),
                  ),
                  Text(
                    Strings.live_create_wx_code_doc_create_success,
                    style: TextStyle(
                      color: AppColors.black333,
                      fontSize: ScreenAdapter.fontSize(17.0),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),),
              RepaintBoundary(
                key: globalKey,
                child: Container(
                  width: ScreenAdapter.width(270.0),
                  padding: EdgeInsets.all(ScreenAdapter.width(16.0)),
                  alignment: Alignment.topCenter,
                  decoration: BoxDecoration(
                    color: AppColors.greyF1,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Image.network( _liveBroadcastDto?.sharePosterPending,
                    fit: BoxFit.fill,
                    width: ScreenAdapter.height(360.0),),
                ),
              ),
              SizedBox(height: ScreenAdapter.height(12.0),),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  _btnBuild(
                    Strings.live_create_wx_code_btn_save,
                    true,
                    _commit,
                  ),
                  SizedBox(
                    height: ScreenAdapter.height(15.0),
                  ),
                  _btnBuild(
                    Strings.live_create_wx_code_btn_back_to_list,
                    false,
                        () {
                      Navigator.of(context).pushNamed(Routes.live_list);
                    },
                  ),
                  SizedBox(
                    height: ScreenAdapter.height(40.0),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _btnBuild(String text, bool primary, VoidCallback callback) {
    return FlatButton(
      padding: EdgeInsets.zero,
      child: Container(
        width: ScreenAdapter.width(230.0),
        height: ScreenAdapter.height(44.0),
        decoration: BoxDecoration(
          color: primary ? AppColors.primaryRed : AppColors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(
              ScreenAdapter.height(22.0),
            ),
          ),
          border: Border.all(
            width: ScreenAdapter.borderWidth(),
            color: AppColors.primaryRed,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          style: TextStyle(
            color: primary ? AppColors.white : AppColors.primaryRed,
            fontSize: ScreenAdapter.fontSize(14.0),
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      onPressed: callback,
    );
  }
}
