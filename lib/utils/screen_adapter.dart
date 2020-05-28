import 'dart:ui';

import 'package:flutter/cupertino.dart';

class ScreenAdapter{
  static MediaQueryData mediaQuery = MediaQueryData.fromWindow(window);
  static EdgeInsets get padding => mediaQuery.padding;

  static double width([double width]){
    if(width == null){
      return mediaQuery.size.width;
    }
    return width / 375.0 * mediaQuery.size.width;
  }
  static double height(double height){
    return height / 375.0 * mediaQuery.size.width;
  }
  static double fontSize(double fontSize){
    return (fontSize / 375.0 * mediaQuery.size.width).floorToDouble();
  }
  static double borderWidth([double borderWidth]){
    return ( borderWidth ?? 1.0 ) / mediaQuery.devicePixelRatio;
  }
}