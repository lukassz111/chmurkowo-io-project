import 'package:flutter/material.dart';

class DrawerWidget extends StatefulWidget {
  DrawerWidget({Key key}) : super(key: key);

  @override
  _DrawerWidgetState createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  @override
  Widget build(BuildContext context) {
    return new Drawer(
        child: ListView(
      children: [
        DrawerHeader(child: Text("Drawer header")),
        ListTile(
          title: Text("Dodaj zdjęcie"),
          onTap: () {
            Navigator.of(context).pushNamed("/add_image");
          },
        )
      ],
    ));
  }
}
