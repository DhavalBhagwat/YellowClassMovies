import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:app/bloc/lib.dart';
import 'package:app/data/lib.dart';
import 'package:app/services/lib.dart';
import 'package:app/utils/lib.dart';

class MovieItem extends StatelessWidget {

  final Movie? movie;
  final int? index;
  final MoviesController? controller;

  static const String _TAG = "MovieItem";

  MovieItem({
    Key? key,
    @required this.movie,
    @required this.index,
    @required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: AppTheme.colorAccent.withOpacity(0.25),
              width: 2.0
            ),
          ),
          child: Container(
            height: 100,
            decoration: BoxDecoration(
              color: AppTheme.white,
              borderRadius: BorderRadius.circular(0.0),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
              Container(
                child: ClipRRect(
                  child: Image.file(
                    File.fromUri(Uri.parse(movie!.poster!)),
                    width: 100.0,
                  ),
                ),
              ),
              Expanded(
                  child: ListTile(
                    title: Container(
                      margin: EdgeInsets.all(2.0),
                      child: Text(
                        "Name : ${movie!.name}",
                        textAlign: TextAlign.left,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                    subtitle: Container(
                      margin: EdgeInsets.all(2.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(height: 2.0),
                          Text(
                            "Director : ${movie!.director}",
                            textAlign: TextAlign.left,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          SizedBox(height: 2.0),
                        ],
                      ),
                    ),
                  ),
                ),
                _getActionButtons()
              ],
            ),
          ),
        ),
    );
  }

  Widget _getActionButtons() => Container(
    child: Column(
      children: [
        IconButton(
          color: AppTheme.grey,
          icon: Icon(Icons.edit),
          onPressed: () => _editMovie(),
        ),
        IconButton(
          color: AppTheme.grey,
          icon: Icon(Icons.delete),
          onPressed: () => _deleteMovie(),
        ),
      ],
    ),
  );

  void _editMovie() => NavigationService.getInstance.moviesFormActivity(isEdit: true, id: movie!.id);

  void _deleteMovie() async {
    try {
      await controller?.removeFromList(index!);
      await DataService.getInstance.deleteMovie(movie!.poster);
    } catch (error) {
      Logger.getInstance.e(_TAG, "deleteMovie()", message: error.toString());
    }
  }

}
