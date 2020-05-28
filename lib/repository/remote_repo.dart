import 'dart:async';

import 'package:app/entry/config.dart';
import 'package:app/models/dto/basic_dto.dart';
import 'package:app/repository/constant/local_cache_keys.dart';
import 'package:app/repository/exception/network_exceptions.dart';
import 'package:app/repository/request_type.dart';
import 'package:app/utils/log.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Rest api client，依赖于[Config]
///
/// 最终调用者需要捕获[AuthException]、[NetworkException]、[BizException]和一般异常进行单独处理
/// 建议：AuthException -> 强制重新登录
/// 建议：ApiException -> 提示服务异常
/// 建议：NetworkException -> 显示网络异常页面
class RemoteRepo {
  /// 单例对象
  static final inst = RemoteRepo._();

  Dio _dio;

  RemoteRepo._() {
    _init();
  }

  /// 添加拦截器
  addInterceptor(Interceptor interceptor) {
    _dio.interceptors.add(interceptor);
  }

  _init() async {
    var baseUrl = Config.inst.apiUrl;

    _dio = Dio()
      ..options.baseUrl = baseUrl
      ..options.connectTimeout = 20000
      ..options.receiveTimeout = 20000
      ..options.headers = {'Content-Type': 'application/json; charset=utf-8'};

    // 调试模式打印网络日志
    if (Config.inst.logLevel == LogLevel.debug) {
      _dio.interceptors.add(LogInterceptor(responseBody: true));
    }

    await _addAuthInterceptor();
  }

  Future _addAuthInterceptor() async {
    SharedPreferences prefs;
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (Options options) async {
          if (prefs == null) {
            prefs = await SharedPreferences.getInstance();
          }
          /// 只要存在token，即设置为header
          String token = prefs.getString(LocalCacheKeys.loggedInToken);
          if (token != null) {
            options.headers.putIfAbsent('Authorization', () => token);
          }
        },
        onResponse: (result) {
          print(result);
        },
        onError: (e) {
          print(e);
          String cnMsg = e.message;
          var myError;
          switch (e.type) {
            case DioErrorType.CONNECT_TIMEOUT:
              cnMsg = '连接超时';
              break;
            case DioErrorType.SEND_TIMEOUT:
              cnMsg = '请求超时';
              break;
            case DioErrorType.RECEIVE_TIMEOUT:
              cnMsg = '响应超时';
              break;
            case DioErrorType.RESPONSE:
              switch (e.response.statusCode) {
                case 401:
                  cnMsg = '用户信息无效或过期，请重新登陆';
                  prefs.remove(LocalCacheKeys.isLoggedIn);
                  prefs.remove(LocalCacheKeys.loggedInToken);
                  myError = AuthException(message: cnMsg, statusCode: 401);
                  break;
                case 403:
                  cnMsg = '无权限访问';
                  myError = AuthException(message: cnMsg, statusCode: 403);
                  break;
                default:
                  cnMsg = '网络异常，请稍后再试';
                  break;
              }
              break;
            case DioErrorType.CANCEL:
              cnMsg = '请求取消';
              break;
            default:
              cnMsg = '未知错误';
              break;
          }
          if (myError == null) {
            myError = NetworkException(
              message: cnMsg,
              statusCode: e.response!=null?e.response.statusCode:null,
            );
          }
          return DioError(
            request: e.request,
            response: e.response,
            message: cnMsg,
            type: e.type,
            error: myError,
            stackTrace: e.stackTrace,
          );
        },
      ),
    );
  }

  Future<BasicDTO<T>> get<T>(
    String uri, {
    Map<String, dynamic> queryParameters,
    Options options,
    CancelToken cancelToken,
    ProgressCallback onReceiveProgress,
  }) async {
    var apiUrl = Config.inst.apiUrl;

    try {
      final Response response = await _dio.get(
        apiUrl + uri,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );

      return _handleResponse<T>(response);
    } on NoSuchMethodError catch(e){

    }on DioError catch (e) {
      Log.inst.error('GET:${e.toString()}');
      if(e.error is NetworkException){
        throw e.error;
      } else if (e.response == null){
        throw NetworkException(message: '网络出错，请查看您的连接', statusCode: 500);
      }
      throw NetworkException(message: e.message, statusCode: 0);
    } catch(e){
      throw BizException(message: e.message, statusCode: 0);
    }
  }

  Future<BasicDTO<T>> post<T>(
    String uri, {
    data,
    Map<String, dynamic> queryParameters,
    Options options,
    CancelToken cancelToken,
    ProgressCallback onSendProgress,
    ProgressCallback onReceiveProgress,
  }) async {
    try {
      var apiUrl = Config.inst.apiUrl;

      final Response response = await _dio.post(
        apiUrl + uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );

      return _handleResponse<T>(response);
    } on DioError catch (e) {
      Log.inst.error('POST:${e.toString()}');
      if(e.error is NetworkException){
        throw e.error;
      } else if (e.response == null){
        throw NetworkException(message: '网络出错，请查看您的连接', statusCode: 500);
      }
      throw NetworkException(message: e.message, statusCode: 0);
    } catch(e){
      throw BizException(message: e.message, statusCode: 0);
    }
  }

  Future<BasicDTO<T>> put<T>(
    String uri, {
    data,
    Map<String, dynamic> queryParameters,
    Options options,
    CancelToken cancelToken,
    ProgressCallback onSendProgress,
    ProgressCallback onReceiveProgress,
  }) async {
    try {
      var apiUrl = Config.inst.apiUrl;

      final Response response = await _dio.put(
        apiUrl + uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );

      return _handleResponse<T>(response);
    } on DioError catch (e) {
      Log.inst.error('PUT:${e.toString()}');
      if(e.error is NetworkException){
        throw e.error;
      } else if (e.response == null){
        throw NetworkException(message: '网络出错，请查看您的连接', statusCode: 500);
      }
      throw NetworkException(message: e.message, statusCode: 0);
    } catch(e){
      throw BizException(message: e.message, statusCode: 0);
    }
  }

  Future<BasicDTO<T>> delete<T>(
    String uri, {
    data,
    Map<String, dynamic> queryParameters,
    Options options,
    CancelToken cancelToken,
  }) async {
    try {
      var apiUrl = Config.inst.apiUrl;

      final Response response = await _dio.delete(
        apiUrl + uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );

      return _handleResponse<T>(response);
    } on DioError catch (e) {
      Log.inst.error('DELETE:${e.toString()}');
      if(e.error is NetworkException){
        throw e.error;
      } else if (e.response == null){
        throw NetworkException(message: '网络出错，请查看您的连接', statusCode: 500);
      }
      throw NetworkException(message: e.message, statusCode: 0);
    } catch(e){
      throw BizException(message: e.message, statusCode: 0);
    }
  }

  BasicDTO _handleResponse<T>(Response response) {
    var respCode = response.statusCode;
    if (respCode == 200) {
      return BasicDTO<T>.fromJson(response.data);
    }
    Log.inst.info("返回异常[$respCode]: ${response.data}");

    String msg;
    switch (respCode) {
      case 401:
      case 403:
        msg = "请重新登陆";
        throw AuthException(message: msg, statusCode: respCode);

      default:
        msg = '服务异常';
        throw BizException(message: msg, statusCode: respCode);
    }
  }

  Future<List<BasicDTO<T>>> waitRequest<T>(
      List<Future<Response>> requests) async {
    try {
      final List<Response> responses = await Future.wait(requests);
      List<BasicDTO<T>> results = List<BasicDTO<T>>();
      responses.forEach((item) {
        BasicDTO<T> basicDTO = _handleResponse<T>(item);
        results.add(basicDTO);
      });
      return results;
    } catch (e) {
      Log.inst.error(e.toString());
      throw NetworkException(message: e.message, statusCode: 0);
    }
  }

  List<Future<Response>> combine<T>(
      String uri, RequestType requestType, List<Future<Response>> requests,
      {data,
      Map<String, dynamic> queryParameters,
      Options options,
      CancelToken cancelToken}) {
    Future<Response> response;

    var apiUrl = Config.inst.apiUrl;
    switch (requestType) {
      case RequestType.GET:
        response = _dio.get(apiUrl + uri,
            queryParameters: queryParameters,
            options: options,
            cancelToken: cancelToken);
        break;
      case RequestType.POST:
        response = _dio.post(apiUrl + uri,
            data: data,
            queryParameters: queryParameters,
            options: options,
            cancelToken: cancelToken);
        break;
      case RequestType.PUT:
        response = _dio.put(apiUrl + uri,
            data: data,
            queryParameters: queryParameters,
            options: options,
            cancelToken: cancelToken);
        break;
      default:
        response = _dio.delete(apiUrl + uri,
            data: data,
            queryParameters: queryParameters,
            options: options,
            cancelToken: cancelToken);
        break;
    }
    requests.add(response);

    return requests;
  }
}
