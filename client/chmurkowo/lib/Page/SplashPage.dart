import 'package:chmurkowo/service/ApiService.dart';
import 'package:chmurkowo/service/AuthService.dart';
import 'package:chmurkowo/service/PermissionsService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  SplashPage({Key key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [FlutterLogo()],
        ),
      ),
    );
  }

  Future<bool> askForPermissions() async {
    PermissionsService permissionsService = new PermissionsService();
    return await permissionsService.requestAllNeededPermissions();
  }

  Future doOnStart() async {
    AuthService authService = new AuthService();
    ApiService apiService = new ApiService();
    bool allAllowed = false;
    while (allAllowed == false) {
      allAllowed = await askForPermissions();
    }
    await authService.signInWithGoogle();
    await apiService.hello();

    if (allAllowed) {
      Navigator.of(context)
          .pushReplacementNamed('/'); //changed routing for testing
    } else {
      Navigator.of(context).pop();
    }
  }

  @override
  void initState() {
    doOnStart();
  }
}
