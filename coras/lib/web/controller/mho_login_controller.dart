import 'package:coras/config/app_config.dart';
import 'package:hive/hive.dart';

class MhoLoginController {
  Future<Map<String, dynamic>> login(String username, String password) async {
    try {
      final response = await ApiClient.dio.post(
        "/accounts/web-login/",
        data: {"username": username, "password": password},
      );

      if (response.statusCode == 200) {
        final accessToken = response.data["access_token"];
        final refreshToken = response.data["refresh_token"];
        final user = Map<String, dynamic>.from(response.data["user"]);

        final authBox = Hive.box("authBox");
        await authBox.put("accessToken", accessToken);
        await authBox.put("refreshToken", refreshToken);
        await authBox.put("user", user);

        return {"success": true, "message": "Login successful"};
      } else {
        return {"success": false, "message": "Invalid credentials"};
      }
    } catch (e) {
      return {"success": false, "message": "Error: $e"};
    }
  }
}
