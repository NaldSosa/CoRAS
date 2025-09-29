import 'package:dio/dio.dart';
import 'app_config.dart';

class ApiClientWeb {
  static String? _accessToken;
  static String? _refreshToken;

  static Future<Response> login(String username, String password) async {
    final response = await ApiClient.dio.post(
      "token/",
      data: {"username": username, "password": password},
    );
    if (response.statusCode == 200) {
      _accessToken = response.data["access"];
      _refreshToken = response.data["refresh"];
    }
    return response;
  }

  static Future<Response> getUsers() => ApiClient.dio.get("users/");
  static Future<Response> createUser(Map<String, dynamic> data) =>
      ApiClient.dio.post("users/", data: data);
  static Future<Response> updateUser(int id, Map<String, dynamic> data) =>
      ApiClient.dio.put("users/$id/", data: data);
  static Future<Response> getLocationOptions(String role) => ApiClient.dio.get(
    "users/location_options/",
    queryParameters: {"role": role},
  );
}

class AuthInterceptorWeb extends Interceptor {
  @override
  void onRequest(options, handler) {
    if (ApiClientWeb._accessToken != null) {
      options.headers["Authorization"] = "Bearer ${ApiClientWeb._accessToken}";
    }
    return handler.next(options);
  }

  @override
  void onError(DioException err, handler) async {
    if (err.response?.statusCode == 401 && ApiClientWeb._refreshToken != null) {
      final response = await Dio(
        BaseOptions(baseUrl: AppConfig.baseUrl),
      ).post("token/refresh/", data: {"refresh": ApiClientWeb._refreshToken});
      if (response.statusCode == 200) {
        ApiClientWeb._accessToken = response.data["access"];
        err.requestOptions.headers["Authorization"] =
            "Bearer ${ApiClientWeb._accessToken}";
        final cloneResponse = await Dio().fetch(err.requestOptions);
        return handler.resolve(cloneResponse);
      }
    }
    return handler.next(err);
  }
}
