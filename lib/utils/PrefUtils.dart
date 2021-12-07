import 'package:app/utils/lib.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrefUtils {

  static const String _TAG = "VerificationUtils";
  static const String preserveLogin = "preserveLogin";
  static const String isTokenSync = "isTokenSync";
  static const String showLiveData = "showLiveData";
  static const String isLoggedIn = "isLoggedIn";

  static Future<bool> isUserLoggedIn() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var status = prefs.getBool(isLoggedIn) ?? false;
      if (status)
        return true;
      else
        return false;
    } catch(error){
      Logger.getInstance.e(_TAG, "isUserLoggedIn()", message: error.toString());
      return false;
    }
  }

  static Future<bool> isFirebaseTokenSync() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var status = prefs.getBool(isTokenSync) ?? false;
      if (status)
        return true;
      else
        return false;
    } catch(error){
      Logger.getInstance.e(_TAG, "isUserLoggedIn()", message: error.toString());
      return false;
    }
  }

/*
  static setPreserveLoginStatus(int value) async {
    try {
      SharedPreferences.getInstance().then((prefs) => prefs.setInt(preserveLogin, value));
    } catch(error) {
      Logger.getInstance.e(_TAG, "setPreserveLoginStatus()", message: error.toString());
      return false;
    }
  }

  static setLoginSessionStatus(bool value) async {
    try {
      SharedPreferences.getInstance().then((prefs) => prefs.setBool(isLoggedIn, value));
    } catch(error) {
      Logger.getInstance.e(_TAG, "setLoginSessionStatus()", message: error.toString());
      return false;
    }
  }

  static setLiveDataStatus(bool value) async {
    try {
      SharedPreferences.getInstance().then((prefs) => prefs.setBool(showLiveData, value));
    } catch(error) {
      Logger.getInstance.e(_TAG, "setLiveDataStatus()", message: error.toString());
      return false;
    }
  }

  static setTokenSyncStatus(int value) async {
    try {
    } catch(error) {
      Logger.getInstance.e(_TAG, "setPreserveLoginStatus()", message: error.toString());
      return false;
    }
  }

  static Future<String> getDefaultLocale(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var locale = prefs.getString('locale');
      return locale;
  }
*/

}
