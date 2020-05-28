import 'package:app/constants/app_theme.dart';
import 'package:app/constants/images.dart';
import 'package:app/entry/routes.dart';
import 'package:app/models/dto/live/live_order_statistic_dto.dart';
import 'package:app/models/dto/live/live_record_dto.dart';
import 'package:app/models/dto/live/live_statistic_dto.dart';
import 'package:app/services/live_service.dart';
import 'package:app/utils/custom_toast.dart';
import 'package:app/utils/screen_adapter.dart';
import 'package:app/widgets/common/loading_wrap_widget.dart';
import 'package:app/widgets/overwrite/custom_app_bar_widget.dart';
import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

/// 直播结束后回放界面
class LiveRecordScreen extends StatefulWidget {
  LiveRecordScreen({Key key, this.id}) : super(key: key);

  String id;

  @override
  _LiveRecordScreenState createState() => _LiveRecordScreenState();
}

class _LiveRecordScreenState extends State<LiveRecordScreen> {
  bool _loading = false;
  final LiveService _liveService = LiveService();
  LiveRecordDTO _liveRecordDto = LiveRecordDTO();
  LiveStatisticDto _liveStatisticDto = LiveStatisticDto();
  LiveOrderStatisticDTO _liveOrderStatisticDTO = LiveOrderStatisticDTO();

  @override
  void initState() {
    super.initState();
    _init();
  }

  void _init() async {
    setState(() {
      _loading = true;
    });
    _liveRecordDto = await _liveService.getLiveRecordInfo(widget?.id);
    _liveStatisticDto = await _liveService.statisticsInfo(widget?.id);
    _liveOrderStatisticDTO = await _liveService.getLiveOrderStatistics(widget?.id);
    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.greyF4,
      appBar: CustomAppBar(
        title: new Text('星琯直播'),
      ),
      body: LoadingWrap(
        loading: _loading,
        child: ListView(
          children: <Widget>[
            InkWell(
              child: Container(
                  width: ScreenAdapter.width(),
                  height: ScreenAdapter.height(201.0),
                  child: Stack(
                      alignment: Alignment.center,
                      fit: StackFit.expand,
                      children: <Widget>[
                        Image.network(_liveRecordDto?.bannerCover??'', fit: BoxFit.fill,),
                        Container(decoration: BoxDecoration(color: Color(0x90000000)),),
                        Positioned(
                          left: 0,
                          right: 0,
                          child: Image.asset(Images.icon_record_play, width: ScreenAdapter.width(50.0), height: ScreenAdapter.width(50.0),),)
                      ])
              ),
              onTap: (){
                if(_liveRecordDto == null || _liveRecordDto?.recordings == null || _liveRecordDto?.recordings?.length == 0){
                  CustomToast.showToast(msg: '暂无回放，请稍等几分钟哦', gravity: ToastGravity.CENTER);
                  return;
                }
                Navigator.of(context).pushNamed(
                  Routes.live_video_play,
                  arguments: {'url': _liveRecordDto?.recordings[0], 'aspectRatio': context.size.width / context.size.height, 'lbId': _liveRecordDto?.id},
                );
              },
            ),
            Container(
              padding: EdgeInsets.only(top: ScreenAdapter.height(14.0), left: ScreenAdapter.width(11.0), right: ScreenAdapter.width(11.0), bottom: ScreenAdapter.height(14.0)),
              alignment: Alignment.centerLeft,
              color: AppColors.white,
              child: Column(children: <Widget>[
                Text('${_liveRecordDto?.title}', style: TextStyle(fontSize: ScreenAdapter.fontSize(17.0), color: AppColors.black333),),
                Divider(height: ScreenAdapter.height(7.0), color: AppColors.white,),
                Text('${_liveRecordDto?.beginTime} - ${DateUtil.getDateMsByTimeStr(_liveRecordDto?.endTime?? '')}', style: TextStyle(fontSize: ScreenAdapter.fontSize(13.0), color: AppColors.black999),),
              ],
              crossAxisAlignment: CrossAxisAlignment.start,),
            ),
            Container(
              color: AppColors.white,
              margin: EdgeInsets.only(top: ScreenAdapter.height(10.0)),
              padding: EdgeInsets.only(top: ScreenAdapter.height(14.0), left: ScreenAdapter.width(11.0), right: ScreenAdapter.width(11.0), bottom: ScreenAdapter.height(14.0)),
              alignment: Alignment.centerLeft,
              child: Text('直播数据', style: TextStyle(fontSize: ScreenAdapter.fontSize(17.0), color: AppColors.black333),),
            ),
            Divider(height: ScreenAdapter.height(0.5)),
            Row(children: <Widget>[
              Expanded(child: _buildItem('累计观看', '${_liveStatisticDto?.view??"0"}'), flex: 1,),
              Expanded(child: _buildItem('最高在线', '${_liveStatisticDto?.maxOnline??"0"}'), flex: 1,),
            ],),
            Divider(height: ScreenAdapter.height(0.5)),
            Row(children: <Widget>[
              Expanded(child: _buildItem('累计互动', '${_liveStatisticDto?.interaction??"0"}'), flex: 1,),
              Expanded(child: _buildItem('累计商品点击', '${_liveStatisticDto?.productView??"0"}'), flex: 1,),
            ],),
            Divider(height: ScreenAdapter.height(0.5)),
            Row(children: <Widget>[
              Expanded(child: _buildItem('产生订单', '${_liveOrderStatisticDTO?.orderQuantity??"0"}'), flex: 1,),
              Expanded(child: _buildItem('销售金额', '${_liveOrderStatisticDTO?.orderAmount??"0"}'), flex: 1,),
            ],),
          ],
        ),
      ),
    );
  }

  Widget _buildItem(String title, String num){
    return Container(
      padding: EdgeInsets.all(ScreenAdapter.width(20.0)),
      width: ScreenAdapter.width(),
      color: AppColors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('$title', style: TextStyle(fontSize: ScreenAdapter.fontSize(12.0), color: AppColors.black999),),
          SizedBox(height: ScreenAdapter.height(8.0),),
          Text('$num', style: TextStyle(fontSize: ScreenAdapter.fontSize(20.0), color: AppColors.black333),)
        ],
      ),
    );
  }
}
