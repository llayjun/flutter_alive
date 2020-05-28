import 'dart:async';
import 'dart:convert';

import 'package:app/entry/config.dart';
import 'package:app/models/dto/basic_dto.dart';
import 'package:app/models/dto/live/live_broadcast_dto.dart';
import 'package:app/models/dto/live/live_chat_record_dto.dart';
import 'package:app/models/dto/live/live_order_statistic_dto.dart';
import 'package:app/models/dto/live/live_product_dto.dart';
import 'package:app/models/dto/live/live_record_dto.dart';
import 'package:app/models/dto/live/live_record_live_info_dto.dart';
import 'package:app/models/dto/live/live_record_product_dto.dart';
import 'package:app/models/dto/live/live_statistic_dto.dart';
import 'package:app/models/dto/paging_data_dto.dart';
import 'package:app/repository/exception/network_exceptions.dart';
import 'package:app/services/base/base_service.dart';
import 'package:dio/dio.dart';

class LiveService extends BaseService {
  /// 获得直播关联商品
  Future<List<LiveProductDTO>> getLiveProducts() async {
    final res = await api.get("/admin/api/link-product");
    return res.data
        .map<LiveProductDTO>((pItem) => LiveProductDTO.fromJson(pItem))
        .toList();
  }

  /// 分页获取直播列表
  Future<PagingDataDTO<LiveBroadcastDTO>> getLivePage(Map<String, dynamic> data) async {
    final res = await api.get("/admin/api/live-broadcasts",
        queryParameters: data);
    if (!res.success) {
      throw BizException(message: res.msg, statusCode: 200);
    }
    return PagingDataDTO<LiveBroadcastDTO>(
        total: res.total,
        data: res.data
            .map<LiveBroadcastDTO>((pItem) => LiveBroadcastDTO.fromJson(pItem))
            .toList());
  }

  /// 获得直播详情
  Future<LiveBroadcastDTO> getLiveBroadcastDetail(String id) async {
    final res = await api.get("/admin/api/live-broadcasts/$id");
    return LiveBroadcastDTO.fromJson(res.data);
  }

  /// 直播前校验
  Future<BasicDTO> checkLiveBroadcast(Map<String, dynamic> postData) async {
    final res = await api.post("/admin/api/live-broadcasts/check", data: postData);
    if (!res.success) {
      throw BizException(message: res.msg, statusCode: 200);
    }
    return res;
  }

  /// 创建直播
  Future<BasicDTO> addLiveBroadcast(Map<String, dynamic> postData) async {
    final res = await api.post("/admin/api/live-broadcasts", data: postData);
    return res;
  }

  /// 更新直播详情
  Future<BasicDTO> editLiveBroadcastDetail(String id, Map<String, dynamic> postData) async {
    final res = await api.put("/admin/api/live-broadcasts/$id", data: postData);
    return res;
  }

  /// 获取待直播数量
  Future<int> countLiveBroadcastPending() async {
    final res = await api.get("/admin/api/site/count/live-broadcast/pending");
    if (!res.success) {
      throw BizException(message: res.msg, statusCode: 200);
    }
    return res.data;
  }

  /// 获取已直播数量
  Future<int> countLiveBroadcastRecording() async {
    final res = await api.get("/admin/api/site/count/live-broadcast/recording");
    if (!res.success) {
      throw BizException(message: res.msg, statusCode: 200);
    }
    return res.data;
  }

  /// 更新微信小程序二维码图片
  Future<BasicDTO> updateMinAppCodeImg(String id, dynamic minAppCodeImg) async {
    final res = await api.put(
        "/admin/api/live-broadcasts/$id/update/minAppCodeImg",
        data: {"minAppCodeImg": minAppCodeImg});
    return res;
  }

  /// 删除直播
  Future<BasicDTO> deleteBroadcast(String id) async {
    final res = await api.delete("/admin/api/live-broadcasts/$id");
    if (!res.success) {
      throw BizException(message: res.msg, statusCode: 200);
    }
    return res;
  }

  /// 直播统计
  Future<LiveStatisticDto> statisticsInfo(String id) async {
    final res = await api.get('/admin/api/live-broadcasts/$id/statistics');
    if(!res.success){
      throw BizException(message: res.msg, statusCode: 200);
    }
    return LiveStatisticDto.fromJson(res.data);
  }

  /// 直播统计
  Future<LiveRecordDTO> getLiveRecordInfo(String id) async {
    final res = await api.get('/admin/api/live-broadcasts/$id/recording');
    if(!res.success){
      throw BizException(message: res.msg, statusCode: 200);
    }
    return LiveRecordDTO.fromJson(res.data);
  }

  /// 直播过程中统计数据
  Future<LiveOrderStatisticDTO> getLiveOrderStatistics(String lbId) async {
    final res = await api.get('/admin/api/site/orders/statistics/$lbId');
    if(!res.success){
      throw BizException(message: res.msg, statusCode: 200);
    }
    return LiveOrderStatisticDTO.fromJson(res.data);
  }

  /// 直播记录获取商品个数
  Future<LiveRecordLiveInfoDTO> getRecordLiveInfo(String lbId) async{
    final res = await api.get('/admin/api/live-broadcasts/$lbId');
    if(!res.success) {
      throw BizException(message: res.msg, statusCode: 200);
    }
    return LiveRecordLiveInfoDTO.fromJson(res.data);
  }

  /// 直播记录商品接口
  Future<List<LiveRecordProductDTO>> getRecordProductList(String lbId, String status) async {
    final res = await api.get('/admin/api/live-broadcasts/$lbId/products/status/$status');
    if(!res.success) {
      throw BizException(message: res.msg, statusCode: 200);
    }
    return res.data
        .map<LiveRecordProductDTO>((pItem) => LiveRecordProductDTO.fromJson(pItem))
        .toList();
  }

  /// 获取聊天记录
  Future<List<LiveChatRecordDTO>> getChatList100(String roomId, String roomName) async{
    Dio dio = new Dio();
    dio.interceptors.add(LogInterceptor(responseBody: true));
    Response response = await dio.get('${Config.inst.socketUrl}/chatlog?roomId=$roomId&roomName=$roomName&page=1&size=100');
    BasicDTO<List<LiveChatRecordDTO>> bean;
    if(response != null || response.data != null) {
      bean = BasicDTO.fromJson(response.data);
      if(!bean.success) {
        return [];
      }
      return bean.data
          .map<LiveChatRecordDTO>((pItem) => LiveChatRecordDTO.fromJson(pItem))
          .toList();
    }
    return [];
  }
}
