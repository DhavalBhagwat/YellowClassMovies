import 'package:app/services/lib.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:app/utils/lib.dart';
import 'package:app/ui/lib.dart';

class DashboardActivity extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      resizeToAvoidBottomInset: false,
      appBar: CupertinoNavigationBar(
        backgroundColor: AppTheme.white,
        middle: Image(
          image: AssetImage(Assets.APP_LOGO_IMAGE),
        ),
      ),
      body: MoviesListView(),
      floatingActionButton: FloatingActionButton.extended(
        foregroundColor: AppTheme.colorAccent,
        backgroundColor: AppTheme.colorPrimary,
        label: Text('Add Movie'),
        onPressed: () => NavigationService.getInstance.moviesFormActivity(),
      ),
    );
  }

}
