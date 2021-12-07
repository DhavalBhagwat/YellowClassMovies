import 'package:flutter/material.dart';
import 'package:app/utils/lib.dart';

class LoadingIndicator extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Center(
        child: CircularProgressIndicator(
          color: AppTheme.colorAccent,
        )
    );
  }

}
