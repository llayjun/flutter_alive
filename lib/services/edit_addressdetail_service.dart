import 'dart:math';

import 'package:app/models/dto/adress/address_info_dto.dart';
import 'package:app/repository/exception/network_exceptions.dart';
import 'package:app/services/base/base_service.dart';

class AddressService extends BaseService {

  /// 获得主播门店地址信息
  Future<AddressInfoDTO> getAddressInfo() async {
    final res = await api.get("/admin/api/address");
    if (!res.success) {
      throw BizException(message: res.msg, statusCode: 200);
    }
    return AddressInfoDTO.fromJson(res.data);
  }

  /// 修改主播门店地址信息
  Future<bool> updateUserInfo(AddressInfoDTO infoDTO) async {
    Map<String, dynamic> _map = Map();
    _map = infoDTO.toJson();
    final res = await api.put("/admin/api/address",data: _map);
    if (!res.success) {
      throw BizException(message: res.msg, statusCode: 200);
    }
    return true;
  }


}