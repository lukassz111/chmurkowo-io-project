import 'dart:convert';

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
  String getFunctionUrl(String fName) {
    return "${protocol}://${domainName}/api/${fName}?${key}";
  }

  Map<String, String> requestHeaders(String body) {
    var x = Map<String, String>();
    int contentLength = utf8.encode(body).length;
    x.addEntries([
      //MapEntry("Content-Type", "application/json"),
      //MapEntry("Content-Length", "$contentLength"),
      //MapEntry("Accept", "application/json"),
      MapEntry("Accept", "*/*"),
      MapEntry("Host", domainName)
    ]);
  }

  Future<http.Response> get(String url) async {
    return await http.get(url, headers: this.requestHeaders(""));
  }

  Future<http.Response> post(String url, Map<String, dynamic> data) async {
    var dataJsonString = json.encode(data);
    print(dataJsonString);

    return await http.post(url,
        body: data,
        headers: requestHeaders(dataJsonString),
        encoding: Encoding.getByName('utf-8'));
  }

  Future<http.Response> hello() async {
    var response = await this
        .post(this.getFunctionUrl(methodHello), this.authService.user.toMap());
    print("status: ${response.statusCode}");
    print("headers: ${response.headers}");
    print("body: ${response.body}");
    print("response: ${response}");
    return response;
  }

  ApiService._internal();
  AuthService authService = new AuthService();
}
