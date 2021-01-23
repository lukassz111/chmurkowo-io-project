import 'package:flutter/material.dart';

class ErrorAddImage extends StatefulWidget {
  ErrorAddImage({Key key}) : super(key: key);
  @override
  _ErrorAddImageState createState() => _ErrorAddImageState();
}

class _ErrorAddImageState extends State<ErrorAddImage> {
  @override
  Widget build(BuildContext context) {
    final String errorMessage = ModalRoute.of(context).settings.arguments;
    print(errorMessage);
    return Scaffold(
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            new Text(errorMessage,
                style: new TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87))
          ],
        ),
      ),
    );
  }
}
