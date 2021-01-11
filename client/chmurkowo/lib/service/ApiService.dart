import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:latlong/latlong.dart';
import 'package:chmurkowo/service/AuthService.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static final ApiService _instance = ApiService._internal();

  factory ApiService() {
    return _instance;
  }
  static const azureDomainName = "chmurkowo.azurewebsites.net";
  static const localDomainName = "192.168.1.183:7071";
  static get protocol {
    return "http";
  }

  static get domainName {
    return ApiService.localDomainName;
  }

  static const key = "";
  static const methodHello = "Hello";
  static const methodAddPin = "AddPin";
  String getFunctionUrl(String fName) {
    return "${protocol}://${domainName}/api/${fName}?${key}";
  }

  Map<String, String> requestHeaders() {
    var x = Map<String, String>();
    x.addEntries([
      //MapEntry("Content-Type", "application/json"),
      //MapEntry("Content-Length", "$contentLength"),
      //MapEntry("Accept", "application/json"),
      MapEntry("Accept", "*/*"),
      MapEntry("Host", domainName)
    ]);
    return x;
  }

  Future<http.Response> get(String url) async {
    return await http.get(url, headers: this.requestHeaders());
  }

  Future<http.Response> post(String url, Map<String, dynamic> data) async {
    return await http.post(url,
        body: data,
        headers: requestHeaders(),
        encoding: Encoding.getByName('utf-8'));
  }

  Future<http.StreamedResponse> postFile(
      String url, Map<String, String> data, String filePath) async {
    var fBytes = await File(filePath).readAsBytes();
    String fBase64 = base64Encode(fBytes);
    var req = new http.MultipartRequest("POST", Uri.parse(url));
    req.headers.addEntries(requestHeaders().entries);
    data.forEach((key, value) {
      req.fields[key] = value;
    });
    req.fields['file'] = fBase64;
    var res = await req.send();
    return res;
  }

  Future<bool> hello() async {
    var response = await this
        .post(this.getFunctionUrl(methodHello), this.authService.user.toMap());
    Map<String, dynamic> data = json.decode(response.body);
    if (data.containsKey('meta')) {
      Map<String, dynamic> data_meta = data['meta'];
      if (data_meta.containsKey('success')) {
        bool data_meta_success = data_meta['success'];
        return data_meta_success;
      }
    }
    return false;
  }

  Future<dynamic> addPin(String pathToImage, LatLng position) async {
    Map<String, String> data = new Map<String, String>();
    data.addEntries([
      MapEntry("position_lat", position.latitude.toStringAsFixed(5)),
      MapEntry("position_long", position.longitude.toStringAsFixed(5)),
      MapEntry("id", authService.googleId)
    ]);
    var response = await this
        .postFile(this.getFunctionUrl(methodAddPin), data, pathToImage);
    var responseString = await response.stream.bytesToString();
    Map<String, dynamic> responseData = json.decode(responseString);
    print(responseData);
    if (responseData.containsKey('meta') && responseData.containsKey('data')) {
      Map<String, dynamic> meta = responseData['meta'];
      Map<String, dynamic> data = responseData['data'];
      if (meta.containsKey('success') && data.containsKey('pinId')) {
        var success = meta['success'];
        var pinId = data['pinId'];
        if (success) {
          return pinId;
        }
      }
    }
    return null;
  }

  ApiService._internal();
  AuthService authService = new AuthService();
}
