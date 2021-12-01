// import 'package:kwanta_insights/sync/lib.dart';
// import 'package:kwanta_insights/utils/lib.dart';
//
// class NetworkService {
//
//   static NetworkService? _instance;
//   NetworkService._();
//   factory NetworkService() => getInstance;
//
//   static NetworkService get getInstance {
//     if (_instance == null) {
//       _instance = new NetworkService._();
//     }
//     return _instance!;
//   }
//
//   static const String _TAG = "NetworkService";
//   SyncCommunication _syncCommunication = SyncCommunication.getInstance;
//   Logger _logger = Logger.getInstance;
//
//   ///URL : http://test2.kwanta.at/kwanta_logs/Activity_mobile/do_login
//   ///BODY : {"username":"Mekosa","pwd":"admin","preserve_login":0}
//   ///RESPONSE : {result: 1, username: MeKosa, first_name: SugarNail, last_name: Lounge, chain_owner_id: 267, employee_id: 440, token: e1d15f03d595497ad0085e5c0b55ab46, stores: [{store_id: 307, store_name: SugarNail Lounge, email_address: melanie.kosa92@outlook.com, mobile: 06764508637, terminals: [{id: 2000, terminal_id: 2, name: SGST2}]}]}
//   Future<String?> validateChainOwnerLogin(String baseUrl, String url, String body) async {
//     return await _syncCommunication.postJSON(baseUrl + url , body).catchError((error) {
//       _logger.e(_TAG, "validateChainOwnerLogin()", message: error.toString());
//       return null;
//     });
//   }
//
//   ///URL : http://test2.kwanta.at/kwanta_logs/Registration_Api/validateKey?actkey=s4y9q8aq8q
//   ///RESPONSE : {result: 1, msg: {status: Active, servername: http://test2.kwanta.at/}}
//   Future<String?> validateRegistrationKey(String body) async {
//     return await _syncCommunication.post(Config.REGISTRATION_URL + SyncMethods.VALIDATE_KEY + body).catchError((error) {
//       _logger.e(_TAG, "validateRegistrationKey()", message: error.toString());
//       return null;
//     });
//   }
//
//   ///URL : http://test2.kwanta.at/kwanta_logs/Activity_mobile/get_report_data
//   ///BODY : {"chain_owner_id":"267","activity":"","date":"2020-06-23","limit":"1","timestamp":"1592900903584","token":"e1d15f03d595497ad0085e5c0b55ab46","employee_id":"440","store_list":[{"store_id":"307","terminal_list":[{"terminal_id":"2","row_id":"2000"}]}]}
//   ///RESPONSE : {"result":1,"msg":[{"activity":"enters setting menu in app","time_stamp":"23.06.2020 12:02:48","user_name":"Melanie","origin":"---","order_details":"---"},{"activity":"creates bill","time_stamp":"23.06.2020 12:02:42","user_name":"User2","origin":"UI","order_details":"1x:St. 5centItem:20,00|1x:St. 8centv:15,00|"},{"activity":"enters table","time_stamp":"23.06.2020 12:02:37","user_name":"User2","origin":"---","order_details":"---"}]}
//   Future<String?> loadReportData(String baseUrl, String url, String body) async {
//     return await _syncCommunication.postJSON(baseUrl + url, body).catchError((error) {
//       _logger.e(_TAG, "loadReportData()", message: error.toString());
//       return null;
//     });
//   }
//
//   ///URL : http://test2.kwanta.at/kwanta_logs/Activity_mobile/get_daily_statistics
//   ///BODY : {"chain_owner_id":"267","timestamp":"1592901648683","token":"abe31211a89d61cc6e48d58477d990cc","employee_id":"440","store_list":[{"store_id":"307","terminal_list":[{"terminal_id":"2","row_id":"2000"}]}]}
//   ///RESPONSE : {"result":1,"msg":{"stores":1,"all_users":"3","terminals":1,"turnover":80,"open_orders_count":"0","open_orders_total":"0.000"}}
//   Future<String?> loadDailyStatistics(String baseUrl, String url, String body) async {
//     return await _syncCommunication.postJSON(baseUrl + url, body).catchError((error) {
//       _logger.e(_TAG, "loadDailyStatistics()", message: error.toString());
//       return null;
//     });
//   }
//
//   ///URL : http://test2.kwanta.at/kwanta_logs/Activity_mobile/set_preserve_login
//   ///BODY : {"chain_owner_id":"267","token":"abe31211a89d61cc6e48d58477d990cc","employee_id":"440","preserve_login":0}
//   ///RESPONSE : {result: 1, msg: Preserve login flag is set}
//   Future<String?> setPreserveLogin(String baseUrl, String url, String body) async {
//     return await _syncCommunication.postJSON(baseUrl + url, body).catchError((error) {
//       _logger.e(_TAG, "setPreserveLogin()", message: error.toString());
//       return null;
//     });
//   }
//
//   ///URL : http://test2.kwanta.at/kwanta_logs/Activity_mobile/set_firebase_token
//   ///BODY : {"chain_owner_id":"267","token":"abe31211a89d61cc6e48d58477d990cc","employee_id":"440","firebase_token":34dffgh546756fgjhg33dasdfasf0}
//   ///RESPONSE : {result: 1, msg: Preserve login flag is set}
//   Future<String?> setFirebaseToken(String baseUrl, String url, String body) async {
//     return await _syncCommunication.postJSON(baseUrl + url, body).catchError((error) {
//       _logger.e(_TAG, "setPreserveLogin()", message: error.toString());
//       return null;
//     });
//   }
//
//   ///URL : http://test2.kwanta.at/kwanta_logs/Activity_mobile/logout_chain_owner
//   ///BODY : {"chain_owner_id":"267","token":"7175220f628e8b5a1422423204e691b6","employee_id":"440","all_devices":0}
//   ///RESPONSE : {"result":1,"msg":"Logged out successfully"}
//   Future<String?> logoutChainOwner(String baseUrl, String url, String body) async {
//     return await _syncCommunication.postJSON(baseUrl + url, body).catchError((error) {
//       _logger.e(_TAG, "logoutChainOwner()", message: error.toString());
//       return null;
//     });
//   }
//
//   ///URL : http://test2.kwanta.at/kwanta_logs/Activity_mobile/save_user_settings
//   ///BODY : {"chain_owner_id":"267","token":"96de616fc9d85587aafc144f404d8934","employee_id":"440","settings":[{"id":1,"name":"user_logins","is_visible":1,"is_notify":0},{"id":2,"name":"create_orders","is_visible":0,"is_notify":0},{"id":3,"name":"cancel_orders","is_visible":1,"is_notify":0},{"id":4,"name":"create_bills","is_visible":1,"is_notify":0},{"id":5,"name":"cancel_bills","is_visible":0,"is_notify":0},{"id":6,"name":"table_entry","is_visible":1,"is_notify":0},{"id":7,"name":"open_order_tab","is_visible":0,"is_notify":0}]}
//   ///RESPONSE : {"result":1,"msg":"User settings are saved"}
//   Future<String?> saveUserSettings(String baseUrl, String url, String body) async {
//     return await _syncCommunication.postJSON(baseUrl + url, body).catchError((error) {
//       _logger.e(_TAG, "saveUserSettings()", message: error.toString());
//       return null;
//     });
//   }
//
//   ///URL : http://test2.kwanta.at/kwanta_logs/Activity_mobile/sync
//   ///BODY : {"chain_owner_id":"267","token":"96de616fc9d85587aafc144f404d8934","employee_id":"440","settings":[{"id":1,"name":"user_logins","is_visible":1,"is_notify":0},{"id":2,"name":"create_orders","is_visible":0,"is_notify":0},{"id":3,"name":"cancel_orders","is_visible":1,"is_notify":0},{"id":4,"name":"create_bills","is_visible":1,"is_notify":0},{"id":5,"name":"cancel_bills","is_visible":0,"is_notify":0},{"id":6,"name":"table_entry","is_visible":1,"is_notify":0},{"id":7,"name":"open_order_tab","is_visible":0,"is_notify":0}]}
//   ///RESPONSE : {"result":1,"msg":"User settings are saved"}
//   Future<String?> sync(String baseUrl, String url, String body) async {
//     return await _syncCommunication.postJSON(baseUrl + url, body).catchError((error) {
//       _logger.e(_TAG, "sync()", message: error.toString());
//       return null;
//     });
//   }
//
// }