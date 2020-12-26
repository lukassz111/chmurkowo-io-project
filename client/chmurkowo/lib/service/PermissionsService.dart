import 'package:permission_handler/permission_handler.dart';

class PermissionsService {
  static final PermissionsService _instance = PermissionsService._internal();

  factory PermissionsService() {
    return _instance;
  }
  PermissionsService._internal();

  List<Permission> neededPermissions = [
    Permission.location,
    Permission.locationWhenInUse
  ];

  Future<bool> requestAllNeededPermissions() async {
    List<Permission> reRequest = new List<Permission>();
    for (var i = 0; i < neededPermissions.length; i++) {
      var status = await this.requestPermission(this.neededPermissions[i]);
      if (!status.isGranted) {
        return false;
      }
    }
    return true;
  }

  Future<PermissionStatus> requestPermission(Permission permission) async {
    return await permission.request();
  }
}
