import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MhoDashboard extends StatefulWidget {
  const MhoDashboard({super.key});

  @override
  State<MhoDashboard> createState() => _MhoDashboardState();
}

class _MhoDashboardState extends State<MhoDashboard> {
  bool isCollapsed = false;
  String activeMenu = "Dashboard";

  Widget buildMenuItem({required IconData icon, required String title}) {
    final isActive = activeMenu == title;
    return InkWell(
      onTap: () {
        setState(() => activeMenu = title);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? Colors.green[700] : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 20),
            if (!isCollapsed) ...[
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Sidebar
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: isCollapsed ? 70 : 250,
            color: const Color(0xFF2E7D32),
            child: Column(
              children: [
                // Logo + toggle
                Container(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Image.asset("assets/images/mhologo.png", height: 40),
                      if (!isCollapsed) ...[
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Municipal Health Office",
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                "CoRAS",
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      IconButton(
                        icon: Icon(
                          isCollapsed ? Icons.arrow_right : Icons.arrow_left,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          setState(() {
                            isCollapsed = !isCollapsed;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Menu Items
                if (!isCollapsed)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        "Main",
                        style: GoogleFonts.poppins(
                          color: Colors.white70,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: 10),
                buildMenuItem(icon: Icons.dashboard, title: "Dashboard"),
                buildMenuItem(icon: Icons.list_alt, title: "Assessment List"),
                buildMenuItem(icon: Icons.insert_drive_file, title: "Reports"),
                buildMenuItem(
                  icon: Icons.health_and_safety,
                  title: "Consultation",
                ),
                buildMenuItem(icon: Icons.table_chart, title: "Threshold"),
                const SizedBox(height: 20),
                if (!isCollapsed)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        "Administration",
                        style: GoogleFonts.poppins(
                          color: Colors.white70,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: 10),
                buildMenuItem(icon: Icons.people, title: "User Management"),
                buildMenuItem(
                  icon: Icons.settings,
                  title: "System Configuration",
                ),
                buildMenuItem(icon: Icons.archive, title: "Archive Records"),
                buildMenuItem(icon: Icons.history, title: "Audit Logs"),
              ],
            ),
          ),

          // Main content area
          Expanded(
            child: Column(
              children: [
                Container(
                  height: 60,
                  color: Colors.white,
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    "MHO Dashboard",
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    color: Colors.grey[100],
                    child: Center(
                      child: Text(
                        "This is the MHO dashboard content area",
                        style: GoogleFonts.poppins(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
