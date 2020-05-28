import 'package:app/constants/app_theme.dart';
import 'package:app/constants/images.dart';
import 'package:app/utils/screen_adapter.dart';
import 'package:app/widgets/overwrite/custom_app_bar_widget.dart';
import 'package:flutter/material.dart';

class CreateLiveCloseScreen extends StatelessWidget {

  String message = "直播功能未开通或已停用";

  CreateLiveCloseScreen({Key key, this.message})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Text("$message"),
      ),
      backgroundColor: AppColors.white,
      body: Container(
          padding: EdgeInsets.only(bottom: ScreenAdapter.height(50.0)),
          alignment: Alignment.center,
          child: Column(
            children: <Widget>[
              Expanded(
                  child: Container(
                padding: EdgeInsets.only(top: ScreenAdapter.height(100.0)),
                child: Column(
                  children: <Widget>[
                    Image.asset(
                      Images.icon_create_error,
                      fit: BoxFit.fill,
                      width: ScreenAdapter.width(150.0),
                      height: ScreenAdapter.height(150.0),
                    ),
                    SizedBox(
                      height: ScreenAdapter.height(30.0),
                    ),
                    Text(
                      '$message',
                      style: TextStyle(
                          fontSize: ScreenAdapter.fontSize(15.0),
                          color: AppColors.black43),
                      maxLines: 2,
                    )
                  ],
                ),
              )),
              Text(
                "如有疑问，请联系管理人员或客服电话400-0318-119",
                style: TextStyle(
                    fontSize: ScreenAdapter.fontSize(15.0),
                    color: AppColors.black43),
                maxLines: 2,
              )
            ],
          )),
    );
  }
}
