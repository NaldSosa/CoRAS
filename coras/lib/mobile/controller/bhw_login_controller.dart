import 'dart:convert';
import 'package:coras/api_client.dart';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:hive/hive.dart';

class BhwLoginController {
  String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<Map<String, dynamic>> loginOnline(
    String username,
    String password,
  ) async {
    try {
      final response = await ApiClient.dio.post(
        "/accounts/mobile-login/",
        data: {"username": username, "password": password},
        options: Options(headers: {"Authorization": ""}),
      );

      if (response.statusCode == 200) {
        final accessToken = response.data["access_token"];
        final refreshToken = response.data["refresh_token"];
        final user = Map<String, dynamic>.from(response.data["user"]);

        final authBox = Hive.box("authBox");
        await authBox.put("accessToken", accessToken);
        await authBox.put("refreshToken", refreshToken);
        await authBox.put("user", user);

        await authBox.put("username", username);
        await authBox.put("password", _hashPassword(password));

        return {"success": true, "message": "Login successful", "user": user};
      } else {
        return {"success": false, "message": "Invalid credentials"};
      }
    } catch (e) {
      return {"success": false, "message": "Error: $e"};
    }
  }

  Future<Map<String, dynamic>> loginOffline(
    String username,
    String password,
  ) async {
    final authBox = Hive.box("authBox");
    final user = authBox.get("user");
    final savedUsername = authBox.get("username");
    final savedPassword = authBox.get("password");

    if (user != null &&
        (savedUsername == username || user["email"] == username) &&
        savedPassword == _hashPassword(password)) {
      return {
        "success": true,
        "message": "Offline login successful",
        "user": user,
      };
    }

    return {"success": false, "message": "Offline login failed"};
  }
}
