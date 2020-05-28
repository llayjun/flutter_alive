import 'dart:async';
import 'dart:ui';
import 'package:app/constants/app_theme.dart';
import 'package:app/utils/screen_adapter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:meta/meta.dart';
import 'package:flutter/foundation.dart';

enum ToastDuration { LENGTH_SHORT, LENGTH_LONG }

//enum ToastGravity { TOP, BOTTOM, CENTER }

class CustomToast {


  static const MethodChannel _channel =
      const MethodChannel('PonnamKarthik/fluttertoast');

  // for Version 4.x.x

  // static Fluttertoast _instance;

  // static Fluttertoast get instance {
  //   if (_instance == null) {
  //     _instance =Fluttertoast._create();
  //   }
  //   return _instance;
  // }

  // Fluttertoast._create(){
  // }

  static Future<bool> cancel() async {
    bool res = await _channel.invokeMethod("cancel");
    return res;
  }


  static Future<bool> showToast({
    @required String msg,
    ToastDuration toastLength,
    int time = 1,
    double fontSize,
    ToastGravity gravity,
    Color backgroundColor,
    Color textColor,
    // Function(bool) didTap,
  }) async {
    // this.didTap = didTap;
    String toast = "short";
    if (toastLength == ToastDuration.LENGTH_LONG) {
      toast = "long";
    }

    String gravityToast = "bottom";
    if (gravity == ToastGravity.TOP) {
      gravityToast = "top";
    } else if (gravity == ToastGravity.CENTER) {
      gravityToast = "center";
    } else {
      gravityToast = "bottom";
    }

    final Map<String, dynamic> params = <String, dynamic>{
      'msg': msg,
      'length': toast,
      'time': time,
      'gravity': gravityToast,
      'bgcolor': backgroundColor != null ? backgroundColor.value : AppColors.grey4B.value,
      'textcolor': textColor != null ? textColor.value: AppColors.white.value,
      'fontSize': fontSize ?? ScreenAdapter.fontSize(12.0),
    };

    bool res = await _channel.invokeMethod('showToast', params);
    return res;
  }

}
