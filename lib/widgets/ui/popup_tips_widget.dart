import 'package:app/constants/app_theme.dart';
import 'package:app/utils/screen_adapter.dart';
import 'package:app/widgets/basic/iconfont_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

enum PopupTipsStatus { DEFAULT, PENDING, SUCCESS, FAIL }

class PopupTips extends StatelessWidget {
  PopupTips({
    Key key,
    this.backgroundColor = AppColors.grey4B,
    this.text,
    this.status = PopupTipsStatus.DEFAULT,
  }) : super();

  final Color backgroundColor;
  final String text;
  final PopupTipsStatus status;

  Widget get animate {
    switch (this.status) {
      case PopupTipsStatus.DEFAULT:
        return Container();
      case PopupTipsStatus.PENDING:
        return CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation(AppColors.white),
        );
      case PopupTipsStatus.SUCCESS:
        return ConstrainedBox(
          constraints: BoxConstraints.tightFor(
            height: ScreenAdapter.fontSize(40.0),
          ),
          child: Icon(
            IconFont.success,
            size: ScreenAdapter.fontSize(40.0),
            color: AppColors.white,
          ),
        );
      case PopupTipsStatus.FAIL:
        return ConstrainedBox(
          constraints: BoxConstraints.tightFor(
            height: ScreenAdapter.fontSize(40.0),
          ),
          child: Icon(
            IconFont.fail,
            size: ScreenAdapter.fontSize(40.0),
            color: AppColors.white,
          ),
        );
    }
  }

  String get tips {
    if (this.text != null) {
      return this.text;
    }
    switch (this.status) {
      case PopupTipsStatus.DEFAULT:
        return '';
      case PopupTipsStatus.PENDING:
        return '提交中...';
      case PopupTipsStatus.SUCCESS:
        return '操作成功';
      case PopupTipsStatus.FAIL:
        return '操作失败';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(
          ScreenAdapter.width(6.0),
        ),
      ),
      padding: EdgeInsets.only(
        top: ScreenAdapter.width(26.0),
        bottom: ScreenAdapter.width(26.0),
        left: ScreenAdapter.width(34.0),
        right: ScreenAdapter.width(34.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          animate,
          Visibility(
            visible: tips.isNotEmpty,
            child: Container(
              padding: EdgeInsets.only(
                top: ScreenAdapter.height(32.0),
              ),
              child: Text(
                tips,
                style: TextStyle(
                  fontSize: ScreenAdapter.fontSize(14.0),
                  color: AppColors.white,
                  fontWeight: FontWeight.w400,
                  height: 0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
