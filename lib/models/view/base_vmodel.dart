import 'package:flutter/foundation.dart';

/// 公共ViewModel对象，建议同普通页面（非登陆、胡策、忘记密码等）一起使用
abstract class BaseViewModel with ChangeNotifier {
  /// 严重问题（一般业务问题不要设置）
  Exception exception;

  /// 加载状态
  bool loading;
}
