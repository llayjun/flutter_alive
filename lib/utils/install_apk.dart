import 'dart:io';

import 'package:app/entry/config.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_install_app_plugin/flutter_install_app_plugin.dart';
import 'package:install_plugin/install_plugin.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

enum InstallApkType { UPDATE_APP, INSTALL_JIU_DA_YE }

class InstallApk {
  /// 获取存储路径
  Future<String> _apkLocalPath() async {
    //获取根目录地址
    final dir = await getExternalStorageDirectory();
    //自定义目录路径(可多级)
    String path = dir.path + '/install-package';
    var directory = await new Directory(path).create(recursive: true);
    return directory.path;
  }

  /// 检查是否已有读写内存权限
  Future<bool> _checkWritePermission() async {
    PermissionStatus status = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.storage);

    //判断如果还没拥有读写权限就申请获取权限
    if (status != PermissionStatus.granted) {
      var map = await PermissionHandler()
          .requestPermissions([PermissionGroup.storage]);
      if (map[PermissionGroup.storage] != PermissionStatus.granted) {
        return false;
      }
    }
    return true;
  }

  Future<Null> _installApk() async {
    try {
      final path = await _apkLocalPath();

      InstallPlugin.installApk(
        path + '/update.apk',
        'com.czh.tvmerchantapp',
      ).then((result) {
        print('install apk $result');
      }).catchError((error) {
        print('install apk error: $error');
      });
    } catch (_) {}
  }

  /// 通过下载apk然后安装来更新应用
  Future<bool> updateAppByInstall() async {
    if (!await _checkWritePermission()) {
      return false;
    }
    final path = await _apkLocalPath();

    //发起请求
    final taskId = await FlutterDownloader.enqueue(
      url:
          'http://oss.pgyer.com/d862d79d0222de74b63b680f63ac0309.apk?auth_key=1568112008-503070cca0acf74dab2c7c582a5b5a2e-0-cb19b0ad9bddc529a05c0505152a1ee8&response-content-disposition=attachment%3B+filename%3Dapp-arm64-v8a-release.apk',
      fileName: 'update.apk',
      savedDir: path,
      showNotification: false,
      openFileFromNotification: false,
    );

    try {
      await FlutterDownloader.registerCallback(
        (id, status, progress) async {
          //更新下载进度
          // setState(() => this.progress = progress);
          if (taskId == id) {
            if (status == DownloadTaskStatus.complete) {
              await _installApk();
              return;
            }
            if (status == DownloadTaskStatus.failed ||
                status == DownloadTaskStatus.canceled) {
              throw Error();
            }
          }
        },
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  
  /// 跳转到应用商城（九大爷商城App）
  Future<Null> jumpAppStoreOfNDY() async {
    try {
      var app = AppSet();
      app.iosAppId = Config.inst.ndymallIOSAppId;
      app.androidPackageName = Config.inst.ndymallAndPackageName;
      FlutterInstallAppPlugin.installApp(app);
    } catch (_) {}
  }
}
