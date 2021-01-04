import 'package:chmurkowo/service/ApiService.dart';
import 'package:chmurkowo/service/AuthService.dart';
import 'package:chmurkowo/service/LocationService.dart';
import 'package:chmurkowo/service/PermissionsService.dart';
import 'package:chmurkowo/service/PrefsService.dart';
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
    PrefsService prefsService = new PrefsService();
    bool allAllowed = false;
    while (allAllowed == false) {
      allAllowed = await askForPermissions();
    }
    await authService.signInWithGoogle();
    bool userHelloDone = await prefsService.userHelloDone();
    if (!userHelloDone) {
      userHelloDone = await apiService.hello();
      await prefsService.userHelloDone(value: userHelloDone);
    }
    userHelloDone = await prefsService.userHelloDone();

    LocationService locationService = new LocationService();
    //await apiService.addPin(
    //    '/data/data/com.chmurkowo.chmurkowo/cache/2021-01-03 09:42:38.337355.png',
    //    await locationService.currentLocation());

    //TODO if not done then exit app
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
