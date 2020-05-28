import 'dart:async';

import 'package:app/models/dto/login/login_dto.dart';
import 'package:app/models/dto/user/user_info_dto.dart';
import 'package:app/repository/exception/network_exceptions.dart';
import 'package:app/services/base/base_service.dart';

class LoginService extends BaseService{
  /// 登录
  Future<LoginDTO> login(Map<String, dynamic> postData) async {
    final res = await api.post("/admin/api/site/login", data: postData);
    if (!res.success) {
      throw BizException(message: res.msg, statusCode: 200);
    }
    return LoginDTO.fromJson(res.data);
  }

  /// 获取用户信息
  Future<UserInfoDTO> getUserInfo() async {
    final res = await api.get("/admin/api/site");
    if (!res.success) {
      throw BizException(message: res.msg, statusCode: 200);
    }
    return UserInfoDTO.fromJson(res.data);
  }
}
