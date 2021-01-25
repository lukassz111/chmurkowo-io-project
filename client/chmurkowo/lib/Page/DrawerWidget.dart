import 'package:chmurkowo/service/ApiService.dart';
import 'package:chmurkowo/service/AuthService.dart';
import 'package:flutter/material.dart';

class DrawerWidget extends StatefulWidget {
  DrawerWidget({Key key}) : super(key: key);

  @override
  _DrawerWidgetState createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  AuthService authService = new AuthService();

  @override
  Widget build(BuildContext context) {
    return new Drawer(
        child: ListView(
      children: [
        DrawerHeader(
            child: Container(
              child: ListTile(
                title: Text(authService.user.displayName,
                    style: TextStyle(color: Colors.white)),
                subtitle: Text(authService.user.email,
                    style: TextStyle(color: Colors.white)),
              ),
              alignment: Alignment.bottomLeft,
            ),
            decoration: new BoxDecoration(color: Colors.blue)),
        ListTile(
          title: Text("Dodaj zdjęcie"),
          onTap: () {
            Navigator.of(context).pushNamed("/add_image").then((value) {
              // print("back");
            });
          },
        )
      ],
    ));
  }
}
