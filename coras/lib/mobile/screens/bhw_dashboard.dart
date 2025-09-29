import 'package:coras/mobile/widgets/bhw_sidebar.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class BhwDashboard extends StatelessWidget {
  const BhwDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final authBox = Hive.box("authBox");
    final user = authBox.get("user", defaultValue: {});

    final String firstName = user["first_name"] ?? "";
    final String role =
        (user["groups"] != null && user["groups"].isNotEmpty)
            ? (user["groups"] as List).join(", ")
            : "Barangay Health Worker";

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF388E3C),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Welcome, $firstName!",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              role,
              style: const TextStyle(fontSize: 13, color: Colors.white70),
            ),
          ],
        ),
      ),
      drawer: const Sidebar(),
      body: const Center(
        child: Text("Dashboard Content Here", style: TextStyle(fontSize: 16)),
      ),
    );
  }
}
