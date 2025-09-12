import 'package:flutter/material.dart';

class MhoForgotPassword extends StatelessWidget {
  const MhoForgotPassword({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Forgot Password (MHO)")),
      body: const Center(
        child: Text(
          "MHO Forgot Password Screen (Design placeholder)",
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
