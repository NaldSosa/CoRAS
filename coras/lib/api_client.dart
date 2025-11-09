import 'package:coras/mobile/config/app_config_mobile.dart';
import 'package:coras/web/config/app_config_web.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  static String get baseUrl => dotenv.env['API_URL'] ?? "127.0.0.1:8000";
}

class ApiClient {
  static final Dio dio =
      Dio(
          BaseOptions(
            baseUrl: AppConfig.baseUrl,
            connectTimeout: const Duration(seconds: 30),
            receiveTimeout: const Duration(seconds: 30),
            headers: {"Content-Type": "application/json"},
          ),
        )
        ..interceptors.add(AuthInterceptorMobile())
        ..interceptors.add(AuthInterceptorWeb());
}
