import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:app/services/lib.dart';
import 'package:app/ui/lib.dart';
import 'package:app/utils/lib.dart';

class GoogleSignInButton extends StatefulWidget {

  @override
  _GoogleSignInButtonState createState() => _GoogleSignInButtonState();

}

class _GoogleSignInButtonState extends State<GoogleSignInButton> {

  bool _isSigningIn = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: _isSigningIn ? LoadingIndicator() : OutlinedButton(
        style: ButtonStyle(
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40),
            ),
          ),
        ),
        onPressed: () => _signIn(),
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image(
                image: AssetImage(Assets.GOOGLE_LOGO_IMAGE),
                height: 35.0,
              ),
              Padding(
                padding: EdgeInsets.only(left: 10),
                child: Text('Sign in with Google'),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _signIn() async {
    setState(() {
      _isSigningIn = true;
    });
    User? user = await UserService.getInstance.signInWithGoogle(context: context);
    setState(() {
      _isSigningIn = false;
    });
    print(user.toString());
    if (user != null) NavigationService.getInstance.dashboardActivity();
  }

}
