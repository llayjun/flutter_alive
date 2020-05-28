import 'package:logger/logger.dart';

enum LogLevel {
  debug,
  info,
  warn,
  error,
}

/// 日志包装类
class Log {
  static final Log inst = Log._();

  Logger _logger;

  Log._() {
    // 默认显示达到info级别的日志
    Logger.level = Level.info;

    _logger = Logger();
  }

  static Level _convertLevel(LogLevel orig) {
    switch (orig) {
      case LogLevel.debug:
        return Level.debug;
      case LogLevel.info:
        return Level.info;
      case LogLevel.warn:
        return Level.warning;
      case LogLevel.error:
        return Level.error;
      default:
        return Level.info;
    }
  }

  setLevel(LogLevel level) {
    Logger.level = _convertLevel(level);
  }

  debug(dynamic message, [dynamic error, StackTrace stackTrace]) {
    _logger.d(message, error, stackTrace);
  }

  info(dynamic message, [dynamic error, StackTrace stackTrace]) {
    _logger.i(message, error, stackTrace);
  }

  warn(dynamic message, [dynamic error, StackTrace stackTrace]) {
    _logger.w(message, error, stackTrace);
  }

  error(dynamic message, [dynamic error, StackTrace stackTrace]) {
    _logger.e(message, error, stackTrace);
  }
}
