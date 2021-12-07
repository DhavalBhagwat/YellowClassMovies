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

  Future<bool> checkForPermissionsAndProceed(BuildContext context) async {
    try {
      if (!await PermissionUtils.checkForPermissions()) {
        if (!await PermissionUtils.requestAppPermissions()) {
          checkForPermissionsAndProceed(context);
        }
      }
      return UserService.getInstance.getCurrentUser();
    }
    catch (error) {
      _logger.e(_TAG, "checkForPermissionsAndProceed()", message: error.toString());
      return false;
    }
  }

}