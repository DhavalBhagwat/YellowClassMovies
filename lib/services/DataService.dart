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

  Future<void> deleteMovie(String? poster) async {
    await ImageUtils.deleteFile(poster!);
    await _databaseManager.delete(TableManager.MOVIES, poster).catchError((error) {
      _logger.e(_TAG, "deleteMovie()", message: error.toString());
    });
  }

}