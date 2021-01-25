import 'package:chmurkowo/Page/PinDetailsPage.dart';
import 'package:chmurkowo/model/DisplayPin.dart';
import 'package:chmurkowo/service/ApiService.dart';
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
  bool loading = true;

  @override
  void initState() {
    if(loading){
      ApiService apiService = new ApiService();
      apiService.getAllPins().then((value) {
        for(var i = 0; i < value.length; i++){
          this.pins.add(value[i]);
        }
        if(value.length > 0 )
          setState(() {
            loading = false;
          });
      }
    );}
  }

  List<Marker> buildMarkers(BuildContext context) {

    print(pins.length);
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
                    color: Colors.white,),
                  onPressed: (){
                    showDialog(context: context, builder: (_) => new PinDetailsPage(pin));
                  },

              )));
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
    if(loading){
      return WillPopScope(
          child: Scaffold(
              body: (
                  Center(
                    child: CircularProgressIndicator(),
                  ))
          ),
          onWillPop: () async => false);
    }
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
