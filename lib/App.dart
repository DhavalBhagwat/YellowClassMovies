import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:app/utils/lib.dart';

class App extends StatelessWidget {

  final ThemeData _theme = ThemeData();

  @override
  Widget build(BuildContext context) {
    return Material(
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/loginActivity',
        getPages: Routes.routes,
        theme: _theme.copyWith(
          colorScheme: _theme.colorScheme.copyWith(
            primary: AppTheme.colorPrimary,
            primaryVariant: AppTheme.colorPrimaryDark,
            secondary: AppTheme.colorAccent,
          ),
        ),
      ),
    );
  }


}