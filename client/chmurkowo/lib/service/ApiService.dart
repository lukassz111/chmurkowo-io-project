import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:chmurkowo/model/DisplayPin.dart';
import 'package:flutter/material.dart';

import 'package:latlong/latlong.dart';
import 'package:chmurkowo/service/AuthService.dart';
import 'package:http/http.dart' as http;
import 'package:json_annotation/json_annotation.dart';

class ApiService {
  static const ErrorOk = 0;
  static const ErrorSomethingGetsWrong = 1;
  static const ErrorRequireArgument = 2;
  static const ErrorAddPinTooSmallOffset = 3;
  static const ErrorAddPinImageDoNotRepresentCloud = 4;
  static const ErrorNoImage = 5;

  static getMessageForErrorCode(int errorCode) {
    switch (errorCode) {
      case ErrorOk:
        return "Wszystko wporządku";
      case ErrorSomethingGetsWrong:
        return "Coś poszło nie tak";
        case ErrorAddPinTooSmallOffset:
        return "Spróbuj za 30 minut, nie masz premium więc musisz poczekać";
      case ErrorAddPinImageDoNotRepresentCloud:
        return "To zdjecie nie zawiera chmur, jeśli jednak na zdjęciu są chmury to spróbuj jeszcze raz";
      case ErrorNoImage:
        return "Nie udało się pobrać zdjęcia";
      default:
        return "Błąd numer: ${errorCode}";
    }
  }

  static final ApiService _instance = ApiService._internal();

  factory ApiService() {
    return _instance;
  }
  static const azureDomainName = "chmurkowo.azurewebsites.net";
  static const localDomainName = "192.168.1.183:7071";
  static get protocol {
    return "https";
  }

  static get domainName {
    return ApiService.azureDomainName;
  }

  static const key = "code=lGt5C2sI49Q5rW4qRK9TpDK2ybnGXkalckkiCAdzKw1F0cVzgfearg==";
  static const methodHello = "Hello";
  static const methodAddPin = "AddPin";
  static const methodPhotoNameByPinId = "GetPhotoNameByPinId";
  static const methodPhotoByPinId = "GetImage";
  static const methodAllPins = "GetAllPins";
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
      if (meta.containsKey('success')) {
        print(responseData);
        var success = meta['success'];
        var pinId = data['pinId'];
        if (success) {
          return {
            "pinId": pinId,
            "error_code": meta['error_code'],
            "success": success
          };
        } else {
          return {"error_code": meta['error_code'], "success": success};
        }
      }
    }
    print("If you see this you need to check api endpoint");
    return {"error_code": ErrorSomethingGetsWrong, "success": false};
  }

  Future<dynamic> getImageNameForPin(String pinId) async{
    Map<String, String> data = new Map<String, String>();
    data.addEntries([MapEntry("pinId", pinId.toString())]);
    print(this.getFunctionUrl(methodPhotoNameByPinId));
    var response = await this.post(this.getFunctionUrl(methodPhotoNameByPinId), data);
    var responseString = response.body;
    print("Response string = "+responseString);
    Map<String, dynamic> responseData = json.decode(responseString);
    if (responseData.containsKey('meta') && responseData.containsKey('data')) {
      Map<String, dynamic> meta = responseData['meta'];
      Map<String, dynamic> data = responseData['data'];
      if (meta.containsKey('success')) {
        print(responseData);
        var success = meta['success'];
        var photoName = data['photoName'];
        if (success) {
          return photoName;
        } else {
          return {"error_code": meta['error_code'], "success": success};
        }
      }
    }
    return {"error_code": ErrorSomethingGetsWrong, "success": false};
  }

  Future<dynamic> getImageForPin(String pinId) async{
    var imageName = await getImageNameForPin(pinId);
    var imageNameString = imageName.toString()+".png";
    if(imageName is String) {
      var url = this.getFunctionUrl(methodPhotoByPinId);
      url += "&i="+imageNameString;
      return url;
    }
    return {"error_code": ErrorNoImage};
  }

  Future<dynamic> getAllPins() async{
    var response = await this.get(this.getFunctionUrl(methodAllPins));
    var responseString = response.body;
    Map<String, dynamic> responseData = json.decode(responseString);
    if (responseData.containsKey('meta') && responseData.containsKey('data')) {
      Map<String, dynamic> meta = responseData['meta'];
      Map<String, dynamic> data = responseData['data'];
      if (meta.containsKey('success')) {
        print(responseData);
        var success = meta['success'];
        if (success) {
          var dataList = data["pinsData"];
          List<DisplayPin> pins = new List<DisplayPin>();
          for (var i = 0; i < dataList.length; i++){
            var id = dataList[i]['id'];
            print(i);
            var latitude = dataList[i]['latitude'];
            var longitude = dataList[i]['longitude'];
            pins.add(new DisplayPin.a(new LatLng(double.tryParse(latitude.toString()), double.tryParse(longitude.toString())), 'test$i', id));
          }
          return pins;
        } else {
          return {"error_code": meta['error_code'], "success": success};
        }
      }
    }
  }

  ApiService._internal();
  AuthService authService = new AuthService();
}

