
import 'dart:convert';

import 'package:chmurkowo/model/DisplayPin.dart';
import 'package:chmurkowo/service/ApiService.dart';
import 'package:flutter/material.dart';


class PinDetailsPage extends StatefulWidget {
  final DisplayPin pin;

  PinDetailsPage(this.pin, {Key key}) : super(key: key);
  @override
  _PinDetailsPageState createState() => _PinDetailsPageState();
}

class _PinDetailsPageState extends State<PinDetailsPage> {

  Widget _photo = new CircularProgressIndicator();
  bool loading = true;

  @override
  void initState() {
    /*if(loading){
      ApiService apiService = new ApiService();
      apiService.getImageForPin(widget.pin.getId().toString()).then((photoLink) {
        /*if(photoLink is ){
          print("Photolink: "+photoLink.toString());
          this._photo = new Image.network(photoLink);
          print(this._photo);
          setState(() {
            loading = false;
          });*/
        }
      }
      );}*/
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          body: (
              Center(
                child: this._photo,
              ))
          ),
        onWillPop: () async => false);
  }
}
