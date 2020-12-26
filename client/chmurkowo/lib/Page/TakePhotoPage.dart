import 'package:camera/camera.dart';
import 'package:chmurkowo/service/CameraService.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class TakePhotoPage extends StatefulWidget {
  TakePhotoPage({Key key}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  _TakePhotoPageState createState() => _TakePhotoPageState();
}

class _TakePhotoPageState extends State<TakePhotoPage> {
  CameraController cameraController;
  CameraService cameraService;
  Future<void> cameraControllerInitializer;
  Widget preview = new Text("");
  @override
  void initState() {
    cameraService = new CameraService();
    cameraController = new CameraController(
        cameraService.BackCamera, ResolutionPreset.high,
        enableAudio: false);
    cameraControllerInitializer = cameraController.initialize();
    //final camera = cameras.firstWhere(
    //        (camera) => camera.lensDirection == CameraLensDirection.back);
    //CameraController cameraController =
    //new CameraController(camera, ResolutionPreset.ultraHigh);
  }

  @override
  void dispose() {
    super.dispose();
    cameraController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Zrób zdjęcie"),
      ),
      body: FutureBuilder<void>(
        future: cameraControllerInitializer,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return CameraPreview(cameraController);
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ), // Th
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.camera),
        onPressed: () async {
          try {
            await cameraControllerInitializer;
            final picture = await cameraController.takePicture();
            print(picture.path);
          } catch (e) {
            print(e);
          }
        },
      ), // is trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
