import 'dart:convert';
import 'dart:io';
import 'package:app/utils/lib.dart';
import 'package:logger/logger.dart' as AppLogger;
import 'package:path_provider/path_provider.dart';

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

  static const String _TAG = "Logger";

  void e(String tag, String methodName, {String? message}) {
    _logger?.e("$tag : $methodName - $message");
    writeData("$tag | $methodName | $message | ${DateTime.now().millisecondsSinceEpoch} | ${AppConstants.appVersion}");
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
      writeData("$tag | $methodName | $message | ${DateTime.now().millisecondsSinceEpoch} | ${AppConstants.appVersion}");
    } else _logger?.w("$tag : $methodName");
  }

  static Future<String> get _localPath async {
    if (Platform.isIOS) return await getApplicationDocumentsDirectory().then((directory) => directory.path);
    return await getExternalStorageDirectory().then((directory) => directory!.path);
  }

  Future<File> get localFile async {
    final path = await _localPath;
    return File("$path/YCM_LOGS.txt");
  }

  void writeData(String? message) async {
    await localFile.then((file) {
      try {
        file.writeAsString("$message\n\n", encoding: Encoding.getByName("UTF-8")!, mode: FileMode.append);
      } catch (error) {
        d(_TAG, "writeData()", message: error.toString());
      }
    });
  }

  Future<String?> readData() async {
    try {
      final file = await localFile;
      String data = await file.readAsString();
      return data;
    } catch (error) {
      d(_TAG, "readData()", message: error.toString());
      return "Nothing saved yet";
    }
  }

  void clearData() async {
    await localFile.then((file) {
      try {
        file.openWrite();
      } catch (error) {
        d(_TAG, "clearData()", message: error.toString());
      }
    });
  }

}
