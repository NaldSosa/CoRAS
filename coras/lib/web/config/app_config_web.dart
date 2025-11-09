import 'package:coras/api_client.dart';
import 'package:dio/dio.dart';

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
}

class AppConfigWeb {
  static void setAuthToken(String token) {
    ApiClient.dio.options.headers['Authorization'] = 'Bearer $token';
  }

  static void clearAuthToken() {
    ApiClient.dio.options.headers.remove('Authorization');
  }

  static Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    return await ApiClient.dio.get(path, queryParameters: queryParameters);
  }

  static Future<Response> post(String path, {dynamic data}) async {
    return await ApiClient.dio.post(path, data: data);
  }

  static Future<Response> put(String path, {dynamic data}) async {
    return await ApiClient.dio.put(path, data: data);
  }

  static Future<Response> delete(String path, {dynamic data}) async {
    return await ApiClient.dio.delete(path, data: data);
  }
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
