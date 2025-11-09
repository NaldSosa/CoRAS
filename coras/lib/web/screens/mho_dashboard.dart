import 'package:coras/web/widgets/mho_sidebar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';

class MhoDashboard extends StatefulWidget {
  const MhoDashboard({super.key});

  @override
  State<MhoDashboard> createState() => _MhoDashboardState();
}

class _MhoDashboardState extends State<MhoDashboard> {
  bool isCollapsed = false;
  String activeMenu = "Dashboard";
  Widget activePage = const Center(child: Text("Dashboard Page"));

  @override
  Widget build(BuildContext context) {
    final authBox = Hive.box('authBox');
    final user = authBox.get('user') ?? {};

    // get role from possible places (groups list, role field, or nested)
    String currentUserRole = '';

    // 1) groups (common in your print)
    if (user is Map && user['groups'] != null) {
      final g = user['groups'];
      if (g is List && g.isNotEmpty) {
        currentUserRole = g[0].toString();
      } else if (g is String && g.isNotEmpty) {
        currentUserRole = g;
      }
    }

    // 2) fallback to role or user_type if present
    currentUserRole =
        currentUserRole.isNotEmpty
            ? currentUserRole
            : (user is Map ? (user['role'] ?? user['user_type'] ?? '') : '');

    // normalize
    currentUserRole = currentUserRole.trim();

    if (kDebugMode) {
      print('DEBUG: final extracted role = "$currentUserRole"');
    }

    return Scaffold(
      body: Row(
        children: [
          MhoSidebar(
            isCollapsed: isCollapsed,
            activeMenu: activeMenu,
            onToggle: () {
              setState(() => isCollapsed = !isCollapsed);
            },
            onMenuSelected: (page, menu) {
              setState(() {
                activePage = page;
                activeMenu = menu;
              });
            },
            userRole: currentUserRole,
          ),

          /// Main panel
          Expanded(
            child: Column(
              children: [
                _buildHeader(),
                Expanded(
                  child: Container(
                    color: const Color.fromARGB(255, 245, 245, 245),
                    child: activePage,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 60,
      color: Colors.white,
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        activeMenu,
        style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }
}
