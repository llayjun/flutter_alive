import 'package:app/constants/strings.dart';
import 'package:app/models/dto/basic_dto.dart';
import 'package:app/models/dto/login/login_dto.dart';
import 'package:app/models/dto/user/site_broadcast_dto.dart';
import 'package:app/models/vo/user/user_info_vo.dart';
import 'package:app/repository/constant/local_cache_keys.dart';
import 'package:app/repository/local_repo.dart';
import 'package:app/services/login_service.dart';
import 'package:app/services/user_service.dart';
import 'package:app/utils/custom_toast.dart';
import 'package:app/utils/sp_util.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserInfoVModel with ChangeNotifier {
  UserInfoVModel() {
    LocalRepo.inst.prefs.then((prefs) {
      _isLogin = prefs.getBool(LocalCacheKeys.isLoggedIn) ?? false;
      if (_isLogin) {
        _token = prefs.getString(LocalCacheKeys.loggedInToken);
      }
    });
  }

  final LoginService _loginService = LoginService();
  final UserService _userService = UserService();

  bool _isLogin = false;
  String _token;
  UserInfoVO _userInfo;

  /// 直播次数
  int _liveTime = 0;

  /// 未直播
  int _unLiveTime = 0;

  /// 代发货订单数
  int _orderUnDeliveryCount = 0;

  /// 是否已经获取过用户其它信息
  bool _alreadyFetchOtherInfo = false;

  /// 粉丝数量
  int _fans = 0;

  /// 分销总金额
  num _totalMoney = 0;

  String get token => _token;
  UserInfoVO get userInfo {
    if (_userInfo == null) {
      return UserInfoVO();
    }
    return _userInfo;
  }

  bool get isLogin => _isLogin;
  int get liveTime => _liveTime;
  int get unLiveTime => _unLiveTime;
  int get orderUnDeliveryCount => _orderUnDeliveryCount;
  int get fans => _fans;
  num get totalMoney => _totalMoney;

  String validatePhone(value) {
//    RegExp _phoneReg = RegExp(
//        r'^((13[0-9])|(14[0-9])|(15[0-9])|(16[0-9])|(17[0-9])|(18[0-9])|(19[0-9]))\d{8}$');
    if (value == null || value.isEmpty) {
      return "请输入九大爷账号";
//    } else if (!_phoneReg.hasMatch(value)) {
//      return '请输入正确的手机号码';
    } else {
      return '';
    }
  }

  String validatePassword(value) {
    if (value.isEmpty) {
      return "密码不能为空";
//    } else if (value.length < 6) {
//      return "密码长度必须大于6位";
    } else {
      return '';
    }
  }

  // 登录
  Future<bool> login(String phone, String password) async {
    if (phone.isEmpty || password.isEmpty) {
      CustomToast.showToast(msg: Strings.login_et_empty_msg, gravity: ToastGravity.CENTER);
      return false;
    }

    String _errorPhone = validatePhone(phone);
    if (_errorPhone.isNotEmpty) {
      CustomToast.showToast(msg: _errorPhone, gravity: ToastGravity.CENTER);
      return false;
    }

    String _errorPwd = validatePassword(password);
    if (_errorPwd.isNotEmpty) {
      CustomToast.showToast(msg: _errorPwd, gravity: ToastGravity.CENTER);
      return false;
    }

    try {
      LoginDTO data = await _loginService.login({
        'username': phone,
        'password': password,
      });
      SharedPreferences prefs = await LocalRepo.inst.prefs;
      prefs.setBool(LocalCacheKeys.isLoggedIn, true);
      prefs.setString(LocalCacheKeys.loggedInToken, data.token);
      prefs.setString(LocalCacheKeys.chatRoomToken, data.chatRoomToken);
      SpUtil.putString(LocalCacheKeys.userName, data.username);
      SpUtil.putString(LocalCacheKeys.userIcon, data.headerImg);
      SpUtil.putString(LocalCacheKeys.shopName, data.shopName);
      SpUtil.putString(LocalCacheKeys.siteId, data.siteId);

//
      _isLogin = true;
      _token = data.token;
      _userInfo = UserInfoVO(
        username: data.username ?? '',
        mobile: phone ?? '',
        headerImg: data.headerImg ?? '',
        shopName: data.shopName ?? '',
        enableBroadcast: data.enableBroadcast ?? false,
      );
      return true;
    } catch (e) {
      CustomToast.showToast(msg: e.toString(), gravity: ToastGravity.CENTER);
      return false;
    }
  }

  // 退出登录
  Future<bool> logout() async {
    try {
      SharedPreferences prefs = await LocalRepo.inst.prefs;
      prefs.remove(LocalCacheKeys.isLoggedIn);
      prefs.remove(LocalCacheKeys.loggedInToken);
      prefs.remove(LocalCacheKeys.chatRoomToken);
      SpUtil.remove(LocalCacheKeys.userName);
      SpUtil.remove(LocalCacheKeys.userIcon);
      SpUtil.remove(LocalCacheKeys.shopName);
      SpUtil.remove(LocalCacheKeys.siteId);
      _token = null;
      _isLogin = false;
      _userInfo = null;
      _liveTime = 0;
      _unLiveTime = 0;
      _orderUnDeliveryCount = 0;
      _alreadyFetchOtherInfo = false;
      return true;
    } catch (e) {
      CustomToast.showToast(msg: e.toString(), gravity: ToastGravity.CENTER);
      return false;
    }
  }

  Future<bool> getBasicInfo() async {
    try {
      await _loginService.getUserInfo().then((res) {
        _userInfo = UserInfoVO(
          username: res.username ?? '',
          mobile: res.mobile ?? '',
          headerImg: res.avator != null ? (res.avator['url'] ?? '') : '',
          shopName: res.nickname ?? '',
          enableBroadcast: res.site.enableBroadcast ?? false,
          bindWechat: res.bindWechat ?? false,
        );
        return true;
      }).catchError((e) {
        return false;
      });
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  /// 获取用户其他信息
  Future<bool> getUserOtherInfo([bool forceReload = false]) async {
    if (!_isLogin) {
      return false;
    }
    if (!forceReload && _alreadyFetchOtherInfo) {
      return true;
    }
    return await _userService.getUserOtherInfo().then((res) {
      List<BasicDTO> results = res;
      if (results.length == 4) {
        BasicDTO countPending = results[0];
        if (countPending.success) {
          _liveTime = countPending.data ?? 0;
        } else {
          return false;
          //CustomToast.showToast(msg: countPending.msg, gravity: ToastGravity.CENTER);
        }

        BasicDTO countRecording = results[1];
        if (countRecording.success) {
          _unLiveTime = countRecording.data ?? 0;
        } else {
          return false;
          //CustomToast.showToast(msg: countPending.msg, gravity: ToastGravity.CENTER);
        }

        BasicDTO countOrder = results[2];
        if (countOrder.success) {
          _orderUnDeliveryCount = countOrder.data ?? 0;
        } else {
          return false;
          //CustomToast.showToast(msg: countPending.msg, gravity: ToastGravity.CENTER);
        }

        BasicDTO countFan = results[3];
        if (countFan.success) {
          _fans = countFan.data ?? 0;
        } else {
          return false;
          //CustomToast.showToast(msg: countPending.msg, gravity: ToastGravity.CENTER);
        }
      } else {
        return false;
      }
      _alreadyFetchOtherInfo = true;
      notifyListeners();
      return true;
    }).catchError((e) {
      // notifyListeners();
      //CustomToast.showToast(msg: e.toString(), gravity: ToastGravity.CENTER);
      return false;
    });
  }

  /// 绑定微信
  void bindWechatClient(String code) async {
    if (!_isLogin) {
      return;
    }

    await _userService.bindWechatClient(code).then((res) {
      if (res.success) {
        getBasicInfo();
        getUserOtherInfo();
        _alreadyFetchOtherInfo = true;

        CustomToast.showToast(msg: "微信绑定成功", gravity: ToastGravity.CENTER);
        notifyListeners();
      }
    }).catchError((e) {
      CustomToast.showToast(msg: e.toString(), gravity: ToastGravity.CENTER);
    });
  }

  /// 解绑微信
  void unbindWechatClient() async {
    if (!_isLogin) {
      return;
    }
    await _userService.unbindWechatClient().then((res) {
      if (res.success) {
        getBasicInfo();
        getUserOtherInfo();
        _alreadyFetchOtherInfo = true;

        CustomToast.showToast(msg: "微信解绑成功", gravity: ToastGravity.CENTER);
        notifyListeners();
      }
    }).catchError((e) {
      CustomToast.showToast(msg: e.toString(), gravity: ToastGravity.CENTER);
    });
  }

  /// 校验门店直播信息
  Future<SiteBroadcastDTO> checkBroadcast() async {
    if (!_isLogin) {
      return null;
    }

    return await _userService.checkBroadcast().then((res) {
      notifyListeners();
      return res.data == null ? null : SiteBroadcastDTO.fromJson(res.data);
    }).catchError((e) {
      return null;
    });
  }

  /// 检验直播是否能够直播
  Future<BasicDTO> checkBeginBroadcast({String id}) async{
    return await _userService.checkIsCanBroadcast(id: id);
  }

  /// 获取分销商城总金额
  Future<num> getTotalMoney() async {
    await _userService.getTotalMoney().then((value) {
      if(!_isLogin) {
        _totalMoney = 0;
        notifyListeners();
        return;
      }
      _totalMoney = value;
      notifyListeners();
    });
  }

}
