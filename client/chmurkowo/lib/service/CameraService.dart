import 'package:camera/camera.dart';

class CameraService {
  static final CameraService _instance = CameraService._internal();

  factory CameraService() {
    return _instance;
  }

  CameraService._internal() {
    _initialized = false;
    _cameras = new List<CameraDescription>();
    availableCameras().then((cameras) {
      this._cameras = cameras;
      _initialized = true;
    });
  }

  List<CameraDescription> _cameras;
  bool _initialized;
  bool get Initialized {
    return _initialized;
  }

  CameraDescription get BackCamera {
    return _cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.back);
  }

  CameraDescription get FrontCamera {
    return _cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front);
  }
}
