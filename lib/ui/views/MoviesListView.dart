import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:app/bloc/lib.dart';
import 'package:app/ui/lib.dart';

class MoviesListView extends StatefulWidget {

  const MoviesListView({
    Key? key,
  }) : super(key: key);

  @override
  _MoviesListViewState createState() => _MoviesListViewState();

}

class _MoviesListViewState extends State<MoviesListView> with TickerProviderStateMixin {

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GetX<MoviesController>(
        init: MoviesController(context),
        builder: (controller) {
          if (controller.isLoading.value) return LoadingIndicator();
          else if (controller.movies.isEmpty) return NoData();
          else return Stack(
            children: [
              Container(
                margin: EdgeInsets.symmetric(vertical: 5.0),
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: ListView.builder(
                  controller: controller.controller,
                  itemCount: controller.movies.length,
                  itemBuilder: (context, index) => MovieItem(movie: controller.movies[index], controller: controller)
                  ),
                ),
                if (controller.isUpdating.value) Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: LoadingIndicator(),
                  ),
                ),
              ],
          );
        },
      ),
    );
  }

}