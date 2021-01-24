import 'dart:ffi';

import 'package:chmurkowo/Page/DrawerWidget.dart';
import 'package:chmurkowo/Widget/MapWidget.dart';
import 'package:flutter/material.dart';
import 'package:chmurkowo/service/ApiService.dart';


class MapPage extends StatefulWidget {
  MapPage({Key key}) : super(key: key);
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  @override
  Widget build(BuildContext context) {
    ApiService apiService = new ApiService();
    return WillPopScope(
        child: Scaffold(
          appBar: AppBar(
            title: Text('Mapa'),
            automaticallyImplyLeading: true,
          ),
          body: MapWidget(),
          drawer: new DrawerWidget(),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: (){
              apiService.getAllPinsData();
            }
          ),
        ),
        onWillPop: () async => false);
  }
}
