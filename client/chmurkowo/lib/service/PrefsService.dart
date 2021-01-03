import 'package:shared_preferences/shared_preferences.dart';

class PrefsService {
  static final PrefsService _instance = PrefsService._internal();

  factory PrefsService() {
    return _instance;
  }

  Future<SharedPreferences> prefs;
  PrefsService._internal() {
    prefs = SharedPreferences.getInstance();
  }
  Future<bool> _getBool(String name, bool defaultValue) async {
    var p = await prefs;
    if (p.containsKey(name)) {
      return p.getBool(name);
    } else {
      return defaultValue;
    }
  }

  Future<bool> _setBool(String name, bool value) async {
    var p = await prefs;
    await p.setBool(name, value);
  }

  Future<bool> userHelloDone({bool value}) async {
    var key = "userHelloDone";
    if (value == null) {
      return await _getBool(key, false);
    }
    await _setBool(key, value);
    return await _getBool(key, false);
  }
}
