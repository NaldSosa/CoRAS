import 'package:coras/web/controller/mho_login_controller.dart';
import 'package:flutter/material.dart';

class MhoLogin extends StatefulWidget {
  const MhoLogin({super.key});

  @override
  State<MhoLogin> createState() => _MhoLoginState();
}

class _MhoLoginState extends State<MhoLogin> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final MhoLoginController loginController = MhoLoginController();

  bool isLoading = false;
  String? errorMessage;

  void handleLogin() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    final result = await loginController.login(
      usernameController.text.trim(),
      passwordController.text.trim(),
    );

    setState(() => isLoading = false);

    if (result["success"]) {
      Navigator.pushReplacementNamed(context, "/mhoDashboard");
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

  const _LoginCard({
    required this.usernameController,
    required this.passwordController,
    required this.onLogin,
    required this.isLoading,
    required this.errorMessage,
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
            color: Colors.white.withOpacity(0.9),
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

              TextField(
                controller: usernameController,
                decoration: InputDecoration(
                  hintText: "Username",
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

              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: "Password",
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

              Align(
                alignment: Alignment.centerRight,
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, "/mhoForgotPassword");
                    },
                    child: const Text(
                      "Forgot Password?",
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),

              if (errorMessage != null) ...[
                const SizedBox(height: 10),
                Text(errorMessage!, style: const TextStyle(color: Colors.red)),
              ],

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                  onPressed: isLoading ? null : onLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF43A047),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child:
                      isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text("LOG IN"),
                ),
              ),
            ],
          ),
        ),

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
