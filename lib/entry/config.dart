import 'package:app/utils/log.dart';

/// 公共App配置
/// 初始化后，通过[Config.inst]获取实例
class Config {
  static final Config inst = Config._();

  /// 本地存储数据库名称
  String dbName;

  /// 后端API服务地址前缀（不以斜杠结尾）
  String apiUrl;

  /// webViewUrl
  String webUrl;

  /// 日志级别
  LogLevel logLevel;

  /// bundleId对应微信的appId
  String appId;

  ///需跳转小程序的原始ID gh_开头
  String miniUsername;

  /// 唤起"九大爷商城"url
  String ndymallUrlString;

  /// "九大爷商城"的苹果appId
  int ndymallIOSAppId;

  /// "九大爷商城"的安卓包名
  String ndymallAndPackageName;

  /// socketUrl
  String socketUrl;

  Config._();

  factory Config.fill({
    String dbName = "demo",
    String apiUrl,
    String webUrl,
    String socketUrl,
    LogLevel logLevel,
    String appId,
    String miniUsername,
    String ndymallUrlString,
    int ndymallIOSAppId,
    String ndymallAndPackageName,
  }) {
    inst.dbName = dbName;
    inst.apiUrl = apiUrl;
    inst.webUrl = webUrl;
    inst.logLevel = logLevel ?? LogLevel.info;
    inst.appId = appId;
    inst.miniUsername = miniUsername;
    inst.ndymallUrlString = ndymallUrlString;
    inst.ndymallIOSAppId = ndymallIOSAppId;
    inst.ndymallAndPackageName = ndymallAndPackageName;
    inst.socketUrl = socketUrl;
    
    // 重设日志级别
    Log.inst.setLevel(inst.logLevel);

    return inst;
  }
}
