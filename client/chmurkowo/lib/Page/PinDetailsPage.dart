import 'dart:collection';
import 'dart:convert';
//import 'dart:html';

import 'package:chmurkowo/model/DisplayPin.dart';
import 'package:chmurkowo/service/ApiService.dart';
import 'package:flutter/material.dart';
import 'package:chmurkowo/model/User.dart';
import 'package:geocoding/geocoding.dart';

class PinDetailsPage extends StatefulWidget {
  final DisplayPin pin;

  PinDetailsPage(this.pin, {Key key}) : super(key: key);
  @override
  _PinDetailsPageState createState() => _PinDetailsPageState();
}

class _PinDetailsPageState extends State<PinDetailsPage> {
  Widget _photo = new CircularProgressIndicator();
  Widget _info = Center(
      child: new CircularProgressIndicator();
  );
  bool loadingPhoto = true;
  bool loadingInfo = true;
  final cardHeight = 400.0;
  List<Placemark> locations;
  User user = null;

  @override
  void initState() {
    ApiService apiService = new ApiService();

    if (loadingPhoto) {
      print("tupolew");
      apiService
          .getImageForPin(widget.pin.getId().toString())
          .then((photoLink) {
        if (photoLink is String) {
          this._photo = new Image.network(photoLink);
        }
        setState(() {
          loadingPhoto = false;
        });
      });
    }
    if (loadingInfo) {
      print("tupolew2");
      print(widget.pin.getUserId());
      apiService.getUserById(widget.pin.getUserId()).then((user) {
        print(user);
        if (user != null) {
          print("user wczytany");
          this.user = user;
          print(user);
          _info = Text(
            "Użytkownik: ${this.user.displayName}\nID pinu: ${widget.pin.getId()}\nSzerokość geograficzna: ${widget.pin.getPosition().latitude}\nDługość geograficzna: ${widget.pin.getPosition().longitude}\nLokalizacja: \n",
            textAlign: TextAlign.left,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 17,
                decoration: TextDecoration.none,
                color: Colors.black),
          );
          setState(() {
            loadingInfo = false;
          });
        }
      });
      /*placemarkFromCoordinates(widget.pin.position.latitude, widget.pin.position.longitude).then((locationValues) {
        print("tu");
        if(locationValues.length > 0){
          print("tutaj");
          this.locations = locationValues;
        }
      });*/
    }
  }

  @override
  Widget build(BuildContext context) {
    ApiService apiService = new ApiService();
    return Scaffold(
      appBar: AppBar(
        title: Text("Zdjęcie"),
      ),
      body: Center(
        child: ListView(
          children: [
            new Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              SizedBox(
                height: this.cardHeight,
                child: Card(
                  color: Color.fromRGBO(10, 100, 150, 0.5),
                  // This ensures that the Card's children (including the ink splash) are clipped correctly.
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    // Generally, material cards use onSurface with 12% opacity for the pressed state.
                    splashColor:
                        Theme.of(context).colorScheme.onSurface.withOpacity(0),
                    // Generally, material cards do not have a highlight overlay.
                    highlightColor: Colors.transparent,
                    child: Center(
                      child: _photo,
                    ),
                    //child: TravelDestinationContent(destination: destination),
                  ),
                ),
              ),
            ]),
            ListTile(
              title: _info,
            ),
          ],
        ),
      ),
    );
  }
}
