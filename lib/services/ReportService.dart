// import 'package:kwanta_insights/data/lib.dart';
// import 'package:kwanta_insights/database/lib.dart';
// import 'package:kwanta_insights/utils/lib.dart';
//
// class ReportService {
//
//   static ReportService? _instance;
//   ReportService._();
//   factory ReportService() => getInstance;
//
//   static ReportService get getInstance {
//     if (_instance == null) {
//       _instance = new ReportService._();
//     }
//     return _instance!;
//   }
//
//   static const String _TAG = "ReportService";
//   DatabaseManager _databaseManager = DatabaseManager.getInstance;
//   Logger _logger = Logger.getInstance;
//
//   Future<void> addReportsToDb(var reportList) async {
//     _logger.i(_TAG, "addReportsToDb()", message: "Adding reports to database.");
//     try {
//       for (var report in reportList) {
//         var reportMap = <String, dynamic>{
//           'id': report["activity_id"],
//           'name': report["activity_key"].toString(),
//           'is_visible': report["is_visible"],
//           'is_notify': 0
//         };
//         _databaseManager.insert(TableManager.REPORTS, reportMap);
//       }
//       _logger.i(_TAG, "addReportsToDb()", message: "Added reports successfully.");
//     } catch (error) {
//       _logger.e(_TAG, "addReportsToDb()", message: error.toString());
//     }
//   }
//
//   Future<List<Report>?> getReportsList(bool isSelectionDialog) async {
//     //_logger.d(_TAG, "getReportsList()", message: "Getting report list from database.");
//     List<Report>? list;
//     try {
//       var result = await _databaseManager.query(TableManager.REPORTS, distinct: true, orderBy: "id");
//       if (result!.isNotEmpty) {
//         list = result.isNotEmpty ? result.map((c) => Report.fromMap(c)).toList() : null;
//         if (isSelectionDialog)
//           list?.removeWhere((e) => e.getName == "live_data");
//       }
//       return list;
//     } catch (error) {
//       _logger.e(_TAG, "getReportsList()", message: error.toString());
//       return null;
//     }
//   }
//
//   Future<List<Map<String, dynamic>>?> getReportsListForSettings() async {
//     //_logger.d(_TAG, "getReportsListForSettings()", message: "Getting terminal details from database.");
//     List<Map<String, dynamic>> reportList = [];
//     Map<String, dynamic> reportMap;
//     var result = await _databaseManager.query(TableManager.REPORTS, distinct: true, orderBy: "id");
//     try {
//       for (var map in result!) {
//         reportMap = Map();
//         reportMap["id"] = map["id"];
//         reportMap["name"] = map["name"];
//         reportMap["is_visible"] = map["is_visible"];
//         reportMap["is_notify"] = map["is_notify"];
//         reportList.add(reportMap);
//       }
//       return reportList;
//     } catch (error) {
//       _logger.e(_TAG, "getReportsListForSettings()", message: error.toString());
//       return null;
//     }
//   }
//
//   Future<bool?> compareSettingsWithTemplate(var reportSettings, var template) async {
//     List<Report> settingsReportList = [];
//     List<Report> templateReportList = [];
//     List<String> templateNameList = [];
//     var settingsNameList = [];
//     Map<String, dynamic> dataMap;
//     try {
//
//       //create list of template names
//       for (var map in template) {
//         dataMap = Map();
//         dataMap["id"] = int.parse(map["activity_id"].toString());
//         dataMap["name"] = map["activity_key"].toString();
//         dataMap["is_visible"] = int.parse(map["is_visible"].toString());
//         dataMap["is_notify"] = 0;
//         templateReportList.add(Report.fromJson(dataMap));
//       }
//       for (var templates in templateReportList)
//         templateNameList.add(templates.getName!);
//
//       //create list of report names
//       for (var map in reportSettings) {
//         dataMap = Map();
//         dataMap["id"] = map["id"];
//         dataMap["name"] = map["name"];
//         dataMap["is_visible"] = map["is_visible"];
//         dataMap["is_notify"] = map["is_notify"];
//         settingsReportList.add(Report.fromJson(dataMap));
//       }
//       for (var setting in settingsReportList)
//         settingsNameList.add(setting.getName);
//
//       //compare both list for differences
//       for (var report in settingsNameList) {
//         if (!templateNameList.contains(report)) {
//           settingsReportList.removeWhere((c) => c.getName == report);
//         } else {
//           templateReportList.removeWhere((c) => c.getName == report);
//         }
//       }
//       //_logger.d(_TAG, "compareSettingsWithTemplate()", message: "SETTINGS LIST : ${settingsReportList.length}");
//       //_logger.d(_TAG, "compareSettingsWithTemplate()", message: "TEMPLATE LIST : ${templateReportList.length}");
//       _logger.i(_TAG, "compareSettingsWithTemplate()", message: "Adding reports settings to database.");
//       await _databaseManager.delete(TableManager.REPORTS).then((value) {
//         if (templateReportList.isNotEmpty)
//           for (var report in templateReportList)
//             _databaseManager.insert(TableManager.REPORTS, report.toMap());
//         if (settingsReportList.isNotEmpty)
//           for (var report in settingsReportList)
//             _databaseManager.insert(TableManager.REPORTS, report.toMap());
//       });
//       _logger.i(_TAG, "compareSettingsWithTemplate()", message: "Added reports successfully.");
//     } catch (error) {
//       _logger.e(_TAG, "compareSettingsWithTemplate()", message: error.toString());
//     }
//     return true;
//   }
//
// }