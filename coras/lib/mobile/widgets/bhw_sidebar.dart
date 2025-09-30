import 'package:coras/mobile/screens/bhw_encode_assessment.dart';
import 'package:coras/mobile/screens/bhw_profile.dart';
import 'package:coras/mobile/screens/bhw_login.dart';
import 'package:coras/mobile/screens/bhw_view_assessments.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          Container(
            color: const Color(0xFF388E3C),
            padding: const EdgeInsets.all(22),
            child: Row(
              children: [
                Image.asset("assets/images/mhologo.png", height: 40, width: 40),
                const SizedBox(width: 12),
                const Text(
                  "CoRAS",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Navigation",
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                ),
                _buildMenuItem(Icons.dashboard, "Dashboard", context),
                _buildMenuItem(Icons.person, "Profile", context),
                _buildMenuItem(Icons.edit, "Encode Assessment", context),
                _buildMenuItem(
                  Icons.assignment,
                  "View Encoded Assessments",
                  context,
                ),
                _buildMenuItem(Icons.drafts, "Drafts", context),
                _buildMenuItem(Icons.help_outline, "Help", context),
                const Divider(),
                _buildMenuItem(Icons.logout, "Logout", context, isLogout: true),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    IconData icon,
    String title,
    BuildContext context, {
    bool isLogout = false,
  }) {
    return ListTile(
      leading: Icon(icon, color: isLogout ? Colors.red : Colors.black),
      title: Text(
        title,
        style: TextStyle(
          color: isLogout ? Colors.red : Colors.black,
          fontWeight: isLogout ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      onTap: () async {
        Navigator.pop(context);

        if (title == "Profile") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const BhwProfile()),
          );
        } else if (title == "Encode Assessment") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AssessmentScreen()),
          );
        } else if (title == "View Encoded Assessments") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const PatientListScreen()),
          );
        } else if (isLogout) {
          final authBox = Hive.box("authBox");
          authBox.delete("accessToken");
          authBox.delete("refreshToken");

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Logged out successfully")),
          );

          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const BhwLogin()),
            (route) => false,
          );
        }
      },
    );
  }
}
