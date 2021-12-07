import 'dart:io';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app/db/lib.dart';
import 'package:app/services/lib.dart';
import 'package:app/utils/lib.dart';

class SystemService {

  static SystemService? _instance;
  SystemService._();
  factory SystemService() => getInstance;

  static SystemService get getInstance {
    if (_instance == null) {
      _instance = new SystemService._();
    }
    return _instance!;
  }

  static const String _TAG = "SystemService";
  DatabaseManager _databaseManager = DatabaseManager.getInstance;
  //UserService _userService = UserService.getInstance;
  Logger _logger = Logger.getInstance;

  void init() async {
    try {
      await checkIfDbExist();
      await addTables();
      await alterTables();
      // SharedPreferences.getInstance().then((prefs) {
      //   AppConstants.showLiveData = prefs.getBool(PrefUtils.showLiveData) ?? true;
      //   AppConstants.preserveLogin = prefs.getInt(PrefUtils.preserveLogin) ?? 0;
      //   _logger.d(_TAG, "init()", message: "Preserve login status ${AppConstants.preserveLogin}.");
      // });
    } catch (error) {
      _logger.e(_TAG, "init()", message: error.toString());
    }
  }

  Future<void> checkIfDbExist() async {
    await _databaseManager.databaseExists().then((isExists) async {
      if (!isExists!) await _databaseManager.openDb;
    }).catchError((error) {
      _logger.e(_TAG, "checkIfDbExist()", message: error.toString());
    });
  }

  Future<void> addTables() async {
    _logger.i(_TAG, "addTables()");
    try {
      await _databaseManager.rawQuery("CREATE TABLE IF NOT EXISTS '${TableManager.MOVIES}' ( 'id' INTEGER PRIMARY KEY AUTOINCREMENT, 'name' TEXT NOT NULL, 'director' TEXT NOT NULL, 'poster' TEXT NOT NULL )");
    } catch (error) {
      _logger.e(_TAG, "addTables()", message: error.toString());
    }
  }

  Future<void> alterTables() async {
    _logger.i(_TAG, "alterTables()");
    try {
    } catch (error) {
      _logger.e(_TAG, "alterTables()", message: error.toString());
    }
  }

  void checkForPermissionsAndProceed(BuildContext context) async {
    try {
      if (!await PermissionUtils.checkForPermissions()) {
        if (!await PermissionUtils.requestAppPermissions()) {
          checkForPermissionsAndProceed(context);
        } else {
          //getServerDetailsFromDb();
          //_userService.checkUserLogin(context);
        }
      } else {
        //getServerDetailsFromDb();
        //_userService.checkUserLogin(context);
      }
      NavigationService.getInstance.dashboardActivity();
    }
    catch (error) {
      _logger.e(_TAG, "checkForPermissionsAndProceed()", message: error.toString());
    }
  }

  // Future<bool?> getServerDetailsFromDb() async {
  //   try {
  //     var result = await _databaseManager.query(TableManager.SERVER_CONFIG);
  //     if (result!.isNotEmpty) {
  //       var details = result.elementAt(result.length - 1);
  //       Config.registrationKey = details.values.toList().elementAt(0).toString();
  //       Config.serverUrl = details.values.toList().elementAt(1).toString();
  //       Config.registrationKeyStatus = details.values.toList().elementAt(2).toString();
  //       _logger.d(_TAG, "getServerDetailsFromDb()", message : "Server URL : ${Config.serverUrl}");
  //       return true;
  //     } else
  //       return false;
  //   } catch (error) {
  //     _logger.e(_TAG, "getServerDetailsFromDb()", message : error.toString());
  //     return false;
  //   }
  // }
  //
  // void addServerDetailsToDb(var response, var key) async {
  //   _logger.i(_TAG, "addServerDetailsToDb()", message: "Adding server details to database.");
  //   try {
  //     int? queryCount = await _databaseManager.queryRowCount(TableManager.SERVER_CONFIG);
  //     if (queryCount! > 0) {
  //       _databaseManager.rawQuery("DELETE FROM ${TableManager.SERVER_CONFIG}");
  //     }
  //     Map<String, dynamic> serverMap = {
  //       'registration_key': key,
  //       'server_name': response["servername"].toString(),
  //       'status': response["status"].toString(),
  //     };
  //     _databaseManager.insert(TableManager.SERVER_CONFIG, serverMap);
  //     Config.registrationKey = key;
  //     Config.serverUrl = response["servername"].toString();
  //     Config.registrationKeyStatus = response["status"].toString();
  //     //_logger.d(_TAG, "addServerDetailsToDb()", message: "App activated with activation key : $key");
  //   } catch (error) {
  //     _logger.e(_TAG, "addServerDetailsToDb()", message : error.toString());
  //   }
  // }

  // String? handleServerError(BuildContext context, String tag, String methodName, dynamic errors, bool showDialog) {
  //   String? error;
  //   bool? res = false;
  //   switch (errors) {
  //     case SyncErrors.SESSION_EXPIRED:
  //       error = StringUtils.getErrorString(SyncErrors.SESSION_EXPIRED, context);
  //       _logger.w(tag, methodName, message: "Login session expired.");
  //       if (showDialog) res = true;
  //       break;
  //     case SyncErrors.INVALID_TOKEN:
  //       error = StringUtils.getErrorString(SyncErrors.SESSION_EXPIRED, context);
  //       _logger.w(tag, methodName, message: "Login token invalid.");
  //       if (showDialog) res = true;
  //       break;
  //     case SyncErrors.STORES_NOT_SELECTED:
  //       error = StringUtils.getErrorString(SyncErrors.STORES_NOT_SELECTED, context);
  //       _logger.w(tag, methodName, message: "Stores not selected for displaying results.");
  //       break;
  //     case SyncErrors.SETTING_NOT_FOUND:
  //       error = StringUtils.getErrorString(SyncErrors.STORES_NOT_SELECTED, context);
  //       _logger.w(tag, methodName, message: "Stores not selected for displaying results.");
  //       break;
  //     case SyncErrors.TOKEN_NOT_PROVIDED:
  //       error = StringUtils.getErrorString(SyncErrors.NO_DATA_FOUND, context);
  //       _logger.w(tag, methodName, message: "Login token not provided.");
  //       if (showDialog) res = true;
  //       break;
  //     case SyncErrors.NO_DATA_FOUND:
  //       error = StringUtils.getErrorString(SyncErrors.NO_DATA_FOUND, context);
  //       _logger.w(tag, methodName, message: "No data found for selected terminals.");
  //       if (showDialog) res = false;
  //       break;
  //     case SyncErrors.INVALID_CHAIN_OWNER:
  //       error = StringUtils.getErrorString(SyncErrors.NO_DATA_FOUND, context);
  //       _logger.w(tag, methodName, message: "Invalid login username/password.");
  //       break;
  //     case SyncErrors.RESULT_ERROR:
  //       error = StringUtils.getErrorString(SyncErrors.RESULT_ERROR, context);
  //       _logger.w(tag, methodName, message: "Some error occurred.");
  //       break;
  //     default:
  //       error = StringUtils.getErrorString(SyncErrors.RESULT_ERROR, context);
  //       _logger.w(tag, methodName, message: "Some error occurred.");
  //       break;
  //   }
  //   if (showDialog) {
  //     AppConstants.isAlertShown = true;
  //     DialogService.getInstance.showAlertDialog(context, AppLocalization.of(context)?.translate("alert"), error, res: res);
  //   }
  //   return error;
  // }

  void shareLogs(BuildContext context) async {
    File logsFile = await Logger.getInstance.localFile;
    Share.shareFiles(
      [logsFile.path],
      subject: "KWANTA INSIGHTS ERROR LOGS",
    ).catchError((error) => _logger.e(_TAG, "shareLogs()", message: error.toString()));
  }

}