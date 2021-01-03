import 'dart:convert';

import 'package:chmurkowo/model/User.dart' as MyUser;
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

  UserCredential userCredential;
  String azureId;
  MyUser.User get user {
    return new MyUser.User(
        this.azureId, this.userCredential.user.email.split('@')[0]);
  }

  Future<UserCredential> signInWithGoogle() async {
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
    this.userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);
    this.azureId = md5
        .convert(utf8.encode(this.userCredential.user.uid.toString()))
        .toString();
    return this.userCredential;
  }
}
