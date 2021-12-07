import 'package:permission_handler/permission_handler.dart';
import 'package:app/utils/lib.dart';

class PermissionUtils {

  static const String _TAG = "PermissionUtils";

  static Future<bool> checkForPermissions() async {
    PermissionStatus permissionStorage = await Permission.storage.status;
    if (permissionStorage.isGranted) {
      Logger.getInstance.i(_TAG, "checkForPermissions()", message : "Permissions already granted.");
      return true;
    } else {
      Logger.getInstance.e(_TAG, "checkForPermissions()", message : "Permissions not granted.");
      return false;
    }
  }

  static Future<bool> requestAppPermissions() async {
    Map<Permission, PermissionStatus> result = await [
      Permission.storage,
    ].request();
    bool status = true;
    result.forEach((key, value) {
      if (value != PermissionStatus.granted) {
        status = false;
      }
    });
    if (status) {
      Logger.getInstance.i(_TAG, "requestAppPermissions()", message : "Permissions granted.");
    } else {
      Logger.getInstance.e(_TAG, "requestAppPermissions()", message : "Permissions denied.");
    }
    return status;
  }

}
