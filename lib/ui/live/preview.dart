import 'package:app/constants/app_theme.dart';
import 'package:app/constants/strings.dart';
import 'package:app/entry/routes.dart';
import 'package:app/models/dto/basic_dto.dart';
import 'package:app/models/vo/live/live_create_vo.dart';
import 'package:app/repository/channel_react.dart';
import 'package:app/repository/exception/network_exceptions.dart';
import 'package:app/services/live_service.dart';
import 'package:app/services/sys_service.dart';
import 'package:app/services/user_service.dart';
import 'package:app/utils/custom_toast.dart';
import 'package:app/utils/screen_adapter.dart';
import 'package:app/vmodel/user_info_vmodel.dart';
import 'package:app/widgets/common/loading_wrap_widget.dart';
import 'package:app/widgets/common/product_item_card_widget.dart';
import 'package:app/widgets/layout/column_flex_layout_widget.dart';
import 'package:app/widgets/overwrite/custom_app_bar_widget.dart';
import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:fluwx_no_pay/fluwx_no_pay.dart' as fluwx;

class LiveCreatePreviewScreen extends StatefulWidget {
  LiveCreatePreviewScreen({Key key, this.arguments}) : super(key: key);

  final Map arguments;

  @override
  _LiveCreatePreviewStatus createState() => _LiveCreatePreviewStatus();
}

class _LiveCreatePreviewStatus extends State<LiveCreatePreviewScreen> {
  final LiveService _liveService = LiveService();
  final SysService _sysService = SysService();
  final UserService _userService = UserService();

  bool _saving = false;

  void _handleShared() {
    // 这里分享按钮是假的，其实不需要触发事件
  }

  void _handleConfirmCreate() async {
//    bool check = await checkBindWeChat();
//    if (!check) {
//      return;
//    }

    setState(() {
      _saving = true;
    });
    try {
      LiveCreateVO info = widget.arguments['previewInfo'];
      Map<String, dynamic> map = info.toMap();

      /// 校验
      BasicDTO<dynamic> check =
          await _liveService.checkLiveBroadcast(Map<String, dynamic>());
      if (!check.success) {
        throw BizException(message: check.msg, statusCode: 200);
      }

      /// 保存封面图 16:9
      BasicDTO<dynamic> resultBannerCover =
          await _sysService.uploadFile(info.bannerCover);
      if (resultBannerCover.success) {
        map['bannerCover'] = resultBannerCover.data;
      } else {
        throw BizException(message: resultBannerCover.msg, statusCode: 200);
      }

      /// 保存封面图 9:16
      BasicDTO<dynamic> resultVerticalCover =
      await _sysService.uploadFile(info.verticalCover);
      if (resultVerticalCover.success) {
        map['verticalCover'] = resultVerticalCover.data;
      } else {
        throw BizException(message: resultVerticalCover.msg, statusCode: 200);
      }

      /// 保存封面图 1:1
      BasicDTO<dynamic> resultSquareCover =
          await _sysService.uploadFile(info.squareCover);
      if (resultSquareCover.success) {
        map['squareCover'] = resultSquareCover.data;
      } else {
        throw BizException(message: resultSquareCover.msg, statusCode: 200);
      }

      /// 商品信息序列化
      List<Map<String, dynamic>> products =
          info.products.map((i) => i.toJson()).toList();
      map['products'] = products;

      /// 时间格式化
      String dataTime = DateUtil.formatDateMs(
        info.beginTime.millisecondsSinceEpoch,
        format: DataFormats.full,
      );
      map['beginTime'] = dataTime;
      map['endTime'] = dataTime;

      /// 保存
      BasicDTO<dynamic> result = await _liveService.addLiveBroadcast(map);
      if (result.success) {
        Navigator.of(context).pushNamedAndRemoveUntil(
          Routes.live_create_wx_code,
          (Route<dynamic> route) {
            if (route.settings.name == Routes.home) {
              return true;
            }
            return false;
          },
          arguments: result.data,
        );
      } else {
        throw BizException(message: result.msg, statusCode: 200);
      }
    } catch (e) {
      CustomToast.showToast(msg: e.toString(), gravity: ToastGravity.CENTER);
      setState(() {
        _saving = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    final LiveCreateVO info = widget.arguments['previewInfo'];

    return Scaffold(
      appBar: CustomAppBar(
        title: Text(Strings.title_live_preview),
      ),
      body: LoadingWrap(
        saving: _saving,
        savingTips: '生成中...',
        child: ColumnFlexLayout(
          body: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Image(
                  width: ScreenAdapter.width(),
                  height: ScreenAdapter.height(210.0),
                  image: FileImage(info.bannerCover),
                  fit: BoxFit.cover,
                ),
                Container(
                  color: AppColors.white,
                  padding: EdgeInsets.only(
                    top: ScreenAdapter.width(10.0),
                    left: ScreenAdapter.width(12.0),
                    bottom: ScreenAdapter.width(13.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: Text(
                              info.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: ScreenAdapter.fontSize(20.0),
                                fontWeight: FontWeight.w500,
                                color: AppColors.black43,
                              ),
                            ),
                          ),
                          // Container(
                          //   width: ScreenAdapter.width(48.0),
                          //   alignment: Alignment.center,
                          //   padding: EdgeInsets.only(
                          //     top: ScreenAdapter.height(4.0),
                          //   ),
                          //   child: FlatButton(
                          //     padding: EdgeInsets.all(0.0),
                          //     child: Column(
                          //       mainAxisAlignment: MainAxisAlignment.center,
                          //       crossAxisAlignment: CrossAxisAlignment.center,
                          //       children: <Widget>[
                          //         Icon(
                          //           IconFont.share,
                          //           color: AppColors.primaryRed,
                          //           size: ScreenAdapter.fontSize(18.0),
                          //         ),
                          //         Text(
                          //           Strings.live_create_preview_et_share,
                          //           style: TextStyle(
                          //             color: AppColors.black666,
                          //             fontSize: ScreenAdapter.fontSize(12.0),
                          //             fontWeight: FontWeight.w500,
                          //             height: 33 / 24,
                          //           ),
                          //         )
                          //       ],
                          //     ),
                          //     onPressed: _handleShared,
                          //   ),
                          // ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          top: ScreenAdapter.height(8.0),
                          bottom: ScreenAdapter.height(8.0),
                        ),
                        child: Row(
                          children: <Widget>[
                            ClipOval(
                              child: Image(
                                width: ScreenAdapter.width(25.0),
                                height: ScreenAdapter.width(25.0),
                                fit: BoxFit.cover,
                                image: NetworkImage(
                                  Provider.of<UserInfoVModel>(context)
                                      .userInfo
                                      .headerImg,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                left: ScreenAdapter.width(6.0),
                              ),
                              child: Text(
                                '${Provider.of<UserInfoVModel>(context).userInfo.shopName}',
                                style: TextStyle(
                                  color: AppColors.black666,
                                  fontSize: ScreenAdapter.fontSize(14.0),
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        info.description,
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: ScreenAdapter.fontSize(13.0),
                          color: AppColors.black999,
                          fontWeight: FontWeight.w400,
                          height: 30 / 26,
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.only(
                    top: ScreenAdapter.height(17.0),
                    left: ScreenAdapter.width(12.0),
                    right: ScreenAdapter.width(12.0),
                    bottom: ScreenAdapter.height(17.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        Strings.live_create_preview_et_product_title,
                        style: TextStyle(
                          fontSize: ScreenAdapter.fontSize(20.0),
                          color: AppColors.black43,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(
                        height: ScreenAdapter.height(12.0),
                      ),
                      Wrap(
                        spacing: ScreenAdapter.width(11.0),
                        runSpacing: ScreenAdapter.height(11.0),
                        children: info.products.map((pItem) {
                          return ProductItemCard(
                            backgroundColor: AppColors.white,
                            textPadding: true,
                            fillHeight: true,
                            width: ScreenAdapter.width(170.0),
                            image: pItem.img,
                            name: pItem.name,
                            price: pItem.price,
                            originPrice: pItem.originPrice,
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          bottom: MaterialButton(
            minWidth: double.infinity,
            height: ScreenAdapter.height(49.0),
            color: AppColors.primaryRed,
            child: Text(
              '确认，生成小程序码',
              style: TextStyle(
                fontSize: ScreenAdapter.fontSize(14.0),
                color: AppColors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
            onPressed: _handleConfirmCreate,
          ),
        ),
      ),
    );
  }
}
