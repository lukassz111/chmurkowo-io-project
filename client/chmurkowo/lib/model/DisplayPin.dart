import 'package:latlong/latlong.dart';

class DisplayPin {
  LatLng position;
  String name;
  int id;
  String userId;
  String photoFilename;

  DisplayPin.a (LatLng position, String name, int id, String user, String photoFilename){
    this.position = position;
    this.name = name;
    this.id = id;
    this.userId = user;
    this.photoFilename = photoFilename;
  }

  DisplayPin.b (this.position, this.name){
    this.position = position;
    this.name = name;
  }

  int getId(){
    return this.id;
  }

  LatLng getPosition(){
    return this.position;
  }

  String getUserId(){
    return this.userId;
  }
}
