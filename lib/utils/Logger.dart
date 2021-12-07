import 'package:logger/logger.dart' as AppLogger;

class Logger {

  static Logger? _instance;
  Logger._();
  factory Logger() => getInstance;
  static AppLogger.Logger? _logger;

  static Logger get getInstance {
    if (_instance == null) {
      _instance = new Logger._();
      _logger = AppLogger.Logger();
    }
    return _instance!;
  }

  void e(String tag, String methodName, {String? message}) {
    _logger?.e("$tag : $methodName - $message");
  }

  void d(String tag, String methodName, {String? message}) {
    if (message != null) _logger?.d("$tag : $methodName - $message");
    else _logger?.d("$tag : $methodName");
  }

  void i(String tag, String methodName, {String? message}) {
    if (message != null) _logger?.i("$tag : $methodName - $message");
    else _logger?.i("$tag : $methodName");
  }

  void w(String tag, String methodName, {String? message}) {
    if (message != null) {
      _logger?.w("$tag : $methodName - $message");
    } else _logger?.w("$tag : $methodName");
  }

}
