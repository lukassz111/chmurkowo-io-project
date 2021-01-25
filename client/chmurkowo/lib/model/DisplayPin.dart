import 'package:latlong/latlong.dart';

class DisplayPin {
  LatLng position;
  String name;
  int id;

  DisplayPin.a (LatLng position, String name, int id){
    this.position = position;
    this.name = name;
    this.id = id;
  }

  DisplayPin.b (this.position, this.name){
    this.position = position;
    this.name = name;
  }

  int getId(){
    return this.id;
  }
}
