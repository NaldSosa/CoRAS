import 'package:coras/web/screens/mho_threshold_.dart';
import 'package:coras/web/screens/mho_user_management.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MhoSidebar extends StatelessWidget {
  final bool isCollapsed;
  final Function() onToggle;
  final String activeMenu;
  final Function(Widget, String) onMenuSelected;
  final String userRole;

  const MhoSidebar({
    super.key,
    required this.isCollapsed,
    required this.onToggle,
    required this.activeMenu,
    required this.onMenuSelected,
    this.userRole = '',
  });

  Widget buildMenuItem({
    required IconData icon,
    required String title,
    required Widget page,
  }) {
    final isActive = activeMenu == title;
    return InkWell(
      onTap: () => onMenuSelected(page, title),
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
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: isCollapsed ? 70 : 250,
      color: const Color(0xFF2E7D32),
      child: Column(
        children: [
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
                  onPressed: onToggle,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          if (!isCollapsed) _buildSectionLabel("Main"),
          buildMenuItem(
            icon: Icons.dashboard,
            title: "Dashboard",
            page: const Center(child: Text("Dashboard Page")),
          ),
          buildMenuItem(
            icon: Icons.list_alt,
            title: "Assessment List",
            page: const Center(child: Text("Assessment List Page")),
          ),
          buildMenuItem(
            icon: Icons.insert_drive_file,
            title: "Reports",
            page: const Center(child: Text("Reports Page")),
          ),
          buildMenuItem(
            icon: Icons.health_and_safety,
            title: "Consultation",
            page: const Center(child: Text("Consultation Page")),
          ),
          buildMenuItem(
            icon: Icons.table_chart,
            title: "Threshold",
            page: const ThresholdScreen(),
          ),

          if (userRole.toLowerCase().trim() == 'admin') ...[
            const Divider(color: Colors.white54),
            if (!isCollapsed) _buildSectionLabel("Administration"),
            buildMenuItem(
              icon: Icons.people,
              title: "User Management",
              page: const UserManagement(),
            ),
            buildMenuItem(
              icon: Icons.settings,
              title: "System Configuration",
              page: const Center(child: Text("System Configuration Page")),
            ),
            buildMenuItem(
              icon: Icons.archive,
              title: "Archive Records",
              page: const Center(child: Text("Archive Records Page")),
            ),
            buildMenuItem(
              icon: Icons.history,
              title: "Audit Logs",
              page: const Center(child: Text("Audit Logs Page")),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSectionLabel(String label) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Text(
          label,
          style: GoogleFonts.poppins(
            color: Colors.white70,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}
