import 'package:flutter/material.dart';

class StringUtils {

  static const String _TAG = "StringUtils";

  static String getRoundedValue(String amount, bool isRow) {
    try {
      if (amount == "--" || amount == "")
        return "--";
      else {
        if (isRow)
          return "${double.parse(amount).toStringAsFixed(2).replaceFirst(".", ",")}";
        else
          return "EUR ${double.parse(amount).toStringAsFixed(2).replaceFirst(".", ",")}";
      }
    } catch (error) {
      return "$amount";
    }
  }

  static String getExplodedString(String? line, String? explodeWith) => line!.replaceAll("|", "\n");

  static String getCompleteString(String? line, String? explodeWith) => line!.replaceAll("|", "\n\n");

  static bool getBooleanValue(int val) {
    if (val == 0)
      return false;
    else if (val == 1)
      return true;
    else
      return false;
  }

  static int getIntValue(bool val) {
    if (val)
      return 1;
    else if (!val)
      return 0;
    else
      return 0;
  }

  static DateTime formatTimeOfDay(TimeOfDay tod) {
    DateTime now = DateTime.now();
    DateTime dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
    return dt;
  }


  static bool validateInputFields(List<String> fields) {
    for (int i = 0; i < fields.length; i++) {
      if (fields[i].isEmpty || fields[i].length == 0) {
        return false;
      }
    }
    return true;
  }

  static String validateString(String? data){
    return data == null ? "--" : data;
  }

}
