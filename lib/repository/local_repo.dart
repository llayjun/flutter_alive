import 'dart:async';

import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

import 'package:app/entry/config.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 本地数据存储，依赖于[Config]
/// 使用方式：
///   var db = await LocalRepo.db;
///   // 参考: [https://github.com/tekartik/sembast.dart/blob/master/sembast/README.md]
///
/// 如APP为网络请求 + 本地缓存逻辑：
/// 1. 当网络正常时，全部从网络读取；读取成功则缓存到本地
/// 2. 当网络异常时：
/// 1) 主数据从缓存读取;
/// 2) 提交数据等交互操作禁止使用；
///
/// 如APP为本地操作 + 网络备份逻辑：
/// 1. 所有操作直接读取和写入本地存储
/// 2. 当有网络存在时，进行同步
class LocalRepo {
  /// 单例对象
  static final inst = LocalRepo._();

  Future<Database> _db;

  LocalRepo._() {
    _init();
  }

  void _init() async {
    var dbName = Config.inst.dbName;
    // Get a platform-specific directory
    final appDocumentDir = await getApplicationDocumentsDirectory();

    // Path with the form: /platform-specific-directory/demo.db
    final dbPath = join(appDocumentDir.path, "$dbName.db");

    _db = databaseFactoryIo.openDatabase(dbPath);
  }

  /// 后去本地数据库对象
  Future<Database> get db {
    return _db;
  }

  /// 获取本地配置缓存对象
  Future<SharedPreferences> get prefs async {
    return await SharedPreferences.getInstance();
  }
}
