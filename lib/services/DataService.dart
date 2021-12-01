import 'dart:io';

import 'package:app/data/lib.dart';
import 'package:app/db/lib.dart';
import 'package:app/services/lib.dart';
import 'package:app/utils/lib.dart';

class DataService {

  static DataService? _instance;
  DataService._();
  factory DataService() => getInstance;

  static DataService get getInstance {
    if (_instance == null) {
      _instance = new DataService._();
    }
    return _instance!;
  }

  static const String _TAG = "DataService";
  Logger _logger = Logger.getInstance;
  DatabaseManager _databaseManager = DatabaseManager.getInstance;

  Future<List<Movie>?> getMovieList({int? limit, int? offset}) async {
    List<Movie>? movieList = [];
    return await _databaseManager.getAll(TableManager.MOVIES, limit: limit, offset: offset).then((result) {
      if (result!.isNotEmpty) {
        for (var map in result) {
          movieList.add(Movie(name: map["name"], director: map["director"], poster: map["poster"]));
        }
      }
      return movieList;
    }).catchError((error) {
      _logger.e(_TAG, "getMovieList()", message: error.toString());
    }).whenComplete(() {
      return movieList;
    });
  }

  Future<void> addMovie({String? name, String? director, String? poster}) async {
    String imagePath = await ImageUtils.savePhotoFile(File(poster!));
    Map<String, dynamic> movieMap = Map();
    movieMap["name"] = name;
    movieMap["director"] = director;
    movieMap["poster"] = imagePath;
    _databaseManager.insert(TableManager.MOVIES, movieMap).catchError((error) {
      _logger.e(_TAG, "addMovie()", message: error.toString());
    }).whenComplete(() {
      NavigationService.getInstance.dashboardActivity();
    });
  }

  Future<List<Movie>?> editMovie({int? id, String? name, String? director, String? poster}) async {
    String imagePath = await ImageUtils.savePhotoFile(File(poster!));
    Map<String, dynamic> movieMap = Map();
    movieMap["id"] = id;
    movieMap["name"] = name;
    movieMap["director"] = director;
    movieMap["poster"] = imagePath;
    _databaseManager.update(TableManager.MOVIES, movieMap).catchError((error) {
      _logger.e(_TAG, "editMovie()", message: error.toString());
    }).whenComplete(() {
      NavigationService.getInstance.dashboardActivity();
    });
  }


}
//
//   StringBuffer? _postBody;
//   NetworkService _networkService = NetworkService.getInstance;
//   TerminalService _terminalService = TerminalService.getInstance;
//   ReportService _reportService = ReportService.getInstance;
//
//   Future<String?> validateRegistrationKey(String regKey) async {
//     _postBody = new StringBuffer();
//     try {
//       if (regKey.isNotEmpty) {
//         _postBody?.write("?actkey=" + regKey);
//       }
//       return await _networkService.validateRegistrationKey(_postBody.toString());
//     } catch (error) {
//       _logger.e(_TAG, "validateRegistrationKey()", message : error.toString());
//     }
//     return null;
//   }
//
//   Future<String?> validateChainOwnerLogin(String userName, String userPassword, String token) async {
//     try {
//       Map<String, dynamic> loginMap = Map();
//       loginMap["username"] = userName;
//       loginMap["pwd"] = userPassword;
//       loginMap["preserve_login"] = AppConstants.preserveLogin;
//       loginMap["google_token_id"] = token.toString();
//       //loginMap["timestamp"] = DateTime.now().millisecondsSinceEpoch.toString();
//       //_logger.d(_TAG, "validateChainOwnerLogin()", message: "Firebase Token : $token");
//       return _networkService.validateChainOwnerLogin(Config.serverUrl + Config.BASE_URL, SyncMethods.LOGIN_CHAIN_OWNER, jsonEncode(loginMap));
//     } catch (error) {
//       _logger.e(_TAG, "validateChainOwnerLogin()", message: error.toString());
//       return "";
//     }
//   }
//
//   Future<String?> loadReportData(String activityType, String date, String limit, {List<Map<String, dynamic>>? storeList}) async {
//     try {
//       Map<String, dynamic> storeMap = Map();
//       storeMap["chain_owner_id"] = Config.chainOwnerId;
//       storeMap["activity"] = activityType;
//       storeMap["date"] = date;
//       storeMap["limit"] = limit;
//       storeMap["timestamp"] = DateTime.now().millisecondsSinceEpoch.toString();
//       storeMap["token"] = Config.sessionToken;
//       storeMap["employee_id"] = Config.employeeId;
//       storeMap["google_token_id"] = Config.googleTokenId;
//       storeMap["last_seen"] = false; //DateFormat(AppConstants.DATE_FORMAT_4).format(DateTime.now());
//       if (AppConstants.LIMIT_LIVE_NULL == limit) storeMap["last_seen"] = true;
//       if (storeList != null) {
//         storeMap["store_list"] = storeList;
//         return await _networkService.loadReportData(Config.serverUrl + Config.BASE_URL, SyncMethods.LOAD_REPORT_DATA, jsonEncode(storeMap));
//       } else {
//         return await _terminalService.getTerminalDetailsFromDb(forServer: false).then((result) async {
//           storeMap["store_list"] = result;
//           return await _networkService.loadReportData(Config.serverUrl + Config.BASE_URL, SyncMethods.LOAD_REPORT_DATA, jsonEncode(storeMap));
//         });
//       }
//     } catch (error) {
//       _logger.e(_TAG, "loadReportData()", message : error.toString());
//       return null;
//     }
//   }
//
//   Future<String?> loadDailyStatistics() async {
//     try {
//       Map<String, dynamic> storeMap = Map();
//       storeMap["chain_owner_id"] = Config.chainOwnerId;
//       storeMap["timestamp"] = DateTime.now().millisecondsSinceEpoch.toString();
//       storeMap["date"] = DateFormat(AppConstants.DATE_FORMAT_3).format(DateTime.now()).toString();
//       storeMap["token"] = Config.sessionToken;
//       storeMap["employee_id"] = Config.employeeId;
//       //_logger.d(_TAG, "Google token Id printed for debugging : " + Config.googleTokenId);
//       return await _terminalService.getTerminalDetailsFromDb(forServer: false).then((result) async {
//         if (result!.isNotEmpty) {
//           storeMap["store_list"] = result;
//           return await _networkService.loadDailyStatistics(Config.serverUrl + Config.BASE_URL, SyncMethods.GET_DAILY_STATISTICS, jsonEncode(storeMap));
//         } else return "";
//       });
//     } catch (error) {
//       _logger.e(_TAG, "loadDailyStatistics()", message : error.toString());
//       return "";
//     }
//   }
//
//   Future<String?> setPreserveLogin() async{
//     try {
//       Map<String, dynamic> preserveMap = Map();
//       preserveMap["chain_owner_id"] = Config.chainOwnerId;
//       preserveMap["token"] = Config.sessionToken;
//       preserveMap["employee_id"] = Config.employeeId;
//       preserveMap["preserve_login"] = AppConstants.preserveLogin;
//       return _networkService.setPreserveLogin(Config.serverUrl + Config.BASE_URL, SyncMethods.PRESERVE_LOGIN, jsonEncode(preserveMap));
//     } catch (error) {
//       _logger.e(_TAG, "setPreserveLogin()", message : error.toString());
//       return "";
//     }
//   }
//
//   Future<String?> setFirebaseToken(String token) async{
//     Future<String?>? response;
//     try {
//       Map<String, dynamic> preserveMap = Map();
//       preserveMap["chain_owner_id"] = Config.chainOwnerId;
//       preserveMap["token"] = Config.sessionToken;
//       preserveMap["employee_id"] = Config.employeeId;
//       preserveMap["firebase_token"] = token;
//       response = _networkService.setFirebaseToken(Config.serverUrl + Config.BASE_URL, SyncMethods.SET_FIREBASE_TOKEN, jsonEncode(preserveMap));
//       return response;
//     } catch (error) {
//       _logger.e(_TAG, "setPreserveLogin()", message : error.toString());
//       return "";
//     }
//     return response;
//   }
//
//   Future<String?> logoutChainOwner() async{
//     Future<String?>? response;
//     try {
//       Map<String, dynamic> logoutMap = Map();
//       logoutMap["chain_owner_id"] = Config.chainOwnerId;
//       logoutMap["token"] = Config.sessionToken;
//       logoutMap["employee_id"] = Config.employeeId;
//       logoutMap["all_devices"] = AppConstants.allDevices;
//       response = _networkService.logoutChainOwner(Config.serverUrl + Config.BASE_URL, SyncMethods.LOGOUT_CHAIN_OWNER, jsonEncode(logoutMap));
//       return response;
//     } catch (error) {
//       _logger.e(_TAG, "logoutChainOwner()", message : error.toString());
//     }
//     return response;
//   }
//
//   Future<String?> saveUserSettings() async{
//     Future<String?>? response;
//     try {
//       Map<String, dynamic> settingsMap = Map();
//       Map<String, dynamic> userSettings = Map();
//       settingsMap["chain_owner_id"] = Config.chainOwnerId;
//       settingsMap["token"] = Config.sessionToken;
//       settingsMap["employee_id"] = Config.employeeId;
//       await _terminalService.getTerminalDetailsFromDb(forServer: true).then((result) async{
//         userSettings["store_selection"] = result;
//         await _reportService.getReportsListForSettings().then((result) {
//           userSettings["report_settings"] = result;
//           settingsMap["settings"] = userSettings;
//           response = _networkService.saveUserSettings(Config.serverUrl + Config.BASE_URL, SyncMethods.SAVE_USER_SETTINGS, jsonEncode(settingsMap));
//         });
//       });
//       return response;
//     } catch (error) {
//       _logger.e(_TAG, "saveUserSettings()", message : error.toString());
//     }
//     return response;
//   }
//
//   Future<String?> saveReportLastSeen() async{
//     Future<String?>? response;
//     try {
//       Map<String, dynamic> settingsMap = Map();
//       Map<String, dynamic> userSettings = Map();
//       settingsMap["chain_owner_id"] = Config.chainOwnerId;
//       settingsMap["token"] = Config.sessionToken;
//       settingsMap["employee_id"] = Config.employeeId;
//       await _terminalService.getTerminalDetailsFromDb(forServer: true).then((result) async{
//         userSettings["store_selection"] = result;
//         await _reportService.getReportsListForSettings().then((result) {
//           userSettings["report_settings"] = result;
//           settingsMap["settings"] = userSettings;
//           response = _networkService.saveUserSettings(Config.serverUrl + Config.BASE_URL, SyncMethods.SAVE_REPORT_LAST_SEEN, jsonEncode(settingsMap));
//         });
//       });
//       return response;
//     } catch (error) {
//       _logger.e(_TAG, "saveUserSettings()", message : error.toString());
//     }
//     return response;
//   }
//
//   Future<String?> sync(String syncType) async {
//     Future<String?>? response;
//     try {
//       Map<String, dynamic> logoutMap = Map();
//       logoutMap["chain_owner_id"] = Config.chainOwnerId;
//       logoutMap["token"] = Config.sessionToken;
//       logoutMap["employee_id"] = Config.employeeId;
//       logoutMap["sync_type"] = syncType;
//       response = _networkService.sync(Config.serverUrl + Config.BASE_URL, SyncMethods.SYNC, jsonEncode(logoutMap));
//       return response;
//     } catch (error) {
//       _logger.e(_TAG, "sync()", message : error.toString());
//     }
//     return response;
//   }
//
// }