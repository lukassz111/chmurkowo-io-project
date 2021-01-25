
import 'dart:collection';
import 'dart:convert';
//import 'dart:html';

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
  final cardHeight = 400.0;


  @override
  void initState() {
    if(loading){
      ApiService apiService = new ApiService();
      apiService.getImageForPin(widget.pin.getId().toString()).then((photoLink) {
        if(photoLink is String){
          this._photo = new Image.network(photoLink);
          setState(() {
            loading = false;
          });
        }
      }
      );}
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            new Row(
              children: [SizedBox(
                height: this.cardHeight,
                child: Card(
                  color: Color.fromRGBO(10, 100, 150, 0.5),
                  // This ensures that the Card's children (including the ink splash) are clipped correctly.
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    // Generally, material cards use onSurface with 12% opacity for the pressed state.
                    splashColor: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.12),
                    // Generally, material cards do not have a highlight overlay.
                    highlightColor: Colors.transparent,
                    child: Center(
                      child: _photo,
                    ),
                    //child: TravelDestinationContent(destination: destination),
                  ),
                ),
              ),]
            ),
            new Container (
              color: Color.fromARGB(200, 100, 100, 150),
              child:  new Row(
                children: [
                  Text(
                    "Użytkownik: ",
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontWeight: FontWeight.normal, fontSize: 17, decoration: TextDecoration.none, color: Colors.black),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}