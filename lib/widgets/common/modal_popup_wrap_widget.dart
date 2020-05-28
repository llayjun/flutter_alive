import 'package:app/constants/app_theme.dart';
import 'package:app/constants/strings.dart';
import 'package:app/utils/screen_adapter.dart';
import 'package:flutter/material.dart';

class ModalPopupWrap extends StatelessWidget{
  ModalPopupWrap({
    Key key,
    this.height,
    this.title = '',
    this.child,
    this.onCancel,
    this.onConfirm,
    this.onPressed = null,
    this.titleTextStyle = const TextStyle(
      fontSize: 17.0,
      color: AppColors.black43,
      fontWeight: FontWeight.w500
    ),
    this.btnTextStyle = const TextStyle(
      fontSize: 14.0,
      color: AppColors.black43,
      fontWeight: FontWeight.w500,
      height: 17/14
    )
  }):super(key: key);

  final double height;
  final String title;
  final Widget child;
  final VoidCallback onCancel;
  final VoidCallback onConfirm;
  final void Function(String) onPressed;
  final TextStyle titleTextStyle;
  final TextStyle btnTextStyle;



  @override
  Widget build (BuildContext context){
    return Container(
      height: ScreenAdapter.height(this.height),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.0),
          topRight: Radius.circular(10.0)
        )
      ),
      child: Column(
        children: <Widget>[
          Container(
            height: ScreenAdapter.height(40.0),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: AppColors.greyEF,
                  width: ScreenAdapter.borderWidth()
                )
              )
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                FlatButton(
                  child: Text(
                    Strings.modal_popup_wrap_widget_btn_cancel,
                    style: this.btnTextStyle.copyWith(
                      fontSize: ScreenAdapter.fontSize(this.btnTextStyle.fontSize)
                    )
                  ),
                  onPressed: (){
                    if(this.onPressed != null){
                      this.onPressed('cancel');
                    } else if(this.onCancel != null) {
                      this.onCancel();
                    } else {
                      Navigator.of(context).pop();
                    }
                  }
                ),
                Text(
                  title,
                  style: this.titleTextStyle.copyWith(
                    fontSize: ScreenAdapter.fontSize(this.titleTextStyle.fontSize),
                    decoration: TextDecoration.none
                  )
                ),
                FlatButton(
                  child: Text(
                    Strings.modal_popup_wrap_widget_btn_confirm,
                    style: this.btnTextStyle.copyWith(
                      fontSize: ScreenAdapter.fontSize(this.btnTextStyle.fontSize)
                    )
                  ),
                  onPressed: (){
                    if(this.onPressed != null){
                      this.onPressed('confirm');
                    } else if(this.onConfirm != null) {
                      this.onConfirm();
                    } else {
                      Navigator.of(context).pop();
                    }
                  }
                )
              ]
            ),
          ),
          Expanded(
            flex: 1,
            child: this.child
          )
        ]
      )
    );
  }
}