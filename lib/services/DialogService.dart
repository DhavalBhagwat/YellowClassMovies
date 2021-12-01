// import 'package:flutter/material.dart';
// import 'package:kwanta_insights/data/podos/Store.dart';
// import 'package:kwanta_insights/ui/lib.dart';
//
// class DialogService {
//
//   static DialogService? _instance;
//   DialogService._();
//   factory DialogService() => getInstance;
//
//   static DialogService get getInstance {
//     if (_instance == null) {
//       _instance = new DialogService._();
//     }
//     return _instance!;
//   }
//
//   showAlertDialog(BuildContext? context, String? title, String? message, {bool? res = false}) => showDialog(
//       barrierDismissible: false,
//       context: context!,
//       builder: (BuildContext context) => Alert(title: title, context: context, message: message, res: res)
//   );
//
//   showLoadingDialog(BuildContext context, String? message) => showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) => Loading(context: context, message: message)
//   );
//
//   showAboutDialog(BuildContext context) => showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) => About(context: context)
//   );
//
//   showFilterDialog(BuildContext context, String reportType) => showDialog(
//       barrierDismissible: false,
//       context: context,
//       builder: (BuildContext context) => FilterDialog(context: context, reportType: reportType)
//   );
//
//   showTerminalListDialog(BuildContext context, Store store) => showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) => TerminalListDialog(context: context, store: store)
//   );
//
// }
