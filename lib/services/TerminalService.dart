// import 'package:kwanta_insights/data/lib.dart';
// import 'package:kwanta_insights/database/lib.dart';
// import 'package:kwanta_insights/utils/lib.dart';
//
// class TerminalService {
//
//   static TerminalService? _instance;
//   TerminalService._();
//   factory TerminalService() => getInstance;
//
//   static TerminalService get getInstance {
//     if (_instance == null) {
//       _instance = new TerminalService._();
//     }
//     return _instance!;
//   }
//
//   static const String _TAG = "TerminalService";
//   DatabaseManager _databaseManager = DatabaseManager.getInstance;
//   Logger _logger = Logger.getInstance;
//
//   Future<void> addTerminalDetailsToDb(var storeList) async {
//     _logger.i(_TAG, "addTerminalDetailsToDb()", message: "Adding terminal details to database.");
//     try {
//       for (var store in storeList) {
//         var storeId = store["store_id"].toString();
//         var terminalList = store["terminals"];
//         var usersList = store["users"];
//         var storeMap = <String, dynamic>{
//           'id': storeId,
//           'name': store["store_name"].toString(),
//           'email': store["email_address"].toString(),
//           'mobile': store["mobile"].toString(),
//         };
//         _databaseManager.insert(TableManager.STORES, storeMap);
//         if (terminalList != null && terminalList != "") {
//           for (var terminal in terminalList) {
//             var terminalMap = <String, dynamic>{
//               'terminal_id': terminal["terminal_id"].toString(),
//               'name': terminal["name"].toString(),
//               'store_id': storeId,
//               'row_id': terminal["id"].toString(),
//               'is_selected': 0
//             };
//             _databaseManager.insert(TableManager.TERMINALS, terminalMap);
//           }
//         }
//
//       }
//       _logger.d(_TAG, "addTerminalDetailsToDb()", message: "Added terminals successfully.");
//     } catch (error) {
//       _logger.e(_TAG, "addTerminalDetailsToDb()", message: error.toString());
//     }
//   }
//
//   Future<List<Map<String, dynamic>>?> getTerminalDetailsFromDb({bool? forServer}) async {
//     //_logger.i(_TAG, "getTerminalDetailsFromDb()", message: "Getting terminal details from database.");
//     var storeId = "";
//     var result;
//     var userResult;
//     List<Map<String, dynamic>> serverMap = [];
//     Map<String, dynamic>? storeMap;
//     List<Map<String, dynamic>>? terminalList;
//     List<Map<String, dynamic>>? userList;
//     Map<String, dynamic>? terminalMap;
//     Map<String, dynamic>? userMap;
//     try {
//       if (!forServer!) {
//         //result = await _databaseManager.queryTable(TableManager.TERMINALS, distinct: true, columns: ["terminal_id, store_id, row_id"], where: "is_selected =?", whereArgs: [1], orderBy: "store_id");
//         result = await _databaseManager.rawQuery("SELECT DISTINCT term.terminal_id, term.store_id, term.row_id FROM " + TableManager.TERMINALS + " term left join " + TableManager.STORES + " store on term.store_id = store.id WHERE term.is_selected = 1 AND store.is_selected = 1");
//         userResult = await _databaseManager.rawQuery("SELECT * FROM " + TableManager.USERS + " WHERE is_selected = 1");
//         for (var map in result) {
//           if (map["store_id"].toString() != storeId) {
//             if (storeMap != null && storeMap.isNotEmpty) {
//               serverMap.add(storeMap);
//             }
//             storeId = map["store_id"].toString();
//             storeMap = Map();
//             terminalList = [];
//             storeMap["store_id"] = storeId;
//           }
//           terminalMap = Map();
//           terminalMap["terminal_id"] = map["terminal_id"];
//           terminalMap["row_id"] = map["row_id"];
//           terminalList?.add(terminalMap);
//           storeMap?["terminal_list"] = terminalList;
//           userList = [];
//
//           for (var user in userResult) {
//             if (user["store_id"] == map["store_id"]) {
//               userMap = Map();
//               userMap["id"] = user["id"];
//               userList.add(userMap);
//             }
//           }
//           storeMap?["user_list"] = userList;
//         }
//
//         if (storeMap != null && storeMap.isNotEmpty) {
//           serverMap.add(storeMap);
//         }
//       } else {
//         result = await _databaseManager.queryTable(TableManager.TERMINALS, distinct: true);
//         userResult = await _databaseManager.rawQuery("SELECT * FROM " + TableManager.USERS + " WHERE is_selected = 1");
//         for (var map in result) {
//           if (map["store_id"].toString() != storeId) {
//             if (storeMap != null && storeMap.isNotEmpty) {
//               serverMap.add(storeMap);
//             }
//             storeId = map["store_id"].toString();
//             storeMap = Map();
//             terminalList = [];
//             storeMap["store_id"] = storeId;
//             await _databaseManager.queryTable(TableManager.STORES, distinct: true, where: "id =?", whereArgs: [storeId]).then((result) {
//               storeMap?["store_name"] = result?[0]["name"];
//               storeMap?["email_address"] = result?[0]["email"];
//               storeMap?["mobile"] = result?[0]["mobile"];
//               storeMap?["is_selected"] = result?[0]["is_selected"];
//             });
//           }
//           terminalMap = Map();
//           terminalMap["terminal_id"] = map["terminal_id"];
//           terminalMap["id"] = map["row_id"];
//           terminalMap["name"] = map["name"];
//           terminalMap["is_selected"] = map["is_selected"];
//           terminalList?.add(terminalMap);
//           storeMap?["terminals"] = terminalList;
//           userList = [];
//
//           for (var user in userResult) {
//             if (user["store_id"] == map["store_id"]) {
//               userMap = Map();
//               userMap["id"] = user["id"];
//               userList.add(userMap);
//             }
//           }
//           storeMap?["user_list"] = userList;
//         }
//
//         if (storeMap != null && storeMap.isNotEmpty) {
//           serverMap.add(storeMap);
//         }
//       }
//       return serverMap;
//     } catch (error) {
//       _logger.e(_TAG, "getTerminalDetailsFromDb()", message: error.toString());
//       return null;
//     }
//   }
//
//   Future<List<Map<String, dynamic>>?> getTerminalJSON(String storeId, String terminalId, {String? userName}) async {
//     //_logger.d(_TAG, "getTerminalJSON()", message: "Creating JSON for store.");
//     var result = await _databaseManager.queryTable(TableManager.TERMINALS, distinct: true, where: "store_id =? AND terminal_id =?", whereArgs: [storeId, terminalId]);
//     List<Map<String, dynamic>> serverMap = [];
//     Map<String, dynamic> storeMap = Map();
//     List<Map<String, dynamic>> terminalList = [];
//     Map<String, dynamic> terminalMap = Map();
//     try {
//       storeMap["store_id"] = result?[0]["store_id"];
//       terminalMap["terminal_id"] = result?[0]["terminal_id"];
//       terminalMap["row_id"] = result?[0]["row_id"];
//       if (userName != null && userName != "") terminalMap["user_name"] = userName;
//       terminalList.add(terminalMap);
//       storeMap["terminal_list"] = terminalList;
//       serverMap.add(storeMap);
//       //_logger.d(_TAG, "getTerminalJSON()", message: "Server Map " + serverMap.toString());
//       return serverMap;
//     } catch (error) {
//       _logger.e(_TAG, "getTerminalJSON()", message: error.toString());
//       return null;
//     }
//   }
//
//   Future<List<Store>?> getStoreList() async {
//     List<Store>? list;
//     try {
//       var result = await _databaseManager.query(TableManager.STORES, distinct: true);
//       list = result!.isNotEmpty ? result.map((c) => Store.fromMap(c)).toList() : null;
//       return list;
//     } catch (error) {
//       _logger.e(_TAG, "getStoreList()", message: error.toString());
//       return null;
//     }
//   }
//
//   Future<List<User>?> getUsersList() async {
//     List<User>? list;
//     try {
//       var result = await _databaseManager.query(TableManager.USERS, distinct: true);
//       list = result!.isNotEmpty ? result.map((c) => User.fromMap(c)).toList() : null;
//       return list;
//     } catch (error) {
//       _logger.e(_TAG, "getUsersList()", message: error.toString());
//       return null;
//     }
//   }
//
//   Future<List<Terminal>?> getTerminalList(String id) async {
//     List<Terminal>? list;
//     try {
//       var result = await _databaseManager.queryTable(TableManager.TERMINALS, distinct: true, where: "store_id =?", whereArgs: [id]);
//       list = result!.isNotEmpty ? result.map((c) => Terminal.fromMap(c)).toList() : null;
//       return list;
//     } catch (error) {
//       _logger.e(_TAG, "getTerminalList()", message: error.toString());
//       return null;
//     }
//   }
//
//   Future<List<Terminal>?> getAllTerminalList() async {
//     List<Terminal>? list;
//     try {
//       var result = await _databaseManager.queryTable(TableManager.TERMINALS, distinct: true);
//       list = result!.isNotEmpty ? result.map((c) => Terminal.fromMap(c)).toList() : null;
//       return list;
//     } catch (error) {
//       _logger.e(_TAG, "getAllTerminalList()", message: error.toString());
//       return null;
//     }
//   }
//
//   Future<List<Store>?> getFilteredStoreList() async {
//     List<Store>? list;
//     try {
//       var result = await _databaseManager.rawQueryList("SELECT DISTINCT store.id, store.name, store.email, store.mobile, store.is_selected FROM " + TableManager.STORES + " store left join " + TableManager.TERMINALS + " terminal on store.id = terminal.store_id WHERE terminal.is_selected = 1");
//       list = result!.isNotEmpty ? result.map((c) => Store.fromMap(c)).toList() : null;
//       return list;
//     } catch (error) {
//       _logger.e(_TAG, "getFilteredStoreList()", message: error.toString());
//       return null;
//     }
//   }
//
//   Future<List<Terminal>?> getFilteredTerminalList(String id) async {
//     List<Terminal>? list;
//     try {
//       var result = await _databaseManager.queryTable(TableManager.TERMINALS, distinct: true, where: "store_id =? AND is_selected =?", whereArgs: [id, 1]);
//       list = result!.isNotEmpty ? result.map((c) => Terminal.fromMap(c)).toList() : null;
//       return list;
//     } catch (error) {
//       _logger.e(_TAG, "getFilteredTerminalList()", message: error.toString());
//       return null;
//     }
//   }
//
//   Future<bool?> compareSettingsWithStores(var storeSelection, var stores) async {
//
//     List<User> userSelectionList = [];
//     List<Store> storeSelectionList = [];
//     List<Terminal> terminalSelectionList = [];
//
//     List<String> userSelectionIdList = [];
//     List<String> storeSelectionIdList = [];
//     List<String> terminalSelectionIdList = [];
//
//     List<User> userList = [];
//     List<Store> storeList = [];
//     List<Terminal> terminalList = [];
//
//     List<String> userIdList = [];
//     List<String> storesIdList = [];
//     List<String> terminalIdList = [];
//
//     try {
//       //create list of stores, terminals and users from settings
//       if (storeSelection != null) {
//         for (Map map in storeSelection) {
//           Map<String, dynamic> storeMap = Map();
//           storeMap["id"] = map["store_id"].toString();
//           storeMap["name"] = map["store_name"].toString();
//           storeMap["email"] = map["email_address"].toString();
//           storeMap["mobile"] = map["mobile"].toString();
//
//           if (map.containsKey("is_selected"))
//             storeMap["is_selected"] = map["is_selected"];
//
//           try {
//             if (map["terminals"] != null) {
//               for (var terminals in map["terminals"]) {
//                 Map<String, dynamic> terminalMap = Map();
//                 terminalMap["store_id"] = map["store_id"].toString();
//                 terminalMap["terminal_id"] = terminals["terminal_id"].toString();
//                 terminalMap["row_id"] = terminals["id"].toString();
//                 terminalMap["name"] = terminals["name"];
//                 terminalMap["is_selected"] = terminals["is_selected"];
//                 terminalSelectionList.add(Terminal.fromMap(terminalMap));
//               }
//             }
//             if (map["users"] != null) {
//               for (var users in map["users"]) {
//                 Map<String, dynamic> userMap = Map();
//                 userMap["store_id"] = map["store_id"].toString();
//                 userMap["id"] = users["id"].toString();
//                 userMap["name"] = users["name"];
//                 userMap["is_selected"] = users["is_selected"] ?? 1;
//                 userSelectionList.add(User.fromMap(userMap));
//               }
//             }
//           } catch (error) {
//             _logger.e(_TAG, "storeSelection", message: error.toString());
//           }
//           storeSelectionList.add(Store.fromMap(storeMap));
//         }
//       }
//
//       //create list of stores & terminals from template
//       if (stores != null) {
//         for (Map map in stores) {
//           Map<String, dynamic> storeMap = Map();
//           storeMap["id"] = map["store_id"].toString();
//           storeMap["name"] = map["store_name"].toString();
//           storeMap["email"] = map["email_address"].toString();
//           storeMap["mobile"] = map["mobile"].toString();
//           storeMap["is_selected"] = 0;
//           try {
//             if (map["terminals"] != null) {
//               for (var terminals in map["terminals"]) {
//                 Map<String, dynamic> terminalMap = Map();
//                 terminalMap["store_id"] = map["store_id"].toString();
//                 terminalMap["terminal_id"] = terminals["terminal_id"].toString();
//                 terminalMap["row_id"] = terminals["id"].toString();
//                 terminalMap["name"] = terminals["name"];
//                 terminalMap["is_selected"] = 0;
//                 terminalList.add(Terminal.fromMap(terminalMap));
//               }
//             }
//             if (map["users"] != null) {
//               for (var users in map["users"]) {
//                 Map<String, dynamic> userMap = Map();
//                 userMap["store_id"] = map["store_id"].toString();
//                 userMap["id"] = users["id"].toString();
//                 userMap["name"] = users["name"];
//                 userMap["is_selected"] = users["is_selected"] ?? 1;
//                 userList.add(User.fromMap(userMap));
//               }
//             }
//           } catch (error) {
//             _logger.e(_TAG, "storeMap", message: error.toString());
//           }
//           storeList.add(Store.fromJson(storeMap));
//         }
//       }
//
//       //create list for only store ids to compare
//       for (var store in storeSelectionList) {
//         storeSelectionIdList.add(store.id!);
//       }
//       for (var store in storeList) {
//         storesIdList.add(store.id!);
//       }
//       for (var user in userList) {
//         userIdList.add(user.id!);
//       }
//
//       //create list for only terminal ids to compare
//       for (var terminal in terminalSelectionList) {
//         terminalSelectionIdList.add(terminal.terminalId!);
//       }
//       for (var terminal in terminalList) {
//         terminalIdList.add(terminal.terminalId!);
//       }
//
//       //compare both store list for differences
//       for (var storeId in storeSelectionIdList) {
//         if (!storesIdList.contains(storeId)) {
//           storeSelectionList.removeWhere((s) => s.id == storeId);
//         } else {
//           storeList.removeWhere((s) => s.id == storeId);
//         }
//       }
//
//       //compare both terminal list for differences
//       for (var terminalId in terminalSelectionIdList) {
//         if (!terminalIdList.contains(terminalId)) {
//           terminalSelectionList.removeWhere((t) => t.terminalId == terminalId);
//         } else {
//           terminalList.removeWhere((t) => t.terminalId == terminalId);
//         }
//       }
//
//       //compare both user list for differences
//       for (var userId in userSelectionIdList) {
//         if (!userIdList.contains(userId)) {
//           userSelectionList.removeWhere((u) => u.id == userId);
//         } else {
//           userList.removeWhere((u) => u.id == userId);
//         }
//       }
//
//       //_logger.d(_TAG, "compareSettingsWithStores()", message: "STORES LIST : ${storeList.length}");
//       //_logger.d(_TAG, "compareSettingsWithStores()", message: "STORES SETTINGS LIST : ${storeSelectionList.length}");
//       //_logger.d(_TAG, "compareSettingsWithStores()", message: "TERMINAL LIST : ${terminalList.length}");
//       //_logger.d(_TAG, "compareSettingsWithStores()", message: "TERMINAL SETTINGS LIST : ${terminalSelectionList.length}");
//       //_logger.d(_TAG, "compareSettingsWithStores()", message: "USER LIST : ${userList.length}");
//       //_logger.d(_TAG, "compareSettingsWithStores()", message: "USER SETTINGS LIST : ${userSelectionList.length}");
//
//       _logger.i(_TAG, "compareSettingsWithStores()", message: "Adding stores settings to database.");
//       await _databaseManager.delete(TableManager.STORES).then((_) {
//         if (storeSelectionList.isNotEmpty)
//           for (var stores in storeSelectionList) {
//             _databaseManager.insert(TableManager.STORES, stores.toMap());
//           }
//         if (storeList.isNotEmpty)
//           for (var stores in storeList) _databaseManager.insert(TableManager.STORES, stores.toMap());
//         _logger.i(_TAG, "compareSettingsWithStores()", message: "Added stores successfully.");
//       });
//
//       _logger.i(_TAG, "compareSettingsWithStores()", message: "Adding terminal settings to database.");
//       await _databaseManager.delete(TableManager.TERMINALS).then((_) {
//         if (terminalSelectionList.isNotEmpty)
//           for (var terminals in terminalSelectionList) {
//             _databaseManager.insert(TableManager.TERMINALS, terminals.toMap());
//           }
//         if (terminalList.isNotEmpty)
//           for (var terminals in terminalList)
//             _databaseManager.insert(TableManager.TERMINALS, terminals.toMap());
//         _logger.i(_TAG, "compareSettingsWithStores()", message: "Adding terminal successfully.");
//       });
//
//       _logger.i(_TAG, "compareSettingsWithStores()", message: "Adding user settings to database.");
//       await _databaseManager.delete(TableManager.USERS).then((_) {
//         if (userSelectionList.isNotEmpty)
//           for (var users in userSelectionList) {
//             _databaseManager.insert(TableManager.USERS, users.toMap());
//           }
//         if (userList.isNotEmpty)
//           for (var users in userList)
//             _databaseManager.insert(TableManager.USERS, users.toMap());
//         _logger.i(_TAG, "compareSettingsWithStores()", message: "Adding users successfully.");
//       });
//
//     } catch (error) {
//       _logger.e(_TAG, "compareSettingsWithStores()", message: error.toString());
//     }
//     return true;
//   }
//
//   Future<bool?> storeIsSelectedUpdate(bool value, Store store) async {
//     try {
//       await DatabaseManager.getInstance.rawQuery("UPDATE ${TableManager.STORES} SET is_selected = '${StringUtils.getIntValue(value)}' WHERE id = ${store.id}");
//       return true;
//     } catch (error) {
//       _logger.e(_TAG, "storeIsSelectedUpdate()", message: error.toString());
//       return false;
//     }
//   }
//
//   Future<bool?> refreshTerminalList(var storeList) async {
//     _logger.i(_TAG, "refreshTerminalList()", message: "Refreshing list of terminals in database.");
//     try {
//       for (var store in storeList) {
//         var storeId = store["store_id"].toString();
//         var terminalList = store["terminals"];
//         var storeMap = <String, dynamic>{
//           'id': storeId,
//           'name': store["store_name"].toString(),
//           'email': store["email_address"].toString(),
//           'mobile': store["mobile"].toString(),
//         };
//         _databaseManager.insert(TableManager.STORES, storeMap);
//         if (terminalList != null && terminalList != "") {
//           for (var terminal in terminalList) {
//             var terminalMap = <String, dynamic>{
//               'terminal_id': terminal["terminal_id"].toString(),
//               'name': terminal["name"].toString(),
//               'store_id': storeId,
//               'row_id': terminal["id"].toString(),
//               'is_selected': 1
//             };
//             _databaseManager.insert(TableManager.TERMINALS, terminalMap);
//           }
//         }
//       }
//       _logger.i(_TAG, "refreshTerminalList()", message: "Refreshed terminals successfully.");
//       return true;
//     } catch (error) {
//       _logger.e(_TAG, "refreshTerminalList()", message: error.toString());
//       return false;
//     }
//   }
//
// }