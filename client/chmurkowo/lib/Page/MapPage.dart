import 'dart:ffi';

import 'package:chmurkowo/Page/DrawerWidget.dart';
import 'package:chmurkowo/Widget/MapWidget.dart';
import 'package:flutter/material.dart';

class MapPage extends StatefulWidget {
  MapPage({Key key}) : super(key: key);
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          appBar: AppBar(
            title: Text('Mapa'),
            automaticallyImplyLeading: true,
          ),
          body: MapWidget(),
          drawer: new DrawerWidget(),
        ),
        onWillPop: () async => false);
  }
}
