import 'package:app/ui/lib.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:app/services/lib.dart';
import 'package:app/utils/lib.dart';

class LoginActivity extends StatefulWidget {

  @override
  _LoginActivityState createState() =>  _LoginActivityState();

}

class _LoginActivityState extends State<LoginActivity> {

  static const String _TAG = "LoginActivity";
  SystemService? _systemService;
  bool? _isLoading = true;
  bool? _isLoggedIn = true;

  @override
  void initState() {
    super.initState();
    _systemService = SystemService.getInstance;
    try {
      _init();
    } catch (error) {
      Logger.getInstance.e(_TAG, "initState()", message: error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtils.getInstance.init(context);
    return Container(
      width: double.maxFinite,
      height: double.maxFinite,
      alignment: Alignment.center,
      color: AppTheme.background,
      padding: EdgeInsets.only(top: ScreenUtils.statusBarHeightSimple),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 350,
            child: Image(
              image: AssetImage(Assets.APP_LOGO_IMAGE),
            ),
          ),
          Visibility(
            child: Container(
              margin: EdgeInsets.only(top: ScreenUtils.statusBarHeightSimple),
              height: 25,
              width: 25,
              child: LoadingIndicator(),
            ),
            visible: _isLoading! && _isLoggedIn!,
          ),
          Visibility(
            child: Container(
              margin: EdgeInsets.only(top: ScreenUtils.statusBarHeightSimple),
              child: GoogleSignInButton(),
            ),
            visible: !_isLoggedIn!,
          ),
        ],
      ),
    );
  }

  Future<void> _init() async {
    _systemService?.init();
    _isLoggedIn = await _systemService?.checkForPermissionsAndProceed(context);
    if (!_isLoggedIn!) {
      setState((){});
    } else {
      NavigationService.getInstance.dashboardActivity();
    }
  }

}
