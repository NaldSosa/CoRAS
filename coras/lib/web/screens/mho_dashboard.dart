import 'package:coras/web/widgets/mho_sidebar.dart';
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
  Widget activePage = const Center(child: Text("Dashboard Page"));

  @override
  Widget build(BuildContext context) {
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
          ),

          /// Main panel
          Expanded(
            child: Column(
              children: [
                _buildHeader(),
                Expanded(
                  child: Container(color: Colors.grey[100], child: activePage),
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
