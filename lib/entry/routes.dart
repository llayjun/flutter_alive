import 'package:app/ui/live/create_live_close.dart';
import 'package:app/ui/live/live_record_screen.dart';
import 'package:app/ui/live/live_video_play.dart';
import 'package:app/ui/mine/fans.dart';
import 'package:app/ui/mine/personal_homepage.dart';
import 'package:app/ui/mine/set_address.dart';
import 'package:app/ui/product/graphic_desc.dart';
import 'package:app/ui/product/product_detail.dart';
import 'package:app/ui/product/sku_edit.dart';
import 'package:app/ui/home/home.dart';
import 'package:app/ui/boot/boot.dart';
import 'package:app/ui/live/preview.dart';
import 'package:app/ui/login/login.dart';
import 'package:app/ui/mine/setting.dart';
import 'package:app/ui/mine/about_us.dart';
import 'package:app/ui/live/create.dart';
import 'package:app/ui/live/link_product.dart';
import 'package:app/ui/live/wx_code.dart';
import 'package:app/ui/live/list.dart';
import 'package:flutter/material.dart';


class Routes{
  Routes._();

  static const String boot = '/boot'; // 初始页
  static const String login = '/login'; // 登录
  static const String home = '/home'; // 首页


  /// 个人功能
  static const String personal_homepage = 'mine/personal-homepage'; // 个人主页
  static const String setting = 'mine/setting'; // 设置页
  static const String about_us = 'mine/about-us'; // 关于我们
  static const String fans = 'mine/fans'; // 粉丝列表

  /// 直播功能
  static const String live_create = 'live/create';// 创建直播
  static const String live_create_close = 'live/create/close';// 创建直播失败
  static const String live_edit = 'live/edit';// 编辑直播
  static const String live_create_link_product = 'live/create/link-product';// 直播关联商品
  static const String live_create_preview = 'live/create/preview';// 预览
  static const String live_create_wx_code = 'live/create/wx-code';// 创建成功小程序界面
  static const String live_list = 'live/list';// 直播列表
  static const String live_record_detail = 'live/record/detail'; // 直播结束后的回放详情界面
  static const String live_video_play = 'live/video/play'; // 播放器
  /// 暂时没做
  static const String live_detail = 'live/detail';// 直播详情

  /// 商品功能
  static const String product_sku_edit = 'product/sku-edit'; // 商品编辑（新增）sku页面
  static const String product_graphic_desc = 'product/graphic-desc'; // 商品图文描述


  static const String homeproduct_detail = 'product/product_detail';// webview

  /// 地址管理
  static const String address_set = 'mine/set_address';

  // 若要接受参数，请接受arguments
  static final routes = <String, Function>{
    boot: (BuildContext context) => BootScreen(),// 初始页
    login: (BuildContext context) => LoginScreen(),// 登录
    home: (BuildContext context) => HomeScreen(),// 首页


    personal_homepage: (BuildContext context) => PersonalHomepageScreen(), // 个人主页
    setting: (BuildContext context) => SettingScreen(),// 设置页
    about_us: (BuildContext context) => AboutUsScreen(),// 关于我们
    fans: (BuildContext context) => FansScreen(),// 粉丝列表

    live_create: (BuildContext context) => LiveCreateScreen(status: LiveCreateType.CREATE,),// 创建直播
    live_create_close: (BuildContext context, {arguments}) => CreateLiveCloseScreen(message: arguments['message'],),// 没有资格创建直播
    live_edit: (BuildContext context,{arguments}) => LiveCreateScreen(status: LiveCreateType.EDIT,id: arguments['id'],),// 编辑直播
    live_create_link_product: (BuildContext context, {arguments}) => LiveCreateLinkProductScreen(linkProductList:arguments['linkProductList']),// 直播关联商品
    live_create_preview: (BuildContext context, {arguments}) => LiveCreatePreviewScreen(arguments:arguments),// 预览
    live_create_wx_code: (BuildContext context, {arguments}) => LiveCreateWxCodeScreen(arguments:arguments),// 创建成功小程序界面
    live_list: (BuildContext context) => LiveListScreen(),// 直播列表
    live_record_detail: (BuildContext context, {arguments}) => LiveRecordScreen(id :arguments['id']),// 直播结束后的回放详情界面
    live_video_play: (BuildContext context, {arguments}) => LiveVideoPlay(url :arguments['url'], aspectRatio :arguments['aspectRatio'], lbId: arguments['lbId'],),// 播放器
    /// 暂时没做
    live_detail: (BuildContext context,{arguments}) => LiveCreateScreen(status: LiveCreateType.DETAIL,id: arguments['id'],),// 直播详情

    product_sku_edit: (BuildContext context,{arguments}) => ProductSkuEditScreen(id:arguments['id']),// 商品编辑（新增）sku页面
    product_graphic_desc: (BuildContext context,{arguments}) => ProductGraphicDescScreen(html:arguments['html']), // 商品图文描述

    homeproduct_detail: (BuildContext context,{arguments}) => ProductDetailPage(url:arguments['url']),// webview

    address_set: (BuildContext context,{arguments}) => SetAddressPage(),

  };

  static final whiteList = <String>[
    boot,
    login,
    home
  ];
}



