import 'package:app/services/lib.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app/utils/lib.dart';

class MoviesController extends GetxController {

  BuildContext context;
  var isLoading = true.obs;
  var isUpdating = false.obs;
  var movies = [].obs;
  int _listLimit = 10, _offset = 0;
  Logger _logger = Logger.getInstance;
  static const String _TAG = "MoviesController";
  ScrollController controller = ScrollController();

  MoviesController(this.context);

  @override
  void onInit() {
    _getMoviesList();
    _updateMoviesList();
    super.onInit();
  }

  void _getMoviesList() async {
    isLoading(true);
    await DataService.getInstance.getMovieList(limit: _listLimit, offset: _offset).then((result) {
      if (result != null) {
        if (movies.isNotEmpty) movies.clear();
        movies.assignAll(result);
      }
      isLoading(false);
    }).catchError((error) {
      _logger.e(_TAG, "getMoviesList()", message: error.toString());
      isLoading(false);
    });
  }

  void _updateMoviesList() async {
    controller.addListener(() async {
      if (controller.position.maxScrollExtent == controller.position.pixels) {
        _offset = _offset + 10;
        isUpdating(true);
        await DataService.getInstance.getMovieList(limit: _listLimit, offset: _offset).then((result) {
          if (result != null) movies.addAll(result);
        }).catchError((error) {
          _logger.e(_TAG, "updateMoviesList()", message: error.toString());
          isUpdating(false);
        });
      }
    });
  }

  Future<Null> removeFromList(int index) async {
    try {
      movies.removeAt(index);
      update();
    } catch (error) {
      _logger.e(_TAG, "removeFromList()", message: error.toString());
    }
  }

}