import 'dart:convert';

import 'package:chmurkowo/service/AuthService.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static final ApiService _instance = ApiService._internal();

  factory ApiService() {
    return _instance;
  }

  static const domainName = "chmurkowo.azurewebsites.net";
  static const key =
      "code=lGt5C2sI49Q5rW4qRK9TpDK2ybnGXkalckkiCAdzKw1F0cVzgfearg==&clientId=client";
  static const methodHello = "Hello";
  String getFunctionUrl(String fName) {
    return "https://${domainName}/api/${fName}?${key}";
  }

  Map<String, String> get requestHeaders {
    var x = Map<String, String>();
    x.addEntries([
      MapEntry("Content-Type", "application/json"),
      MapEntry("Accept", "application/json")
    ]);
  }

  Future<http.Response> get(String url) async {
    return await http.get(url, headers: this.requestHeaders);
  }

  Future<http.Response> post(String url, Map<String, dynamic> data) async {
    return await http.post(url,
        body: data,
        headers: requestHeaders,
        encoding: Encoding.getByName('utf-8'));
  }

  Future<http.Response> hello() async {
    var response = await this
        .post(this.getFunctionUrl(methodHello), this.authService.user.toJson());
    print("status: ${response.statusCode}");
    print("headers: ${response.headers}");
    print("body: ${response.body}");
    return response;
  }

  ApiService._internal();
  AuthService authService = new AuthService();
}
