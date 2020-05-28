
import 'dart:io';

import 'package:app/models/dto/basic_dto.dart';
import 'package:app/services/base/base_service.dart';
import 'package:app/ui/home/home.dart';
import 'package:dio/dio.dart';

class SysService extends BaseService{

  /// 保存图片
  Future<BasicDTO> uploadFile(File file) async {
    String fileName = file.path.lastIndexOf('/') > -1 ? file.path.substring(file.path.lastIndexOf('/') + 1) : file.path;
    String suffix = fileName.substring(fileName.lastIndexOf(".") + 1, fileName.length);

    FormData formData = new FormData.from({
      'file': UploadFileInfo(file, fileName, contentType: ContentType.parse("image/$suffix"))
    });

    final res = await api.post("/admin/api/files", data: formData);
    return res;
  }

  /// 获取最新版本
  Future<String> getLastVersion(PlatformType type, Stage stage) async {
    String platformString;
    String stageString;
    if (type == PlatformType.ANDROID) {
      platformString = "ANDROID";
    } else {
      platformString = "IOS";
    }
    if (stage == Stage.TEST) {
      stageString = "TEST";
    } else {
      stageString = "PRODUCTION";
    }
    final res = await api.get("/platform/apps/$platformString/$stageString/latest-version");
    return res.data;
  }

}