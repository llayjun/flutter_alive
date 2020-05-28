import 'package:app/constants/app_theme.dart';
import 'package:app/constants/images.dart';
import 'package:app/constants/strings.dart';
import 'package:app/entry/config.dart';
import 'package:app/entry/routes.dart';
import 'package:app/ui/live/live_vmodel.dart';
import 'package:app/utils/screen_adapter.dart';
import 'package:app/vmodel/edit_addressdetail_vmodel.dart';
import 'package:app/vmodel/user_info_vmodel.dart';
import 'package:app/widgets/basic/iconfont_widget.dart';
import 'package:app/widgets/common/loading_wrap_widget.dart';
import 'package:app/widgets/overwrite/custom_app_bar_widget.dart';
import 'package:app/widgets/overwrite/custom_single_child_scroll_view_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:fluwx_no_pay/fluwx_no_pay.dart' as fluwx;

class PersonalHomepageScreen extends StatefulWidget {
  PersonalHomepageScreen();

  @override
  _PersonalHomepageState createState() => _PersonalHomepageState();
}

class _PersonalHomepageState extends State<PersonalHomepageScreen> {
  bool _init = true;

  @override
  void initState() {
    super.initState();
    new Future.delayed(Duration.zero, () {
      Provider.of<LiveVModel>(context).fetchPagingData(true, "RECORDING", "endTime");
      Provider.of<LiveVModel>(context).fetchData4Person();
      Provider.of<EditAddressDetailVModel>(context).getAddressInfo();
      setState(() {
        _init = false;
      });
    });
  }


  void _jumpToMiniProgram(item) {
    /// TODO 跳转到小程序不同的页面ID不确定
    switch (item.status) {
      case '直播中':
        // 跳转到直播间
        fluwx.launchWeChatMiniProgram(
          username: Config.inst.miniUsername,
          path: "/pages/live/viewer/viewer?roomId=${item.id}",
          miniProgramType: fluwx.WXMiniProgramType.RELEASE,
        );
        break;
      case '待直播':
        // 跳转到直播详情
        fluwx.launchWeChatMiniProgram(
          username: Config.inst.miniUsername,
          path: "/pages/live/detail/detail?roomId=${item.id}",
          miniProgramType: fluwx.WXMiniProgramType.RELEASE,
        );
        break;
      case '已结束':
        // 跳转到直播回放
        fluwx.launchWeChatMiniProgram(
          username: Config.inst.miniUsername,
          path: "/pages/live/playback/playback?roomId=${item.id}",
          miniProgramType: fluwx.WXMiniProgramType.RELEASE,
        );
        break;
    }
  }

  void _seeMore(item) {
    Navigator.of(context).pushNamed(
      Routes.live_record_detail,
      arguments: {'id': item.id},
    );
  }

  void _deleteHistoryItem(item) async {
    Provider.of<LiveVModel>(context).deleteBroadcast(item.id);
  }

  @override
  Widget build(BuildContext context) {
    final _userDataInfo = Provider.of<UserInfoVModel>(context);
    final _liveDataInfo = Provider.of<LiveVModel>(context);
    final _addressVM = Provider.of<EditAddressDetailVModel>(context);

    Widget _liveItemBuild(item) {
      return GestureDetector(
          onTap: () {
            // 直播小程序暂不开放
//            fluwx.launchWeChatMiniProgram(
//              username: Config.inst.miniUsername,
//              path: "/pages/live/detail/detail?roomId=${item.id}",
//              miniProgramType: fluwx.WXMiniProgramType.RELEASE,
//            );
          },
          child:Container(
            height: ScreenAdapter.height(82.0),
            color: AppColors.white,
            padding: EdgeInsets.only(
              left: ScreenAdapter.width(12.0),
              right: ScreenAdapter.width(12.0),
            ),
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ConstrainedBox(
                      constraints: BoxConstraints.tightFor(
                        width: ScreenAdapter.width(250.0),
                      ),
                      child: Text(
                        '${item.title}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: AppColors.black43,
                          fontSize: ScreenAdapter.fontSize(17.0),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: ScreenAdapter.height(3.0),
                    ),
                    Text(
                      '${item.status == "LIVE" ? "直播中" : "直播预告"} | ${item.status == "LIVE" ? item.totalView : item.beginTime}',
                      style: TextStyle(
                        color: AppColors.black999,
                        fontSize: ScreenAdapter.fontSize(12.0),
                      ),
                    ),
                  ],
                ),
//                Icon(
//                  IconFont.go_forward,
//                  color: AppColors.greyD8,
//                  size: ScreenAdapter.fontSize(18.0),
//                ),
              ],
            ),
          )
      );
    }

    Widget _historyItemBuild(item) {
      final Widget _playback = AspectRatio(
        aspectRatio: 1,
        child: GestureDetector(
          onTap: () {
            /// TODO 回放
          },
          child: Stack(
            children: <Widget>[
              Image(
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
                image: NetworkImage(
                  '${item.squareCover.url}',
                ),
              ),
              Container(
                color: AppColors.black.withOpacity(0.6),
                alignment: Alignment.center,
                child: Icon(
                  IconFont.play,
                  size: ScreenAdapter.fontSize(36.0),
                  color: AppColors.white,
                ),
              ),
            ],
          ),
        ),
      );

      Widget _imageItemBuild(productItem) {
        return GestureDetector(
          child: AspectRatio(
            aspectRatio: 1,
            child: Stack(
              alignment: Alignment.bottomLeft,
              children: <Widget>[
                Image(
                  fit: BoxFit.cover,
                  image: NetworkImage(
                    '${productItem.img}'
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  width: ScreenAdapter.width(40.0),
                  height: ScreenAdapter.height(20.0),
                  decoration: BoxDecoration(
                    color: AppColors.primaryRed,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(
                        ScreenAdapter.width(8.5),
                      ),
                    ),
                  ),
                  child: Text(
                    '${Strings.symbol_rmb}${productItem.price}',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: ScreenAdapter.fontSize(11.0),
                    ),
                  ),
                ),
              ],
            ),
          ),
          onTap: () {
//            Navigator.of(context).pushNamed(
//              Routes.live_record_detail,
//              arguments: {'id': productItem.id},
//            );
          },
        );
      }

      Widget _more([image = '']) {
        return GestureDetector(
          child: AspectRatio(
            aspectRatio: 1,
            child: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                Container(
                  color: AppColors.black.withOpacity(0.5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        '更多',
                        style: TextStyle(
                            color: AppColors.white,
                            fontSize: ScreenAdapter.fontSize(12.0),
                            height: 0.9),
                      ),
                      SizedBox(
                        width: ScreenAdapter.width(2.5),
                      ),
                      Icon(
                        IconFont.next,
                        size: ScreenAdapter.fontSize(10.0),
                        color: AppColors.white,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          onTap: () {
            _seeMore(item);
          },
        );
      }

      var _firstRow = [];
      var _secondRow = [];
      var _thirdRow = [];

      /// 写死一个图片个数
      var count = item.products == null ? 0 : item.products.length; // 9张图片

      var imgCount = count >= 8 ? 8 : count;

      /// 根据商品数量判断布局
      switch (imgCount) {
        case 0:
          _firstRow = [_playback, _more()];
          break;
        case 1:
          _firstRow = [_playback, _imageItemBuild(item.products[0]), _more()];
          break;
        case 2:
          _firstRow = [_playback, _imageItemBuild(item.products[0])];
          _secondRow = [_imageItemBuild(item.products[1]), _more()];
          break;
        Second:
        case 3:
        case 4:
        case 5:
          _secondRow.insert(0, _imageItemBuild(item.products[--imgCount]));
          if (imgCount < 3) {
            continue Finally;
          }
          continue Second;
        Thrid:
        case 6:
        case 7:
          _thirdRow.insert(0, _imageItemBuild(item.products[--imgCount]));
          if (imgCount < 6) {
            continue Second;
          }
          continue Thrid;
        case 8:
          _thirdRow.add(_more(item.products[--imgCount]));
          continue Thrid;
        Finally:
        default:
          if (count == 5) {
            _secondRow.removeLast();
            _secondRow.add(_more(item.products[4]));
          } else if (count >= 8) {
          } else if (count <= 4) {
            _secondRow.add(_more());
          } else {
            _thirdRow.add(_more());
          }
          _firstRow = [_playback, _imageItemBuild(item.products[0]), _imageItemBuild(item.products[1])];
          break;
      }

      /// 补全
      switch (count) {
        case 3:
          _secondRow.add(Container());
          break;
        case 6:
          _thirdRow.add(Container());
          break;
      }

      List<TableRow> _table = <TableRow>[];
      if (_firstRow.length > 0) {
        _table.add(TableRow(children: _firstRow.cast<Widget>()));
      }
      if (_secondRow.length > 0) {
        _table.add(TableRow(children: _secondRow.cast<Widget>()));
      }
      if (_thirdRow.length > 0) {
        _table.add(TableRow(children: _thirdRow.cast<Widget>()));
      }

      return Container(
        color: AppColors.white,
        padding: EdgeInsets.only(
          left: ScreenAdapter.width(12.0),
          right: ScreenAdapter.width(12.0),
          top: ScreenAdapter.height(15.0),
          bottom: ScreenAdapter.height(20.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ConstrainedBox(
              constraints: BoxConstraints.tightFor(
                width: ScreenAdapter.width(250.0),
              ),
              child: Text(
                '${item.title}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: AppColors.black43,
                  fontSize: ScreenAdapter.fontSize(17.0),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(height: ScreenAdapter.height(6.0)),
            Text(
              '${item.description}',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: AppColors.black43,
                fontSize: ScreenAdapter.fontSize(14.0),
              ),
            ),
            SizedBox(height: ScreenAdapter.height(12.0)),
            Table(
              defaultColumnWidth: FixedColumnWidth(ScreenAdapter.width(115.0)),
              border: TableBorder.symmetric(
                outside: BorderSide.none,
                inside: BorderSide(
                  color: AppColors.white,
                  width: ScreenAdapter.width(3.0),
                ),
              ),
              children: _table.cast<TableRow>(),
            ),
            SizedBox(height: ScreenAdapter.height(12.0)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
//                  DateUtil.formatDate(
//                    DateTime.now(),
//                    format: 'yyyy-MM-dd',
//                  )
                  '${item.endTime}',
                  style: TextStyle(
                    color: AppColors.black999,
                    fontSize: ScreenAdapter.fontSize(14.0),
                  ),
                ),
                GestureDetector(
                  child: Icon(
                    IconFont.delete,
                    size: ScreenAdapter.fontSize(18.0),
                    color: AppColors.black666,
                  ),
                  onTap: () {
                    showDialog(
                        context: context,
                        barrierDismissible: false, // 点击外部不消失
                        builder: (BuildContext context) {
                          return AlertDialog(
                            content: Text(
                              "确定删除？",
                              style: TextStyle(fontSize: ScreenAdapter.fontSize(15.0)),
                              textAlign: TextAlign.center,
                            ),
                            actions: <Widget>[
                              CupertinoButton(
                                child: Text("取消"),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                              CupertinoButton(
                                child: Text("确定"),
                                onPressed: () {
                                  _deleteHistoryItem(item);
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          );
                        });
                  } ,
                ),
              ],
            ),
          ],
        ),
      );
    }

    Widget _header = Container(
      color: AppColors.primaryRed,
      height: ScreenAdapter.height(105.0),
      alignment: Alignment.topLeft,
      padding: EdgeInsets.only(
        top: ScreenAdapter.height(16.0),
        left: ScreenAdapter.width(12.0),
      ),
      child: Row(
        children: <Widget>[
          ClipOval(
            child: Image(
              width: ScreenAdapter.width(60.0),
              height: ScreenAdapter.width(60.0),
              fit: BoxFit.cover,
              color: AppColors.pink,
              colorBlendMode: BlendMode.dstATop,
              image: _userDataInfo.userInfo.headerImg != null &&
                      _userDataInfo.userInfo.headerImg.isNotEmpty
                  ? NetworkImage(_userDataInfo.userInfo.headerImg)
                  : AssetImage(Images.mine_head_portrait_default),
            ),
          ),
          SizedBox(
            width: ScreenAdapter.width(20.0),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                _userDataInfo.userInfo.shopName ?? '--',
                style: TextStyle(
                  fontSize: ScreenAdapter.fontSize(17.0),
                  color: AppColors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: ScreenAdapter.height(3.0)),
              GestureDetector(
                child: Text(
                  '粉丝 ${_userDataInfo.fans}',
                  style: TextStyle(
                    fontSize: ScreenAdapter.fontSize(14.0),
                    color: AppColors.white,
                  ),
                ),
                onTap: () {
                  Navigator.of(context).pushNamed(Routes.fans);
                },
              ),
            ],
          ),
        ],
      ),
    );

    Widget _itemPhoneLocation(String title, String name,String image, {Function callBack}) {
      return Padding(
        padding: EdgeInsets.all(ScreenAdapter.width(12.0)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(title, style: TextStyle(fontSize: ScreenAdapter.fontSize(15.0), color: AppColors.black43),),
            SizedBox(width: ScreenAdapter.width(17.0),),
            Expanded(
              child: Text(name, style: TextStyle(fontSize: ScreenAdapter.fontSize(15.0), color: AppColors.black666),),
            ),
//            InkWell(
//              child: Image.asset(image, width: ScreenAdapter.width(16.0), height: ScreenAdapter.height(20.0),),
//              onTap: () {
//                callBack();
//              },
//            ),
          ],
        ),
      );
    }

    // 门店地址信息
    Widget _info = Container(
      color: AppColors.white,
      child: Column(
        children: <Widget>[
          _itemPhoneLocation("门店电话", "${_addressVM?.addressInfoDTO?.mobile}", Images.icon_red_phone),
          Divider(height: ScreenAdapter.height(1.0), color: AppColors.greyEF,),
          _itemPhoneLocation("门店地址", "${_addressVM?.addressInfoDTO?.districtFmt}" + "${_addressVM?.addressInfoDTO?.address}", Images.icon_red_location),
    ],
      ),
    );

    return Scaffold(
      appBar: CustomAppBar(
        brightness: Brightness.dark,
        backgroundColor: AppColors.primaryRed,
        title: Text(
          '个人主页',
          style: TextStyle(
            color: AppColors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        iconTheme: IconThemeData(color: AppColors.white),
        barBorder: false,
      ),
      body: LoadingWrap(
        loading: _init,
        child: RefreshIndicator(
          onRefresh: () => _liveDataInfo.fetchPagingData(true, "RECORDING", "endTime"),
          child: Container(
            width: double.infinity,
            height: double.infinity,
            child: CustomSingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              loading: _liveDataInfo.loadingMore,
              onLoadMore: () => _liveDataInfo.fetchPagingData(false, "RECORDING", "endTime"),
              empty: _liveDataInfo.liveList.length <= 0 && _liveDataInfo.liveList4Person.length <= 0,
              emptySlot: Column(
                children: <Widget>[
                  _header,
                  Visibility(
                    child: _info,
                    visible: _addressVM?.addressInfoDTO?.mobile != null,
                  ),
                  SizedBox(height: ScreenAdapter.height(93.0)),
                  Text(
                    '还没有记录哦，快去发布直播吧',
                    style: TextStyle(
                      color: AppColors.black999,
                      fontSize: ScreenAdapter.fontSize(17.0),
                    ),
                  ),
                  SizedBox(height: ScreenAdapter.height(20.0)),
                  MaterialButton(
                    minWidth: ScreenAdapter.width(100.0),
                    height: ScreenAdapter.height(34.0),
                    color: AppColors.primaryRed,
                    shape: StadiumBorder(),
                    child: Text(
                      '发布直播',
                      style: TextStyle(
                          color: AppColors.white,
                          fontSize: ScreenAdapter.fontSize(14.0)),
                    ),
                    onPressed: () {
                      Provider.of<UserInfoVModel>(context).checkBeginBroadcast().then((value) {
                        if(value.success) {
                          Navigator.of(context).pushNamed(Routes.live_create);
                        } else {
                          Navigator.of(context).pushNamed(Routes.live_create_close, arguments: {'message': value.message});
                        }
                      });
                    },
                  ),
                ],
              ),
              finished: _liveDataInfo.nothingMore,
              finishedText: '到底啦~',
              child: Column(
                children: <Widget>[
                  _header,
                  Visibility(
                    child: _info,
                    visible: _addressVM?.addressInfoDTO?.mobile != null,
                  ),
                  Column(
                    children: ListTile.divideTiles(
                      context: context,
                      tiles: _liveDataInfo.liveList4Person.map(_liveItemBuild).toList(),
                      color: AppColors.greyD8,
                    ).toList(),
                  ),
                  SizedBox(height: ScreenAdapter.height(10.0)),
                  Column(
                    children: ListTile.divideTiles(
                      context: context,
                      tiles: _liveDataInfo.liveList.map(_historyItemBuild),
                      color: AppColors.greyD8,
                    ).toList(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
