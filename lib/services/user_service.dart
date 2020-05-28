import 'dart:async';

import 'package:app/models/dto/basic_dto.dart';
import 'package:app/models/dto/paging_data_dto.dart';
import 'package:app/models/dto/user/customer_site_relation_dto.dart';
import 'package:app/models/vo/mine/my_amount_vo.dart';
import 'package:app/repository/exception/network_exceptions.dart';
import 'package:app/repository/request_type.dart';
import 'package:app/services/base/base_service.dart';
import 'package:dio/dio.dart';

class UserService extends BaseService {
  /// 我的资产
  Future<MyAmountVo> getUserFinance() async {
    final res = await api.get("/admin/api/site-finance");
    return MyAmountVo.fromJson(res.data);
  }

  /// 获取用户直播、订单信息
  Future<List<BasicDTO>> getUserOtherInfo() async {
    List<Future<Response>> requests = List<Future<Response>>();

    /// 已直播次数
    requests = api.combine("/admin/api/site/count/live-broadcast/recording",
        RequestType.GET, requests);

    /// 待直播次数
    requests = api.combine("/admin/api/site/count/live-broadcast/pending",
        RequestType.GET, requests);

    /// 待发货订单数量
    requests = api.combine(
        "/admin/api/site/count/orders/un-delivery", RequestType.GET, requests);

    /// 获取粉丝数量
    requests = api.combine(
        "/admin/api/site/count-follows", RequestType.GET, requests);

    final res = await api.waitRequest(requests);
    return res;
  }

  /// 绑定微信
  Future<BasicDTO> bindWechatClient(String code) async {
    final res = await api.post("/admin/api/site/bind-wechat-client/after-login", queryParameters: {"code": code});
    if (!res.success) {
      throw BizException(message: res.msg, statusCode: 200);
    }
    return res;
  }

  /// 解绑微信
  Future<BasicDTO> unbindWechatClient() async {
    final res = await api.post("/admin/api/site/unbind-wechat/after-login");
    if (!res.success) {
      throw BizException(message: res.msg, statusCode: 200);
    }
    return res;
  }

  /// 直播前校验
  Future<BasicDTO> checkIsCanBroadcast({String id}) async{
    final res = await api.post("/admin/api/live-broadcasts/check", data: {"id": id});
    return res;
  }

  /// 校验门店直播信息
  Future<BasicDTO> checkBroadcast() async {
    final res = await api.get("/admin/api/site/check-broadcast");
    if (!res.success) {
      throw BizException(message: res.msg, statusCode: 200);
    }
    return res;
  }

  /// 获取粉丝列表
  Future<PagingDataDTO<CustomerSiteRelationDTO>> getFans(Map<String, dynamic> data) async {
    final res = await api.get("/admin/api/site/follows",
        queryParameters: data);
    if (!res.success) {
      throw BizException(message: res.msg, statusCode: 200);
    }
    return PagingDataDTO<CustomerSiteRelationDTO>(
        total: res.total,
        data: res.data
            .map<CustomerSiteRelationDTO>((pItem) => CustomerSiteRelationDTO.fromJson(pItem))
            .toList());
  }

  /// 校验门店是否能直播
  Future<bool> checkUserBindWeChat() async {
    final res = await api.get("/admin/api/site/check-user-bind-wechat");
//    if (!res.success) {
//      throw BizException(message: res.msg, statusCode: 200);
//    }
    return res.success;
  }

  /// 获取个人中心分销金额
  Future<num> getTotalMoney() async {
    final res = await api.get("/admin/api/order-distribution/count-distribution-amount");
    if (!res.success) {
      throw BizException(message: res.message, statusCode: 200);
    }
    return res.data;
  }

}
