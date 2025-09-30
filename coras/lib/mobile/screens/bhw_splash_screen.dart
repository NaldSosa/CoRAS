import 'dart:async';
import 'package:flutter/material.dart';
import 'bhw_login.dart';

class BhwSplash extends StatefulWidget {
  const BhwSplash({super.key});

  @override
  State<BhwSplash> createState() => _BhwSplashState();
}

class _BhwSplashState extends State<BhwSplash> {
  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 5), () {
      Navigator.of(context).pushReplacement(_createFadeRoute());
    });
  }

  Route _createFadeRoute() {
    return PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 800),
      pageBuilder: (context, animation, secondaryAnimation) => const BhwLogin(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image(image: AssetImage("assets/images/mhologo.png"), height: 120),
            SizedBox(height: 20),
            Text(
              "Community Recommender AI-Driven System",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF43A047),
                letterSpacing: 1.2,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "Powered by Gemini AI",
              style: TextStyle(fontSize: 14, color: Color(0x89000000)),
            ),
          ],
        ),
      ),
    );
  }
}
