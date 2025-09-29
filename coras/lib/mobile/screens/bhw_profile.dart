import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class BhwProfile extends StatelessWidget {
  const BhwProfile({super.key});

  @override
  Widget build(BuildContext context) {
    final authBox = Hive.box("authBox");
    final user = authBox.get("user", defaultValue: {});

    if (user.isEmpty) {
      return const Scaffold(body: Center(child: Text("No user info found")));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Profile"),
        backgroundColor: const Color(0xFF43A047),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Avatar
          Center(
            child: CircleAvatar(
              radius: 50,
              backgroundColor: Colors.green[200],
              child: Text(
                user["first_name"]?.substring(0, 1) ?? "?",
                style: const TextStyle(fontSize: 40, color: Colors.white),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Full Name
          Center(
            child: Text(
              "${user["first_name"] ?? ""} ${user["middle_name"] ?? ""} ${user["last_name"] ?? ""} ${user["suffix"] ?? ""}",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 8),

          // Role
          Center(
            child: Text(
              (user["groups"] as List).join(", "),
              style: const TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ),
          const SizedBox(height: 20),

          // Info
          _buildInfoTile("Email", user["email"]),
          _buildInfoTile("Phone", user["phone_number"]),
          _buildInfoTile("Sex", user["sex"]),
          _buildInfoTile("Age", user["age"]?.toString()),
          _buildInfoTile("Location", user["location"]),
          _buildInfoTile("Account Created", user["created_at"]),
        ],
      ),
    );
  }

  Widget _buildInfoTile(String label, String? value) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        title: Text(label),
        subtitle: Text(value ?? "Not set"),
        leading: const Icon(Icons.person, color: Colors.green),
      ),
    );
  }
}
