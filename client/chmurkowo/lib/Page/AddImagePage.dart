import 'package:chmurkowo/Page/TakePhotoPage.dart';
import 'package:chmurkowo/service/LocationService.dart';
import 'package:flutter/material.dart';
import 'package:latlong/latlong.dart';
import 'dart:io';

class AddImagePage extends StatefulWidget {
  AddImagePage({Key key}) : super(key: key);

  @override
  _AddImagePageState createState() => _AddImagePageState();
}

class _AddImagePageState extends State<AddImagePage> {
  String pathToImage = null;
  LatLng location = null;
  LocationService locationService = new LocationService();

  Function() callbackSubmit = null;

  void callbackSubmitWhenValid() {
    //TODO implemnet send to cloud
    Navigator.of(context).pop();
  }

  void valid() {
    if (pathToImage == null || location == null) {
      setState(() {
        callbackSubmit = null;
      });
      return;
    }
    if (pathToImage.isEmpty) {
      setState(() {
        callbackSubmit = null;
      });
      return;
    }
    setState(() {
      callbackSubmit = callbackSubmitWhenValid;
    });
  }

  List<Widget> get childrens {
    List<Widget> result = new List<Widget>();
    Widget x = null;
    if (pathToImage != null) {
      File file = new File(pathToImage);
      x = Image.file(file);
      result.add(x);
    }
    x = ElevatedButton.icon(
        onPressed: () {
          setState(() {
            pathToImage = null;
            location = null;
          });
          showDialog(context: context, builder: (_) => new TakePhotoPage())
              .then((value) {
            locationService.currentLocation().then((value) => setState(() {
                  this.location = value;
                }));
            setState(() {
              this.pathToImage = value;
            });
          });
        },
        icon: Icon(Icons.photo_camera),
        label: Text("Zrób zdjęcie"));
    result.add(x);

    Widget locationProgress = location == null
        ? CircularProgressIndicator()
        : Icon(Icons.check_circle_outline);
    x = ListTile(
      title: Text("Lokalizacja"),
      subtitle: Text(location == null
          ? "jeszcze nie wiem, proszę poczekaj"
          : "${location.latitudeInRad} ${location.longitudeInRad}"),
      leading: locationProgress,
    );
    result.add(x);

    x = ElevatedButton.icon(
        onPressed: callbackSubmit,
        icon: Icon(Icons.cloud_upload),
        label: Text("Dodaj"));
    result.add(x);
    return result;
  }

  @override
  Widget build(BuildContext context) {
    valid();
    return Scaffold(
      appBar: AppBar(
        title: Text("Dodaj zdjęcie"),
      ),
      body: Center(
        child: ListView(
          padding: EdgeInsets.all(10),
          shrinkWrap: true,
          children: childrens,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }
}
