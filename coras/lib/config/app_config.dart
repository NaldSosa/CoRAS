import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive/hive.dart';

class AppConfig {
  static String get baseUrl => dotenv.env['API_URL'] ?? "";
}

class ApiClient {
  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: AppConfig.baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {"Content-Type": "application/json"},
    ),
  )..interceptors.add(AuthInterceptor());
}

class AuthInterceptor extends Interceptor {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final authBox = Hive.box("authBox");
    final accessToken = authBox.get("accessToken");

    final skipAuth =
        options.path.contains("mobile-login") ||
        options.path.contains("refresh");

    if (accessToken != null && !skipAuth) {
      options.headers["Authorization"] = "Bearer $accessToken";
    }

    if (kDebugMode) {
      print("Request path: ${options.path}");
      print("Final headers: ${options.headers}");
    }

    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      final authBox = Hive.box("authBox");
      final refreshToken = authBox.get("refreshToken");

      if (refreshToken != null) {
        try {
          final dio = Dio(BaseOptions(baseUrl: AppConfig.baseUrl));
          final response = await dio.post(
            "/accounts/refresh/",
            data: {"refresh": refreshToken},
          );

          if (response.statusCode == 200) {
            final newAccessToken = response.data["access"];
            await authBox.put("accessToken", newAccessToken);

            final retryReq = err.requestOptions;
            retryReq.headers["Authorization"] = "Bearer $newAccessToken";

            final cloneResponse = await dio.fetch(retryReq);
            return handler.resolve(cloneResponse);
          } else {
            await _logoutUser(authBox);
          }
        } catch (e) {
          await _logoutUser(authBox);
        }
      } else {
        await _logoutUser(authBox);
      }
    }

    return handler.next(err);
  }

  Future<void> _logoutUser(Box authBox) async {
    await authBox.delete("accessToken");
    await authBox.delete("refreshToken");
    await authBox.delete("user");
    await authBox.delete("username");
    await authBox.delete("password");
  }
}
