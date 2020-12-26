import 'package:chmurkowo/service/PermissionsService.dart';
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

  Future askForPermissions() async {
    PermissionsService permissionsService = new PermissionsService();
    bool allAllowed = await permissionsService.requestAllNeededPermissions();
    if (allAllowed) {
      Navigator.of(context).pushReplacementNamed('/');
    } else {
      await askForPermissions();
    }
  }

  @override
  void initState() {
    askForPermissions();
  }
}
