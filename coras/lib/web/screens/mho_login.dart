// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class MhoLogin extends StatelessWidget {
  const MhoLogin({super.key});

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
              onLogin: () {
                Navigator.pushReplacementNamed(context, "/mhoDashboard");
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _LoginCard extends StatelessWidget {
  final VoidCallback onLogin;
  const _LoginCard({required this.onLogin});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double width =
            constraints.maxWidth < 600 ? constraints.maxWidth * 0.75 : 340;

        return Center(
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // Main card
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
                    const SizedBox(height: 10),
                    const Text(
                      "CoRAS",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF388E3C),
                        letterSpacing: 1.1,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      "Log in to your account",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 13, color: Colors.black54),
                    ),
                    const SizedBox(height: 20),

                    // Email field
                    SizedBox(
                      height: 45,
                      child: TextField(
                        style: const TextStyle(fontSize: 13), // smaller font
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.green[50],
                          hintText: "Email",
                          hintStyle: const TextStyle(
                            fontSize: 13,
                          ), // smaller hint
                          prefixIcon: const Icon(
                            Icons.email_outlined,
                            size: 18, // smaller icon
                            color: Color(0xFF66BB6A),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 10,
                          ),
                        ),
                        cursorColor: Colors.green,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Password field
                    SizedBox(
                      height: 45,
                      child: TextField(
                        obscureText: true,
                        style: const TextStyle(fontSize: 13), // smaller font
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.green[50],
                          hintText: "Password",
                          hintStyle: const TextStyle(
                            fontSize: 13,
                          ), // smaller hint
                          prefixIcon: const Icon(
                            Icons.lock_outline,
                            size: 18, // smaller icon
                            color: Color(0xFF66BB6A),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 10,
                          ),
                        ),
                        cursorColor: Colors.green,
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Forgot password with hover + clickable cursor
                    Align(
                      alignment: Alignment.centerRight,
                      child: MouseRegion(
                        cursor:
                            SystemMouseCursors
                                .click, // 👈 makes cursor clickable
                        child: GestureDetector(
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Forgot Password clicked"),
                              ),
                            );
                          },
                          child: TweenAnimationBuilder<Color?>(
                            duration: const Duration(milliseconds: 200),
                            tween: ColorTween(
                              begin: Colors.green[700],
                              end: Colors.green[700],
                            ),
                            builder: (context, color, child) {
                              return Text(
                                "Forgot Password?",
                                style: TextStyle(
                                  color: color,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 15),

                    // Login button
                    SizedBox(
                      width: double.infinity,
                      height: 45,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF43A047),
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: onLogin,
                        child: const Text(
                          "LOG IN",
                          style: TextStyle(
                            fontSize: 14,
                            letterSpacing: 1,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Logo floating above card
              Positioned(
                top: -45,
                left: 0,
                right: 0,
                child: Center(
                  child: Image.asset("assets/images/mhologo.png", height: 90),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
