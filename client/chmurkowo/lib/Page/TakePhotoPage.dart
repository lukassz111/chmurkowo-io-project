import 'package:camerawesome/camerapreview.dart';
import 'package:camerawesome/models/capture_modes.dart';
import 'package:camerawesome/models/flashmodes.dart';
import 'package:camerawesome/models/orientations.dart';
import 'package:camerawesome/models/sensors.dart';
import 'package:camerawesome/picture_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class TakePhotoPage extends StatefulWidget {
  TakePhotoPage({Key key}) : super(key: key);

  @override
  _TakePhotoPageState createState() => _TakePhotoPageState();
}

class _TakePhotoPageState extends State<TakePhotoPage> {
  @override
  void initState() {}

  @override
  void dispose() {
    super.dispose();
    _switchFlash.dispose();
    _zoom.dispose();
    _sensor.dispose();
    _captureMode.dispose();
    _photoSize.dispose();
  }

  ValueNotifier<CameraFlashes> _switchFlash = ValueNotifier(CameraFlashes.NONE);
  ValueNotifier<double> _zoom = ValueNotifier(0.64);
  ValueNotifier<Sensors> _sensor = ValueNotifier(Sensors.BACK);
  ValueNotifier<CaptureModes> _captureMode = ValueNotifier(CaptureModes.PHOTO);
  ValueNotifier<Size> _photoSize = ValueNotifier(null);
  DeviceOrientation deviceOrientation = DeviceOrientation.portraitUp;
  PictureController _pictureController = new PictureController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CameraAwesome(
          testMode: false,
          onPermissionsResult: (bool result) {},
          selectDefaultSize: (List<Size> availableSizes) {
            Size max = availableSizes.first;
            for (var size in availableSizes) {
              if (size.height > max.height) {
                max = size;
              }
            }
            return max;
          },
          onCameraStarted: () {},
          onOrientationChanged: (CameraOrientations newOrientation) {
            setState(() {
              if (CameraOrientations.PORTRAIT_UP == newOrientation) {
                deviceOrientation = DeviceOrientation.portraitUp;
              } else if (CameraOrientations.PORTRAIT_DOWN == newOrientation) {
                deviceOrientation = DeviceOrientation.portraitDown;
              } else if (CameraOrientations.LANDSCAPE_LEFT == newOrientation) {
                deviceOrientation = DeviceOrientation.landscapeLeft;
              } else if (CameraOrientations.LANDSCAPE_RIGHT == newOrientation) {
                deviceOrientation = DeviceOrientation.landscapeRight;
              }
            });
          },
          zoom: _zoom,
          sensor: _sensor,
          photoSize: _photoSize,
          switchFlashMode: _switchFlash,
          captureMode: _captureMode,
          orientation: deviceOrientation,
          fitted: false,
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.camera),
          onPressed: () async {
            final path = join(
              (await getTemporaryDirectory()).path,
              '${DateTime.now()}.png',
            );
            print("Picture saved to: $path");
            await _pictureController.takePicture(path);
            Navigator.of(context).pop(path);
          },
        )
    ); //https://storageaccountchmur9085.file.core.windows.net/chmurkowo83f2/data/image/img_4_7085ede917151550b49d25e44868a943.png
  }
}