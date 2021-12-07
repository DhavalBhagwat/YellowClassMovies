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

  bool getCurrentUser() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return true;
    }
    return false;
  }

  Future<User?> signInWithGoogle({required BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );
        try {
          final UserCredential userCredential = await auth.signInWithCredential(credential);
          user = userCredential.user;
        } on FirebaseAuthException catch (error) {
          if (error.code == 'account-exists-with-different-credential') {
          } else if (error.code == 'invalid-credential') {


          }
        } catch (error) {
          _logger.e(_TAG, "signInWithGoogle()", message: error.toString());
        }
      }


    return user;
  }

}