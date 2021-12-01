import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:app/utils/lib.dart';

class UserService {

  static UserService? _instance;
  UserService._();
  factory UserService() => getInstance;

  static UserService get getInstance {
    if (_instance == null) {
      _instance = new UserService._();
    }
    return _instance!;
  }

  static const String _TAG = "UserService";
  Logger _logger = Logger.getInstance;
  static Future<FirebaseApp> initializeFirebase({
    required BuildContext context,
  }) async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();

    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // Navigator.of(context).pushReplacement(
      //   MaterialPageRoute(
      //     builder: (context) => UserInfoScreen(
      //       user: user,
      //     ),
      //   ),
      // );
    }

    return firebaseApp;
  }

  Future<User?> signInWithGoogle({required BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

      final GoogleSignIn googleSignIn = GoogleSignIn();

      final GoogleSignInAccount? googleSignInAccount =
      await googleSignIn.signIn();

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        try {
          final UserCredential userCredential =
          await auth.signInWithCredential(credential);

          user = userCredential.user;
        } on FirebaseAuthException catch (e) {
          if (e.code == 'account-exists-with-different-credential') {
            //'The account already exists with a different credential',

          } else if (e.code == 'invalid-credential') {
       //     'Error occurred while accessing credentials. Try again.',


          }
        } catch (e) {
        //  'Error occurred using Google Sign In. Try again.',

        }
      }


    return user;
  }

  static Future<void> signOut({required BuildContext context}) async {
    final GoogleSignIn googleSignIn = GoogleSignIn();

    try {
      await googleSignIn.signOut();
      await FirebaseAuth.instance.signOut();
    } catch (e) {
     // 'Error signing out. Try again.',

    }
  }

}