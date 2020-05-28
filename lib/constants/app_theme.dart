import 'dart:math';

import 'package:app/utils/no_splash_factory.dart';
/**
 * Creating custom color palettes is part of creating a custom app. The idea is to create
 * your class of custom colors, in this case `CompanyColors` and then create a `ThemeData`
 * object with those colors you just defined.
 *
 * Resource:
 * A good resource would be this website: http://mcg.mbitson.com/
 * You simply need to put in the colour you wish to use, and it will generate all shades
 * for you. Your primary colour will be the `500` value.
 *
 * Colour Creation:
 * In order to create the custom colours you need to create a `Map<int, Color>` object
 * which will have all the shade values. `const Color(0xFF...)` will be how you create
 * the colours. The six character hex code is what follows. If you wanted the colour
 * #114488 or #D39090 as primary colours in your theme, then you would have
 * `const Color(0x114488)` and `const Color(0xD39090)`, respectively.
 *
 * Usage:
 * In order to use this newly created theme or even the colours in it, you would just
 * `import` this file in your project, anywhere you needed it.
 * `import 'path/to/theme.dart';`
 */

import 'package:flutter/material.dart';



    // fontFamily: 'ProductSans',
    // brightness: Brightness.light,
    // primarySwatch: MaterialColor(
    //     AppColors.green[500].value, AppColors.green),
    // primaryColor: AppColors.green[500],
    // primaryColorBrightness: Brightness.light,
    // accentColor: AppColors.green[500],
    // accentColorBrightness: Brightness.light

final ThemeData themeData = new ThemeData(
  pageTransitionsTheme: PageTransitionsTheme(       // 页面切换效果，统一使用IOS风格的“左右切换”效果
    builders: <TargetPlatform, PageTransitionsBuilder>{
      TargetPlatform.android: CupertinoPageTransitionsBuilder(),
      TargetPlatform.iOS: CupertinoPageTransitionsBuilder()
    }
  ),
  scaffoldBackgroundColor: AppColors.greyF4,      // Scaffold背景色
  primaryColor: AppColors.primaryRed,             // 主要色
  primarySwatch: Colors.red,                      // 主题色

  // 可滚动区域边界的波浪颜色、checkbox默认颜色
  accentColor: AppColors.primaryRed,

  indicatorColor: AppColors.primaryRed,
  tabBarTheme: TabBarTheme(
    labelColor: AppColors.primaryRed,
    unselectedLabelColor: AppColors.black43,
    indicatorSize: TabBarIndicatorSize.label
  ),


  // 禁用“材质”，“波纹”效果
  // splashFactory: const NoSplashFactory(),



  // MaterialButton 聚焦效果
  highlightColor: Colors.transparent,
  splashColor: Colors.transparent,
  
  buttonTheme: ButtonThemeData(

    // FlatButton 聚焦效果
    highlightColor: Colors.transparent,
    splashColor: Colors.transparent
    
  ),


  appBarTheme: new AppBarTheme(               // AppBar主题
    brightness: Brightness.light,
    elevation: 0,
    color: Colors.white,

    iconTheme: IconThemeData(                 // 左上角icon样式
      size: 18.0,
      color: const Color(0xFF666666)
    ),

    textTheme: TextTheme(
      title: TextStyle(                       // 中间title样式
        color: const Color(0xFF333333),
        fontSize: 17.0,
        fontWeight: FontWeight.w500
      )
    )

  ),

  // dialogTheme: new DialogTheme(               // dialog主题
  //   backgroundColor: const Color(0xFF4B4B4B),
  //   elevation: 0,
  //   shape: RoundedRectangleBorder(
  //     side: BorderSide.none,
  //     borderRadius: BorderRadius.all(Radius.circular(5.0))
  //   ),
  //   contentTextStyle: TextStyle(
  //     color: Colors.white,
  //     fontSize: 16.0
  //   )
  // )
);



class AppColors {
  AppColors._(); // this basically makes it so you can instantiate this class

  static Color slRandomColor({int r = 255, int g = 255, int b = 255, a = 255}) {
    if (r == 0 || g == 0 || b == 0) return Colors.black;
    if (a == 0) return Colors.white;
    return Color.fromARGB(
      a,
      r != 255 ? r : Random.secure().nextInt(r),
      g != 255 ? g : Random.secure().nextInt(g),
      b != 255 ? b : Random.secure().nextInt(b),
    );
  }


  static const Color primaryRed = const Color(0xFFF95259);
  static const Color secondaryRed = const Color(0xFFFFD3D5);

  static const Color tipsBgRed = const Color(0xFFE85157);
  static const Color errorRed = const Color(0xFFE85359);

  static const Color disabledRed = const Color(0x66F95259);

  static const Color white = const Color(0xFFFFFFFF);
  static const Color yellow = const Color(0xFFFFDA8C);

  static const Color pink = const Color(0xFFFFC5B8);

  static const Color grey = const Color(0xFF626775);

  static const Color greyD8 = const Color(0xFFD8D8D8);
  static const Color greyF4 = const Color(0xFFF4F4F4);
  static const Color greyF3 = const Color(0xFFF3F3F3);
  static const Color grey4B = const Color(0xFF4B4B4B);
  static const Color greyEF = const Color(0xFFEFEFEF);
  static const Color greyF1 = const Color(0xFFF1F1F1);
  static const Color greyAF = const Color(0xFFAFAFAF);
  static const Color grey82 = const Color(0xFF828282);
  static const Color grey6D = const Color(0xFF6D6D6D);
  static const Color grey86 = const Color(0xFF868686);
  static const Color grey53 = const Color(0xFF535353);
  static const Color grey9C = const Color(0xFF9C9C9C);
  static const Color grey95 = const Color(0xFF959595);


  static const Color black = const Color(0xFF000000);
  static const Color black43 = const Color(0xFF434343);
  static const Color black333 = const Color(0xFF333333);
  static const Color black50000000 = const Color(0x50000000);
  static const Color black666 = const Color(0xFF666666);
  static const Color black999 = const Color(0xFF999999);

  // other color
  static const Color Color_F9515A = const Color(0xFFF9515A);
  static const Color Color_FDEAE4 = const Color(0xFFFDEAE4);
  static const Color Color_FC6737 = const Color(0xFFFC6737);
  static const Color Color_50000000 = const Color(0x50000000);
  static const Color Color_07020204 = const Color(0x07020204);
  static const Color Color_F63825 = const Color(0xFFF63825);
  static const Color Color_F0F0F0 = const Color(0xFFF0F0F0);
  static const Color Color_333333 = const Color(0xFF333333);
  static const Color Color_666666 = const Color(0xFF666666);
  static const Color Color_999999 = const Color(0xFF999999);
  static const Color Color_F2F2F2 = const Color(0xFFF2F2F2);
  // static const Map<int, Color> red = const <int, Color>{
  //   50: const Color(0xFFf2f8ef),
  //   100: const Color(0xFFdfedd8),
  //   200: const Color(0xFFc9e2be),
  //   300: const Color(0xFFb3d6a4),
  //   400: const Color(0xFFa3cd91),
  //   500: const Color(0xFF93c47d),
  //   600: const Color(0xFF8bbe75),
  //   700: const Color(0xFF80b66a),
  //   800: const Color(0xFF76af60),
  //   900: const Color(0xFF64a24d)
  // };
}