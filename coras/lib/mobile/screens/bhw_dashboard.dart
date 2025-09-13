import 'package:flutter/material.dart';
import '../widgets/bhw_sidebar.dart';

class BhwDashboard extends StatelessWidget {
  const BhwDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("BHW Dashboard")),
      drawer: const Sidebar(), // ✅ sidebar here
      body: const Center(child: Text("This is the BHW dashboard")),
    );
  }
}
