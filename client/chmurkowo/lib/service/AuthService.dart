import 'dart:convert';

import 'package:chmurkowo/model/GoogleUser.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:crypto/crypto.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();

  factory AuthService() {
    return _instance;
  }

  AuthService._internal();
  Future initialize() async {
    await Firebase.initializeApp();
  }

  UserCredential _userCredential;
  String get googleId {
    return md5
        .convert(utf8.encode(this._userCredential.user.uid.toString()))
        .toString();
  }

  String get email {
    return _userCredential.user.email;
  }

  String get displayName {
    return _userCredential.user.displayName;
  }

  GoogleUser get user {
    return new GoogleUser(googleId, displayName, email);
  }

  Future<GoogleUser> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    // Create a new credential
    final GoogleAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    ); // Once signed in, return the UserCredential
    this._userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);
    return this.user;
  }
}
