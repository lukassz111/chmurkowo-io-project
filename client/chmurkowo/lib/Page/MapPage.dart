import 'dart:ffi';

import 'package:chmurkowo/Widget/MapWidget.dart';
import 'package:flutter/material.dart';

class MapPage extends StatefulWidget {
  MapPage({Key key}) : super(key: key);
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  Widget map(BuildContext context) {}

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          appBar: AppBar(
            title: Text('Mapa'),
            automaticallyImplyLeading: false,
          ),
          body: MapWidget(),
          floatingActionButton: FloatingActionButton(
            child: IconButton(
              icon: Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),
          ),
        ),
        onWillPop: () async => false);
  }
}
