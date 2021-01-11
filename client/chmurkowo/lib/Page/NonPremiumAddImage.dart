import 'package:flutter/material.dart';

class NonPremiumAddImage extends StatefulWidget {
  NonPremiumAddImage({Key key}) : super(key: key);
  @override
  _NonPremiumAddImageState createState() => _NonPremiumAddImageState();
}

class _NonPremiumAddImageState extends State<NonPremiumAddImage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            new Text('Nie masz premium, spróbuj za 30 minut',
                style: new TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87)),
            new Text('lub wystąpił jakiś błąd',
                style: new TextStyle(
                    fontSize: 13.0,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87)),
          ],
        ),
      ),
    );
  }
}
