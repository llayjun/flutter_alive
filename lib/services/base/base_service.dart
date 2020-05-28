import 'package:app/models/dto/basic_dto.dart';
import 'package:app/repository/exception/network_exceptions.dart';
import 'package:app/repository/local_repo.dart';
import 'package:app/repository/remote_repo.dart';

/// Service父类，提供公共便捷方法入口
abstract class BaseService {
  LocalRepo get local {
    return LocalRepo.inst;
  }

  RemoteRepo get api {
    return RemoteRepo.inst;
  }

  List getDataList(BasicDTO result) {
    if (result.success && result.dataList != null) {
      return result.dataList;
    } else {
      throw new BizException(message: result.message ?? "出错了", statusCode: 200);
    }
  }
}
