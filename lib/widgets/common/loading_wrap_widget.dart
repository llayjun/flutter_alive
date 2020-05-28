import 'package:app/constants/app_theme.dart';
import 'package:app/utils/screen_adapter.dart';
import 'package:app/widgets/ui/popup_tips_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum LoadingCoverType {
  // 控制当在loading时，内容的状态
  occupy, // 内容不载入
  opacity, // 内容载入，并且loading效果覆盖在内容上方，并且带有一定透明度的蒙层（layer）
  cover, // 内容载入但是看不见，并且loading效果覆盖在内容上方
}

class LoadingWrap extends StatelessWidget {
  LoadingWrap({
    Key key,
    this.loading = false,
    this.loadingWidget,
    this.saving = false,
    this.savingWidget,
    @required this.child,
    this.type = LoadingCoverType.occupy,
    this.opacity = 0.25,
    this.tips = '',
    this.savingTips = '保存中...',
  })  : assert(opacity <= 1 && opacity >= 0),
        super();

  final bool loading;
  final Widget loadingWidget;
  final bool saving;
  final Widget savingWidget;
  final Widget child;
  final LoadingCoverType type;
  final num opacity;
  final String tips;
  final String savingTips;

  String get _tips {
    if (loading ?? false) {
      return tips;
    }
    if (saving ?? false) {
      return savingTips;
    }
    return '';
  }

  Widget get _animate {
    if ((this.loading ?? false) && this.loadingWidget != null) {
      return this.loadingWidget;
    }
    if ((this.saving ?? false) && this.savingWidget != null) {
      return this.savingWidget;
    }
    return CircularProgressIndicator();
  }

  LoadingCoverType get _type {
    if (this.saving ?? false) {
      return LoadingCoverType.cover;
    }
    return type;
  }

  bool get _showAnimate {
    return (this.loading ?? false) || (this.saving ?? false);
  }

  @override
  Widget build(BuildContext context) {
    switch (_type) {
      case LoadingCoverType.occupy:
        if (!_showAnimate) {
          return this.child;
        } else {
          return Container(
            width: ScreenAdapter.width(375.0),
            alignment: _showAnimate ? Alignment.center : null,
            child: _animate,
          );
        }
        break;
      case LoadingCoverType.cover:
        return Container(
          width: double.infinity,
          height: double.infinity,
          child: Stack(
            fit: StackFit.passthrough,
            children: <Widget>[
              this.child,
              Visibility(
                child: Positioned(
                  left: 0,
                  top: 0,
                  bottom: 0,
                  right: 0,
                  child: Container(
                    color: Colors.transparent,
                    alignment: Alignment.center,
                    child: PopupTips(
                      backgroundColor:AppColors.grey4B,
                      status: PopupTipsStatus.PENDING,
                      text: _tips,
                    ),
                  ),
                ),
                visible: _showAnimate,
              ),
            ],
          ),
        );
      case LoadingCoverType.opacity:
        return Container(
          width: double.infinity,
          height: double.infinity,
          child: Stack(
            fit: StackFit.passthrough,
            children: <Widget>[
              this.child,
              Visibility(
                child: Positioned(
                  left: 0,
                  top: 0,
                  bottom: 0,
                  right: 0,
                  child: Container(
                    color: AppColors.black.withOpacity(opacity),
                    alignment: Alignment.center,
                    child: _animate,
                  ),
                ),
                visible: _showAnimate,
              )
            ],
          ),
        );
    }
  }
}
