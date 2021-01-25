import 'dart:ffi';

import 'package:chmurkowo/Page/DrawerWidget.dart';
import 'package:chmurkowo/Widget/MapWidget.dart';
import 'package:chmurkowo/main.dart';
import 'package:chmurkowo/model/DisplayPin.dart';
import 'package:flutter/material.dart';
import 'package:chmurkowo/service/ApiService.dart';

class MapPage extends StatefulWidget {
  MapPage({Key key}) : super(key: key);
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> with RouteAware {
  List<DisplayPin> pins = [];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          appBar: AppBar(
            title: Text('Mapa'),
            automaticallyImplyLeading: true,
          ),
          body: MapWidget(
            pins: this.pins,
          ),
          drawer: new DrawerWidget(),
        ),
        onWillPop: () async => false);
  }

  void loadPins() {
    ApiService apiService = new ApiService();
    apiService.getAllPins().then((value) {
      this.pins.clear();
      for (var i = 0; i < value.length; i++) {
        this.pins.add(value[i]);
      }
      setState(() {});
    });
  }

  @override
  void initState() {
    loadPins();
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    loadPins();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context));
  }
}
