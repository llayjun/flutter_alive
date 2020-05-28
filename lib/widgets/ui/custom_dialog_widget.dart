import 'package:app/constants/app_theme.dart';
import 'package:app/utils/screen_adapter.dart';
import 'package:flutter/material.dart';

class ShowDialog {
  // 自定义弹窗
  static showCustomDialog(BuildContext context
        , {String title = "提示"
        , String leftText = "取消"
        , String rightText = "确定"
        , String content = "内容"
        , Function callBack}) {
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
                        title,
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
                            content,
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
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Center(
                                child: Text(
                                  leftText,
                                  style: TextStyle(
                                    fontSize: ScreenAdapter.fontSize(15.0),
                                    color: AppColors.black666,
                                    fontWeight: FontWeight.normal,
                                    decoration: TextDecoration.none,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            color: AppColors.Color_F0F0F0,
                            width: 1,
                          ),
                          Expanded(
                            child: GestureDetector(
                              child: Center(
                                child: Text(
                                  rightText,
                                  style: TextStyle(
                                    fontSize: ScreenAdapter.fontSize(15.0),
                                    color: AppColors.Color_F9515A,
                                    fontWeight: FontWeight.normal,
                                    decoration: TextDecoration.none,
                                  ),
                                ),
                              ),
                              onTap: () {
                                callBack();
                                Navigator.pop(context);
                              },
                            ),
                          ),
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
}
