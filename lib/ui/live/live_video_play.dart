import 'dart:typed_data';

import 'package:app/constants/app_theme.dart';
import 'package:app/constants/images.dart';
import 'package:app/constants/strings.dart';
import 'package:app/entry/config.dart';
import 'package:app/models/dto/live/live_chat_record_dto.dart';
import 'package:app/models/dto/live/live_record_live_info_dto.dart';
import 'package:app/models/dto/live/live_record_product_dto.dart';
import 'package:app/services/live_service.dart';
import 'package:app/utils/custom_toast.dart';
import 'package:app/utils/screen_adapter.dart';
import 'package:chewie/chewie.dart';
import 'package:common_utils/common_utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fluwx_no_pay/fluwx_no_pay.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:video_player/video_player.dart';

import 'widget/custom_material_controls.dart';

class LiveVideoPlay extends StatefulWidget {
  String url;
  num aspectRatio;
  String lbId;

  LiveVideoPlay({Key key, this.url, this.aspectRatio, this.lbId})
      : super(key: key);

  @override
  _LiveVideoPlayState createState() =>
      _LiveVideoPlayState(this.url, this.aspectRatio, this.lbId);
}

class _LiveVideoPlayState extends State<LiveVideoPlay>
    with SingleTickerProviderStateMixin {
  LiveService _liveService = LiveService();

  String url;
  num aspectRatio;
  String lbId;

  _LiveVideoPlayState(this.url, this.aspectRatio, this.lbId);

  TabController mController;

  VideoPlayerController videoPlayerController;
  ChewieController chewieController;
  LiveRecordLiveInfoDTO _liveRecordLiveInfoDTO;

  /// 直播详情
  List<LiveChatRecordDTO> _liveRecordChatList = [];

  /// 聊天记录100条

  // 数量
  int _onSellNum = 0;
  int _onPendingNum = 0;

  @override
  void initState() {
    super.initState();
    mController = TabController(
      length: 2,
      vsync: this,
    );
//配置视频地址
    videoPlayerController = VideoPlayerController.network(url);
    chewieController = ChewieController(
      allowedScreenSleep: false,
      videoPlayerController: videoPlayerController,
      allowFullScreen: false,
      aspectRatio: aspectRatio ?? 9 / 16,
      //宽高比
      autoPlay: true,
      //自动播放
      looping: true,
//      showControls: true,
      // 占位图
      showControls: true,
      customControls: MaterialControls(),
      placeholder: new Container(
        color: Colors.grey,
      ),
      // 拖动条样式颜色
      materialProgressColors: new ChewieProgressColors(
        playedColor: Colors.red,
        handleColor: Colors.white,
        backgroundColor: Colors.grey,
        bufferedColor: Colors.white10,
      ),
    );
    _init();
    _initFluwx();
  }

  void _init() async {
    _liveRecordLiveInfoDTO = await _liveService.getRecordLiveInfo(widget?.lbId);
    _liveRecordLiveInfoDTO?.products?.forEach((item) {
      if (item.status == "ON_SELL") {
        _onSellNum++;
      } else if (item.status == "PENDING") {
        _onPendingNum++;
      }
    });
    List<LiveChatRecordDTO> list = await _liveService.getChatList100(
        _liveRecordLiveInfoDTO?.id, _liveRecordLiveInfoDTO?.title);
    list.forEach((item) {
      if(item.type == "chat") {
        _liveRecordChatList.add(item);
      }
    });
    setState(() {});
  }

  bool result = false;

  _initFluwx() async {
    await registerWxApi(
        appId: "wxfd04e16c3e6972d7",
        doOnAndroid: true,
        doOnIOS: true,
        universalLink: "https://linkurl.9daye.com.cn/");
    result = await isWeChatInstalled;
    print("is installed $result");
  }

  // 数据接收
  void _onEvent(Object value) {
    LogUtil.e("share_info" + value.toString());
    if (result) {
      Map myMap = value;
      WeChatScene scene = WeChatScene.SESSION;
      String _webPageUrl = "http://";
      String _thumbnail = myMap['url'];
      String _title = myMap['name'];
      String _userName = Config.inst.miniUsername;
      String _path = "/pages/live/detail/detail?roomId=${myMap['fileId']}";
      String _description = myMap['description'];

      var model = new WeChatShareMiniProgramModel(
          webPageUrl: _webPageUrl,
          userName: _userName,
          title: _title,
          path: _path,
          description: _description,
          thumbnail: WeChatImage.network(_thumbnail));
      shareToWeChat(model);
    } else {
      CustomToast.showToast(msg: "抱歉！暂无分享渠道", gravity: ToastGravity.CENTER);
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget _productWidget = Container(
      child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10), topRight: Radius.circular(10)),
              color: AppColors.white),
          height: ScreenAdapter.height(408.0),
          child: Column(
            children: <Widget>[
              Container(
                alignment: Alignment.centerLeft,
                height: ScreenAdapter.height(40.0),
                child: TabBar(
                  indicatorSize: TabBarIndicatorSize.label,
                  controller: mController,
                  labelColor: AppColors.primaryRed,
                  labelStyle: TextStyle(fontSize: ScreenAdapter.fontSize(15.0)),
                  isScrollable: true,
                  indicatorColor: AppColors.primaryRed,
                  unselectedLabelColor: AppColors.black666,
                  tabs: <Widget>[
                    new Text('已上架${_onSellNum == 0 ? "" : '($_onSellNum)'}'),
                    new Text(
                        '未上架${_onPendingNum == 0 ? "" : '($_onPendingNum)'}'),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  physics: NeverScrollableScrollPhysics(),
                  controller: mController,
                  children: <Widget>[
                    ProductInfo(
                      lbId: lbId,
                      productType: ProductType.ONSELL,
                    ),
                    ProductInfo(
                      lbId: lbId,
                      productType: ProductType.PENDING,
                    ),
                  ],
                ),
              )
            ],
          )),
    );

    return Scaffold(
        backgroundColor: AppColors.white,
        body: Container(
          child: Stack(
            children: <Widget>[
              Chewie(
                controller: chewieController,
              ),
              Positioned(
                top: ScreenAdapter.height(30.0),
                child: IconButton(
                  iconSize:
                  Theme.of(context).appBarTheme.iconTheme.size,
                  icon: Image.asset(Images.icon_boardback),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              Positioned(
                  bottom: ScreenAdapter.height(47.0)+MediaQuery.of(context).padding.bottom,
                  left: 0,
                  right: 0,
                  child: Container(
                    color: AppColors.black.withOpacity(0.6),
                    padding: EdgeInsets.only(
                        left: ScreenAdapter.width(15.0),
                        right: ScreenAdapter.width(15.0)),
                    height: ScreenAdapter.height(60.0),
                    child: Row(
                      children: <Widget>[
                        InkWell(
                          child: Stack(
                            alignment: Alignment.center,
                            children: <Widget>[
                              Image.asset(
                                Images.icon_record_package,
                                width: ScreenAdapter.width(40.0),
                                height: ScreenAdapter.height(45.0),
                              ),
                              Positioned(
                                bottom: ScreenAdapter.height(10.0),
                                child: Text(
                                  '${_liveRecordLiveInfoDTO != null ? _liveRecordLiveInfoDTO?.products?.length : 0}',
                                  style: TextStyle(
                                      fontSize:
                                      ScreenAdapter.fontSize(15.0),
                                      color: AppColors.white),
                                ),
                              )
                            ],
                          ),
                          onTap: () {
                            showModalBottomSheet(
                                context: context,
                                builder: (BuildContext context) {
                                  return _productWidget;
                                });
                          },
                        ),
                        VerticalDivider(
                          width: ScreenAdapter.width(12.0),
                          color: Colors.transparent,
                        ),
                        InkWell(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Image.asset(
                                Images.icon_record_share,
                                width: ScreenAdapter.width(33.0),
                                height: ScreenAdapter.height(33.0),
                              ),
                              Text(
                                "分享",
                                style: TextStyle(
                                    fontSize:
                                    ScreenAdapter.fontSize(12.0),
                                    color: AppColors.white),
                              )
                            ],
                          ),
                          onTap: () {
                            showModalBottomSheet(
                                context: context,
                                builder: (BuildContext context1) {
                                  return Container(
                                    height: ScreenAdapter.height(220.0),
                                    child: Column(
                                      children: <Widget>[
                                        Container(
                                          padding: EdgeInsets.only(
                                              left: ScreenAdapter.width(
                                                  12.0),
                                              top: ScreenAdapter.height(
                                                  8.0),
                                              bottom:
                                              ScreenAdapter.height(
                                                  8.0)),
                                          child: Text(
                                            "分享",
                                            style: TextStyle(
                                                fontSize: ScreenAdapter
                                                    .fontSize(17.0),
                                                color:
                                                AppColors.black333),
                                          ),
                                          alignment:
                                          Alignment.centerLeft,
                                          color: AppColors.greyF4,
                                        ),
                                        Expanded(
                                          child: Row(
                                            children: <Widget>[
                                              _shareItem(
                                                  "分享链接",
                                                  Images
                                                      .icon_link_share,
                                                      () {
                                                    Map map = {
                                                      "url":
                                                      "${_liveRecordLiveInfoDTO?.squareCover?.url}",
                                                      "name":
                                                      "${_liveRecordLiveInfoDTO?.title?.toString()}",
                                                      "fileId":
                                                      "${_liveRecordLiveInfoDTO?.squareCover?.fileId}",
                                                      "description":
                                                      "${_liveRecordLiveInfoDTO?.description?.toString()}"
                                                    };
                                                    _onEvent(map);
                                                    Navigator.pop(context1);
                                                  }),
                                              _shareItem("分享图片",
                                                  Images.icon_pic_share,
                                                      () {
                                                    Navigator.pop(context1);
                                                    _showSavePicDialog(
                                                        context,
                                                        "${_liveRecordLiveInfoDTO?.sharePosterLive}");
                                                  }),
                                            ],
                                            mainAxisAlignment:
                                            MainAxisAlignment
                                                .spaceEvenly,
                                            crossAxisAlignment:
                                            CrossAxisAlignment
                                                .center,
                                          ),
                                        ),
                                        InkWell(
                                            onTap: () {
                                              Navigator.pop(context1);
                                            },
                                            child: Container(
                                              child: Text(
                                                "取消",
                                                style: TextStyle(
                                                    fontSize:
                                                    ScreenAdapter
                                                        .fontSize(
                                                        14.0),
                                                    color: AppColors
                                                        .black333),
                                              ),
                                              padding: EdgeInsets.only(
                                                  top: ScreenAdapter
                                                      .height(15.0),
                                                  bottom: ScreenAdapter
                                                      .height(15.0)),
                                              alignment:
                                              Alignment.center,
                                              color: AppColors.greyF4,
                                            ))
                                      ],
                                    ),
                                  );
                                });
                          },
                        ),
                      ],
                    ),
                  )),
              Positioned(
                bottom: ScreenAdapter.height(180.0)+MediaQuery.of(context).padding.bottom,
                child: Container(
                  padding: EdgeInsetsDirectional.only(
                    start: ScreenAdapter.width(20.0),
                  ),
                  width: ScreenAdapter.width(200.0),
                  height: ScreenAdapter.height(200.0),
                  child: ListView.separated(
                    itemBuilder: (context, index) => Container(
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius:
                              BorderRadius.all(Radius.circular(1)),
                              color: AppColors.Color_07020204),
                          padding: EdgeInsets.only(
                              left: ScreenAdapter.width(3.0),
                              right: ScreenAdapter.width(3.0),
                              top: ScreenAdapter.height(3.0),
                              bottom: ScreenAdapter.height(3.0)),
                          child: Row(
                            children: <Widget>[
                              Text(
                                "${_liveRecordChatList[index].user}",
                                style: TextStyle(
                                    fontSize: ScreenAdapter.fontSize(12.0),
                                    color: AppColors.slRandomColor()),
                              ),
                              SizedBox(
                                width: ScreenAdapter.width(12),
                              ),
                              Expanded(
                                child: Text(
                                  "${_liveRecordChatList[index].message}",
                                  style: TextStyle(
                                      fontSize:
                                      ScreenAdapter.fontSize(12.0),
                                      color: AppColors.white),
                                ),
                              )
                            ],
                          ),
                        )),
                    itemCount: _liveRecordChatList?.length,
                    separatorBuilder:
                        (BuildContext context, int index) {
                      return SizedBox(
                        height: ScreenAdapter.height(3.0),
                      );
                    },
                  ),
                ),
              )
            ],
          ),
        ));
  }

  @override
  void dispose() {
    /**
     * 当页面销毁的时候，将视频播放器也销毁
     * 否则，当页面销毁后会继续播放视频！
     */
    videoPlayerController.dispose();
    chewieController.dispose();
    mController.dispose();
    super.dispose();
  }
}

class ProductInfo extends StatefulWidget {
  ProductType productType;
  String lbId;

  ProductInfo({
    Key key,
    this.lbId,
    this.productType,
  }) : super(key: key);

  @override
  _ProductInfoState createState() =>
      _ProductInfoState(productType: this.productType);
}

class _ProductInfoState extends State<ProductInfo>
    with AutomaticKeepAliveClientMixin {
  ProductType productType;
  LiveService _liveService = LiveService();
  List<LiveRecordProductDTO> productList = [];

  _ProductInfoState({this.productType});

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _init();
  }

  void _init() async {
    switch (productType) {
      case ProductType.ONSELL:
        productList =
            await _liveService.getRecordProductList(widget?.lbId, "ON_SELL");
        break;
      case ProductType.PENDING:
        productList =
            await _liveService.getRecordProductList(widget?.lbId, "PENDING");
        break;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.separated(
        itemBuilder: _itemBuilder,
        itemCount: productList?.length,
        separatorBuilder: (BuildContext context, int index) {
          return Padding(
            padding: EdgeInsets.only(
                left: ScreenAdapter.width(12.0),
                right: ScreenAdapter.width(12.0)),
            child: Divider(
              height: ScreenAdapter.height(0.5),
              color: AppColors.Color_F0F0F0,
            ),
          );
        },
      ),
    );
  }

  Widget _itemBuilder(BuildContext context, int index) {
    return Container(
      color: AppColors.white,
      height: ScreenAdapter.height(100.0),
      padding: EdgeInsets.all(ScreenAdapter.width(12.0)),
      child: Row(
        children: <Widget>[
          Image.network(
            productList[index]?.img,
            width: ScreenAdapter.width(70.0),
            fit: BoxFit.fitWidth,
          ),
          VerticalDivider(
            width: ScreenAdapter.width(15.0),
            color: Colors.transparent,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  '${productList[index]?.name}',
                  style: TextStyle(
                      color: AppColors.black333,
                      fontSize: ScreenAdapter.fontSize(15.0)),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  "库存：'${productList[index]?.totalStockNum}  销量：'${productList[index]?.saleAmount}",
                  style: TextStyle(
                      color: AppColors.black999,
                      fontSize: ScreenAdapter.fontSize(12.0)),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  "¥${productList[index]?.price}",
                  style: TextStyle(
                      color: AppColors.Color_F63825,
                      fontSize: ScreenAdapter.fontSize(14.0)),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

enum ProductType { ONSELL, PENDING }

Widget _shareItem(String title, String image, Function call) {
  return InkWell(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Image.asset(
          image,
          width: ScreenAdapter.width(50),
          height: ScreenAdapter.width(50),
        ),
        SizedBox(
          height: ScreenAdapter.height(10.0),
        ),
        Text(
          title,
          style: TextStyle(
              color: AppColors.black333,
              fontSize: ScreenAdapter.fontSize(14.0)),
        ),
      ],
    ),
    onTap: call,
  );
}

Future<Widget> _showSavePicDialog(BuildContext context, String url) {
  return showDialog(
      // 传入 context
      context: context,
      // 构建 Dialog 的视图
      builder: (_) => Container(
            alignment: Alignment.center,
            child: Column(
              children: <Widget>[
                ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      url,
                      width: ScreenAdapter.width(290.0),
                      height: ScreenAdapter.height(430),
                    )),
                SizedBox(
                  height: ScreenAdapter.height(30),
                ),
                MaterialButton(
                  minWidth: ScreenAdapter.width(260.0),
                  height: ScreenAdapter.height(44.0),
                  shape: RoundedRectangleBorder(
                    side: BorderSide.none,
                    borderRadius: BorderRadius.all(
                      Radius.circular(22.0),
                    ),
                  ),
                  color: AppColors.primaryRed,
                  child: Text(
                    '保存海报',
                    style: TextStyle(
                      fontSize: ScreenAdapter.fontSize(17.0),
                      color: AppColors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  onPressed: () async {
                    var response = await Dio().get(
                      url,
                      options: Options(
                        responseType: ResponseType.bytes,
                      ),
                    );
                    final result = await ImageGallerySaver.saveImage(
                      Uint8List.fromList(
                        response.data,
                      ),
                    );
                    if (!TextUtil.isEmpty(result)) {
                      CustomToast.showToast(
                          msg: Strings.live_create_wx_code_doc_saving_success, gravity: ToastGravity.CENTER);
                    } else {
                      CustomToast.showToast(
                          msg: Strings.live_create_wx_code_doc_saving_fail, gravity: ToastGravity.CENTER);
                    }
                    Navigator.pop(context);
                  },
                ),
              ],
              mainAxisAlignment: MainAxisAlignment.center,
            ),
          ));
}
