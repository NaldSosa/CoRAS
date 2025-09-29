// ignore_for_file: use_build_context_synchronously

import 'package:coras/mobile/controller/bhw_login_controller.dart';
import 'package:flutter/material.dart';
import '../services/network_service.dart';

class BhwLogin extends StatefulWidget {
  const BhwLogin({super.key});

  @override
  State<BhwLogin> createState() => _BhwLoginState();
}

class _BhwLoginState extends State<BhwLogin> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final BhwLoginController loginController = BhwLoginController();
  final NetworkService networkService = NetworkService();

  bool isOnline = false;
  bool isLoading = false;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    // ✅ listen to network changes
    networkService.status.listen((status) {
      setState(() => isOnline = status);
    });
  }

  Future<void> handleLogin() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    Map<String, dynamic> result;

    try {
      if (isOnline) {
        // ✅ Try online login (API)
        result = await loginController.loginOnline(
          usernameController.text.trim(),
          passwordController.text.trim(),
        );
      } else {
        // ✅ Fallback offline login (Hive)
        result = await loginController.loginOffline(
          usernameController.text.trim(),
          passwordController.text.trim(),
        );
      }
    } catch (e) {
      result = {"success": false, "message": "Unexpected error: $e"};
    }

    setState(() => isLoading = false);

    if (result["success"] == true) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Login successful")));
      Navigator.pushReplacementNamed(context, "/bhwDashboard");
    } else {
      setState(() => errorMessage = result["message"]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset("assets/images/municipal.jpg", fit: BoxFit.cover),
          Container(color: Colors.black.withOpacity(0.5)),
          Center(
            child: _LoginCard(
              usernameController: usernameController,
              passwordController: passwordController,
              onLogin: handleLogin,
              isLoading: isLoading,
              errorMessage: errorMessage,
              isOnline: isOnline,
            ),
          ),
        ],
      ),
    );
  }
}

class _LoginCard extends StatelessWidget {
  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final VoidCallback onLogin;
  final bool isLoading;
  final String? errorMessage;
  final bool isOnline;

  const _LoginCard({
    required this.usernameController,
    required this.passwordController,
    required this.onLogin,
    required this.isLoading,
    required this.errorMessage,
    required this.isOnline,
  });

  @override
  Widget build(BuildContext context) {
    double width =
        MediaQuery.of(context).size.width < 600
            ? MediaQuery.of(context).size.width * 0.75
            : 340;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: width,
          padding: const EdgeInsets.fromLTRB(20, 70, 20, 24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                blurRadius: 15,
                color: Colors.black.withOpacity(0.2),
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "CoRAS",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF388E3C),
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                "Log in to your account",
                style: TextStyle(fontSize: 13, color: Colors.black54),
              ),
              const SizedBox(height: 20),

              // Username
              TextField(
                controller: usernameController,
                cursorColor: Color.fromARGB(255, 105, 105, 105),
                enableSuggestions: false,
                decoration: InputDecoration(
                  hintText: "Username or Email",
                  hintStyle: const TextStyle(
                    color: Color(0xFF575757),
                    fontSize: 13,
                  ),
                  prefixIcon: const Icon(
                    Icons.person_outline,
                    size: 18,
                    color: Color(0xFF66BB6A),
                  ),
                  filled: true,
                  fillColor: Colors.green[50],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Password
              TextField(
                controller: passwordController,
                cursorColor: Color.fromARGB(255, 105, 105, 105),
                enableSuggestions: false,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: "Password",
                  hintStyle: const TextStyle(
                    color: Color(0xFF575757),
                    fontSize: 13,
                  ),
                  prefixIcon: const Icon(
                    Icons.lock_outline,
                    size: 18,
                    color: Color(0xFF66BB6A),
                  ),
                  filled: true,
                  fillColor: Colors.green[50],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // ✅ Forgot Password link
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, "/bhwForgotPassword");
                  },
                  child: const Text(
                    "Forgot Password?",
                    style: TextStyle(
                      color: Color(0xFF4CAF50),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              if (errorMessage != null) ...[
                const SizedBox(height: 10),
                Text(errorMessage!, style: const TextStyle(color: Colors.red)),
              ],

              const SizedBox(height: 20),

              // Login button
              SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                  onPressed: isLoading ? null : onLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4CAF50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child:
                      isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                            "LOG IN",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Colors.white,
                            ),
                          ),
                ),
              ),

              const SizedBox(height: 10),

              // ✅ Show network status for debugging
              Text(
                isOnline ? "Online mode" : "Offline mode",
                style: TextStyle(
                  fontSize: 12,
                  color: isOnline ? Colors.green : Colors.red,
                ),
              ),
            ],
          ),
        ),

        // ✅ Logo floating above card
        Positioned(
          top: -45,
          left: 0,
          right: 0,
          child: Center(
            child: Image.asset("assets/images/mhologo.png", height: 90),
          ),
        ),
      ],
    );
  }
}
