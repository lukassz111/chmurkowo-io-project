import 'package:chmurkowo/Page/TakePhotoPage.dart';
import 'package:flutter/material.dart';

class AddImagePage extends StatefulWidget {
  AddImagePage({Key key}) : super(key: key);

  @override
  _AddImagePageState createState() => _AddImagePageState();
}

class _AddImagePageState extends State<AddImagePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dodaj zdjęcie"),
      ),
      body: Center(
        child: ListView(
          padding: EdgeInsets.all(10),
          shrinkWrap: true,
          children: [
            ElevatedButton.icon(
                onPressed: () {
                  showDialog(
                      context: context, builder: (_) => new TakePhotoPage());
                },
                icon: Icon(Icons.photo_camera),
                label: Text("Zrób zdjęcie"))
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }
}
