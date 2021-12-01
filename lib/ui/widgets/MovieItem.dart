import 'dart:io';
import 'package:app/bloc/lib.dart';
import 'package:app/data/lib.dart';
import 'package:app/utils/lib.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MovieItem extends StatelessWidget {

  final Movie? movie;
  final MoviesController? controller;

  MovieItem({
    Key? key,
    @required this.movie,
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
                width: 2
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
                ClipRRect(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(0.0),
                      bottomLeft: Radius.circular(0.0)
                  ),
                  child: Image.file(File.fromUri(Uri.parse(movie!.poster!))),
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
              ],
            ),
          ),
        ),
    );
  }
}
