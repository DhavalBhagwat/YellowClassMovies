import 'dart:io';
import 'package:app/utils/lib.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class ImageUtils {

  static const String _TAG = "ImageUtils";
  static Logger _logger = Logger.getInstance;

  static Future<String> get _localPath async {
    if (Platform.isIOS) return await getApplicationDocumentsDirectory().then((directory) => directory.path);
    return await getExternalStorageDirectory().then((directory) => directory!.path);
  }

  static Future<String> savePhotoFile(File photo) async {
    String directoryPath = await _localPath;
    final saveFile = await photo.copy(directoryPath + p.separator + p.basename(photo.path));
    return saveFile.path;
  }

  static Future<void> deleteFile(String fileUrl) async {
    try {
      final file = File(fileUrl);
      await file.delete();
    } catch (error) {
      _logger.e(_TAG, "deleteFile()", message: error.toString());
    }
  }

}