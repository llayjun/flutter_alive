import 'dart:io';

import 'package:app/constants/app_theme.dart';
import 'package:app/constants/strings.dart';
import 'package:app/models/dto/basic_dto.dart';
import 'package:app/models/dto/sys/file_dto.dart';
import 'package:app/models/vo/live/live_create_vo.dart';
import 'package:app/entry/routes.dart';
import 'package:app/services/live_service.dart';
import 'package:app/services/sys_service.dart';
import 'package:app/utils/custom_toast.dart';
import 'package:app/utils/screen_adapter.dart';
import 'package:app/widgets/common/loading_wrap_widget.dart';
import 'package:app/widgets/layout/action_box_widget.dart';
import 'package:app/widgets/layout/action_row_widget.dart';
import 'package:app/widgets/layout/column_flex_layout_widget.dart';
import 'package:app/widgets/overwrite/custom_app_bar_widget.dart';
import 'package:app/widgets/form/image_capture_widget.dart';
import 'package:app/widgets/form/input_row_widget.dart';
import 'package:app/widgets/common/modal_popup_wrap_widget.dart';
import 'package:common_utils/common_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:fluttertoast/fluttertoast.dart';

enum LiveCreateType { EDIT, CREATE, DETAIL }

/// 可以选择之后多少天之内的时间
const _maxAfterDay = 2 * 7; // 两周

class LiveCreateScreen extends StatefulWidget {
  LiveCreateScreen({Key key, this.status = LiveCreateType.CREATE, this.id});

  final LiveCreateType status;
  final String id;

  @override
  _LiveCreateState createState() => _LiveCreateState();
}

class _LiveCreateState extends State<LiveCreateScreen> {
  final LiveService _liveService = LiveService();
  final SysService _sysService = SysService();

  LiveCreateVO formData = LiveCreateVO();

  /// 线上封面图本地缓存地址
  File _bannerCoverCache;
  File _squareCoverCache;
  File _verticalCoverCache;

  /// 线上封面图
  FileDTO _bannerCover;
  FileDTO _squareCover;
  FileDTO _verticalCover;

  DateTime _scrollDate;

  bool _loading = false;
  bool _saving = false;

  TextEditingController _titleEditController = new TextEditingController();
  TextEditingController _descEditController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    _titleEditController.addListener(() {
      formData.title = _titleEditController.text;
    });
    _descEditController.addListener(() {
      formData.description = _descEditController.text;
    });
    if (widget.status == LiveCreateType.EDIT ||
        widget.status == LiveCreateType.DETAIL) {
      _init();
    }
  }

  void _init() async {
    setState(() {
      _loading = true;
    });

    var result = await _liveService.getLiveBroadcastDetail(widget.id);
    print('~~~~~~~~~~ ${result}');
    var cacheManager = DefaultCacheManager();
    File _bannerCoverFile =
        await cacheManager.getSingleFile(result.bannerCover.url);
    File _verticalCoverFile =
        await cacheManager.getSingleFile(result.verticalCover.url);
    File _squareCoverFile =
        await cacheManager.getSingleFile(result.squareCover.url);

    /// 线上封面图本地缓存地址
    _bannerCoverCache = _bannerCoverFile;
    _verticalCoverCache = _verticalCoverFile;
    _squareCoverCache = _squareCoverFile;

    /// 线上封面图
    _bannerCover = result.bannerCover;
    _squareCover = result.squareCover;
    _verticalCover = result.verticalCover;

    formData = LiveCreateVO(
      id: result.id,
      title: result.title,
      description: result.description,
      beginTime: DateUtil.getDateTime(result.beginTime),
      bannerCover: _bannerCoverFile,
      verticalCover: _verticalCoverCache,
      squareCover: _squareCoverCache,
      products: (result.products ?? []).map((item) {
        return item.toVO(true);
      }).toList(),
    );
    setState(() {
      _loading = false;
    });
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is removed from the Widget tree
    _titleEditController.dispose();
    _descEditController.dispose();
    super.dispose();
  }

  String get title {
    switch (widget.status) {
      case LiveCreateType.CREATE:
        return Strings.title_create_live;
      case LiveCreateType.EDIT:
        return Strings.title_edit_live;
      case LiveCreateType.DETAIL:
        return Strings.title_edit_live;
      default:
        return '';
    }
  }

  String get btnText {
    switch (widget.status) {
      case LiveCreateType.CREATE:
        return Strings.live_create_et_create_preview_btn;
      case LiveCreateType.EDIT:
        return Strings.live_create_et_save_edit_btn;
      case LiveCreateType.DETAIL:
      default:
        return "";
    }
  }

  void _createPreview() {
    if (formData.validate.isNotEmpty) {
      CustomToast.showToast(msg: formData.validate, gravity: ToastGravity.CENTER );
      return;
    }
    Navigator.of(context).pushNamed(
      Routes.live_create_preview,
      arguments: {'previewInfo': formData},
    );
  }

  void _commitEdit() async {
    if (formData.validate.isNotEmpty) {
      CustomToast.showToast(msg: formData.validate, gravity: ToastGravity.CENTER);
      return;
    }
    setState(() {
      _saving = true;
    });

    try {
      LiveCreateVO info = formData;
      Map<String, dynamic> map = info.toMap();

      /// 校验
      BasicDTO<dynamic> check =
          await _liveService.checkLiveBroadcast({"id": widget.id});
      if (!check.success) {
        throw Exception(check.msg);
      }

      /// 保存封面图 16:9 如果更改则重新上传 否则还用原来的图片
      if (_bannerCoverCache == null ||
          (_bannerCoverCache != null &&
              info.bannerCover != null &&
              info.bannerCover.path != _bannerCoverCache.path)) {
        BasicDTO<dynamic> resultBannerCover =
            await _sysService.uploadFile(info.bannerCover);
        if (resultBannerCover.success) {
          map['bannerCover'] = resultBannerCover.data;
        } else {
          throw Exception(resultBannerCover.msg);
        }
      } else {
        map['bannerCover'] = _bannerCover.toJson();
      }

      /// 保存封面图 9:16 如果更改则重新上传 否则还用原来的图片
      if (_verticalCoverCache == null ||
          (_verticalCoverCache != null &&
              info.verticalCover != null &&
              info.verticalCover.path != _verticalCoverCache.path)) {
        BasicDTO<dynamic> resultSquareCover =
        await _sysService.uploadFile(info.verticalCover);
        if (resultSquareCover.success) {
          map['verticalCover'] = resultSquareCover.data;
        } else {
          throw Exception(resultSquareCover.msg);
        }
      } else {
        map['verticalCover'] = _verticalCover.toJson();
      }

      /// 保存封面图 9:16 如果更改则重新上传 否则还用原来的图片
      if (_squareCoverCache == null ||
          (_squareCoverCache != null &&
              info.squareCover != null &&
              info.squareCover.path != _squareCoverCache.path)) {
        BasicDTO<dynamic> resultSquareCover =
            await _sysService.uploadFile(info.squareCover);
        if (resultSquareCover.success) {
          map['squareCover'] = resultSquareCover.data;
        } else {
          throw Exception(resultSquareCover.msg);
        }
      } else {
        map['squareCover'] = _squareCover.toJson();
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
      BasicDTO<dynamic> result =
          await _liveService.editLiveBroadcastDetail(widget.id, map);
      if (result.success) {
        Navigator.of(context).pushNamedAndRemoveUntil(Routes.live_list, ModalRoute.withName(Routes.home));
      } else {
        throw Exception(result.msg);
      }
    } catch (e) {
      CustomToast.showToast(msg: e.toString(), gravity: ToastGravity.CENTER);
      setState(() {
        _saving = false;
      });
    }
  }

  void _submit() {
    switch (widget.status) {
      case LiveCreateType.CREATE:
        _createPreview();
        break;
      case LiveCreateType.EDIT:
        _commitEdit();
        break;
      case LiveCreateType.DETAIL:
        break;
    }
  }

  void _showDatePickerModal() {
    /// 注意：
    ///   当[initialDateTime]设置的时间不在[minimumDate]和[maximumDate]之内时，会报错
    ///   当前情况下，只有处于"未开始"状态的直播可以被编辑，而该种状态的直播的开始时间[beginTime]肯定在[minimumDate]之后，故不会有问题
    ///   但若需求改动，不止"未开始"状态的直播可以被编辑的话，这边的[minimumDate]还需要判断[initialDateTime]来设置
    DateTime _now = DateTime.now();
    DateTime _initialDateTime =
        formData.beginTime != null ? formData.beginTime : _now;

    /// 今天的零点零分，如果不是零点零分，今天就会选不了
    DateTime _minimumDate = _now.subtract(
      Duration(
        hours: _now.hour,
        minutes: _now.minute,
        seconds: _now.second,
        milliseconds: _now.millisecond,
        microseconds: _now.microsecond,
      ),
    );

    /// 目标天数后的那天的23:59:59:999
    DateTime _maximumDate = _minimumDate
        .add(Duration(days: _maxAfterDay + 1))
        .subtract(Duration(microseconds: 1));

    showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return ModalPopupWrap(
          height: 250.0,
          title: '选择日期',
          child: CupertinoDatePicker(
            /// 设置"可滚动"区域，只能滚动选择"今天"到"两周后"
            minimumDate: _minimumDate,
            maximumDate: _maximumDate,
            initialDateTime: _initialDateTime,
            mode: CupertinoDatePickerMode.dateAndTime,
            use24hFormat: false,
            onDateTimeChanged: (value) {
              if (value == null) {
                return;
              }
              _scrollDate = value;
            },
          ),
          onConfirm: () {
            DateTime _now = DateTime.now();
            DateTime _newDate = _scrollDate ?? _initialDateTime;

            /// "可滚动"的区域不代表"可选择"区域（时效性）
            /// 点确定的时候再判断所选时间在"这一刻"是否为合法的
            if (_newDate.isBefore(_now) ||
                _newDate.isAfter(_now.add(Duration(days: _maxAfterDay)))) {
              CustomToast.showToast(msg: '只能选择现在到未来两周的时间之内', gravity: ToastGravity.CENTER);
              return;
            }
            setState(() {
              formData.beginTime = _newDate;
            });
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  String get _formattedLiveDate {
    if (formData.beginTime == null) {
      return null;
    }
    return DateUtil.formatDate(formData.beginTime, format: 'yyyy-MM-dd HH:mm');
  }

  Widget _boxBuild(
    List<Widget> children, {
    double left = 12.0,
    double top = 0,
    double right = 12.0,
    double bottom = 0,
  }) {
    return Container(
      child: Container(
        padding: EdgeInsets.only(
          left: left,
          right: left,
          top: top,
          bottom: bottom,
        ),
        color: AppColors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        appBar: CustomAppBar(
          title: Text(title),
        ),
        body: LoadingWrap(
          loading: _loading,
          saving: _saving,
          child: ColumnFlexLayout(
            body: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  // 上传图片
                  Container(
                    color: AppColors.white,
                    width: double.infinity,
                    padding: EdgeInsets.only(top: ScreenAdapter.height(15.0), left: ScreenAdapter.width(15.0), bottom: ScreenAdapter.height(15.0)),
                    alignment: Alignment.topLeft,
                    child: Column(
                      children: <Widget>[
                        Container(
                          width: ScreenAdapter.width(165.0),
                          height: ScreenAdapter.width(165.0),
                          child: ImageCapture(
                            tips: '点击上传封面图',
                            initImg: formData.squareCover,
                            widthScale: 1,
                            heightScale: 1,
                            onChange: (imageFile) {
                              formData.squareCover = imageFile;
                              formData.bannerCover = imageFile;
                            },
                            onSecondChange: (imageFile) {
                              formData.verticalCover = imageFile;
                            },
                          ),
                        ),
                        SizedBox(height: ScreenAdapter.height(15.0),),
                        Text("添加后，可点击图片进行微调", style: TextStyle(fontSize: ScreenAdapter.fontSize(14.0), color: AppColors.black999),)
                      ],
                    ),
                  ),

                  // 基本信息
                  ActionBox(
                    boxGap: EdgeInsets.only(top: 10.0),
                    children: <Widget>[
                      // 直播标题
                      InputRow(
                        initValue: formData.title,
                        controller: _titleEditController,
                        label: Strings.live_create_form_title_label,
                        decoration: InputDecoration(
                          hintText: Strings.live_create_form_title_placeholder,
                        ),
                        keyboardType: TextInputType.text,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(20),
                        ],
                      ),

                      //直播时间
                      ActionRow(
                        title: Strings.live_create_form_time_label,
                        titleSize: 17.0,
                        tips: _formattedLiveDate ??
                            Strings.live_create_form_time_tips,
                        onPressed: _showDatePickerModal,
                      ),

                      // 内容介绍
                      InputRow(
                        initValue: formData.description,
                        controller: _descEditController,
                        minLines: 5,
                        maxLines: 5,
                        labelPosition: LabelPosition.top,
                        label: Strings.live_create_form_desc_label,
                        decoration: InputDecoration(
                          hintText: Strings.live_create_form_desc_placeholder,
                        ),
                        keyboardType: TextInputType.multiline,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(200)
                        ],
                      ),
                    ],
                  ),

                  ActionBox(
                    boxGap: EdgeInsets.only(top: 10.0),
                    children: <Widget>[
                      // 关联产品
                      ActionRow(
                        title: Strings.live_create_form_link_product_label,
                        titleSize: 17.0,
                        rightChild: Padding(
                          padding: EdgeInsets.only(right: 10.0),
                          child: Container(
                            padding: EdgeInsets.only(
                              right: 13.0,
                              left: 13.0,
                            ),
                            height: 22.0,
                            decoration: BoxDecoration(
                              color: AppColors.primaryRed,
                              borderRadius: BorderRadius.all(
                                Radius.circular(11.0),
                              ),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              '${formData.products.length}',
                              style: TextStyle(
                                fontSize: 14.0,
                                color: AppColors.white,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).pushNamed(
                            Routes.live_create_link_product,
                            arguments: {'linkProductList': formData.products},
                          ).then((result) {
                            if (result == null) {
                              return;
                            }
                            setState(() {
                              formData.products = result;
                            });
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            bottom: MaterialButton(
              minWidth: MediaQuery.of(context).size.width,
              height: ScreenAdapter.height(49.0),
              color: AppColors.primaryRed,
              child: Text(
                btnText,
                style: TextStyle(
                  fontSize: 14.0,
                  color: AppColors.white,
                ),
              ),
              onPressed:
                  widget.status == LiveCreateType.DETAIL ? null : _submit,
            ),
          ),
        ),
      ),
    );
  }
}
