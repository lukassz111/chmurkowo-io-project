import 'package:chmurkowo/model/DisplayPin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:latlong/latlong.dart';
import 'package:uuid/uuid.dart';

class MapWidget extends StatefulWidget {
  MapWidget({Key key}) : super(key: key);
  @override
  _MapWidgetState createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  List<DisplayPin> pins = new List<DisplayPin>();

  @override
  void initState() {
    setState(() {
      this.pins = new List<DisplayPin>();
      this.pins.add(DisplayPin(new LatLng(51.746444, 19.446134), "Polesie"));
      this.pins.add(DisplayPin(new LatLng(51.747056, 19.450167), "C12"));
      this.pins.add(DisplayPin(new LatLng(51.747958, 19.464243), "Źródliska"));
      this.pins.add(DisplayPin(new LatLng(51.743395, 19.458031), "Górniak"));
    });
  }

  List<Marker> buildMarkers(BuildContext context) {
    List<Marker> result = this.pins.map<Marker>((pin) {
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
                ),
              ));
      return x;
    }).toList(growable: true);

    Marker x = new Marker(
      width: 80.0,
      height: 80.0,
      point: new LatLng(51.5, -0.09),
      builder: (ctx) => new Container(
        child: Icon(Icons.place),
      ),
    );

    result.add(x);
    return result;
  }

  @override
  Widget build(BuildContext context) {
    var uuid = Uuid();
    var markers = buildMarkers(context);
    return FlutterMap(
      options: new MapOptions(
          center: new LatLng(51.748706, 19.451665),
          zoom: 13.0,
          plugins: [MarkerClusterPlugin()]),
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
