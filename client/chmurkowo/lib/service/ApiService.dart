class ApiService {
  static final ApiService _instance = ApiService._internal();

  factory ApiService() {
    return _instance;
  }

  ApiService._internal();
}
