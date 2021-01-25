import 'package:chmurkowo/Page/PinDetailsPage.dart';
import 'package:chmurkowo/model/DisplayPin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:latlong/latlong.dart';
import 'package:uuid/uuid.dart';

class MapWidget extends StatefulWidget {
  MapWidget({Key key, this.pins}) : super(key: key);
  @override
  _MapWidgetState createState() => _MapWidgetState();
  List<DisplayPin> pins;
  bool get loading {
    if (pins == null) {
      return true;
    } else {
      return false;
    }
  }
}

class _MapWidgetState extends State<MapWidget> {
  MapController mapController;
  LatLng center = new LatLng(51.748706, 19.451665);
  LatLng northWest;
  LatLng southEast;

  void updateBounds(LatLng northWest, LatLng southEast) {
    print("northWest: ${northWest}, southEast: ${southEast}");
    this.northWest = northWest;
    this.southEast = southEast;
  }

  List<Marker> buildMarkers(BuildContext context) {
    if (widget.loading) {
      List<Marker> result = new List<Marker>();
      return result;
    }
    List<Marker> result = widget.pins.map<Marker>((pin) {
      Marker x = new Marker(
          width: 40.0,
          height: 40.0,
          point: pin.position,
          builder: (ctx) => new Container(
                  child: new FloatingActionButton(
                heroTag:
                    "hero_pin_${pin.position.latitude}_${pin.position.longitude}",
                child: Icon(
                  Icons.place,
                  color: Colors.white,
                ),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (_) => new PinDetailsPage(pin));
                },
              )));
      return x;
    }).toList(growable: true);

    return result;
  }

  @override
  Widget build(BuildContext context) {
    this.mapController = new MapController();
    var uuid = Uuid();
    if (widget.loading) {
      return WillPopScope(
          child: Scaffold(
              body: (Center(
            child: CircularProgressIndicator(),
          ))),
          onWillPop: () async => false);
    }
    var markers = buildMarkers(context);
    return FlutterMap(
      mapController: mapController,
      options: new MapOptions(
          center: this.center,
          zoom: 13.0,
          plugins: [MarkerClusterPlugin()],
          onPositionChanged: (mapPosition, x) {
            if (this.mapController == null) {
              print("this.mapController is null");
              return;
            } else if (!this.mapController.ready) {
              print("this.mapController.ready = false");
              return;
            }
            var b = this.mapController.bounds;
            this.updateBounds(b.northWest, b.southEast);
          }),
      layers: [
        new TileLayerOptions(
            urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
            subdomains: ['a', 'b', 'c']),
        new MarkerClusterLayerOptions(
            maxClusterRadius: 120,
            size: Size(40, 40),
            fitBoundsOptions: FitBoundsOptions(padding: EdgeInsets.all(50)),
            markers: markers,
            polygonOptions: PolygonOptions(
                borderColor: Colors.blueAccent,
                color: Colors.black12,
                borderStrokeWidth: 3),
            builder: (context, markers) {
              return new FloatingActionButton(
                  heroTag:
                      "hero_multipin_${uuid.v1().toString().toLowerCase()}",
                  child: Text(markers.length.toString()));
            })
        //new MarkerLayerOptions(markers: buildMarkers(context)),
      ],
    );
  }
}
