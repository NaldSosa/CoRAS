import 'package:flutter/material.dart';

class BhwForgotPassword extends StatelessWidget {
  const BhwForgotPassword({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Forgot Password (BHW)")),
      body: const Center(
        child: Text(
          "BHW Forgot Password Screen (Design placeholder)",
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
