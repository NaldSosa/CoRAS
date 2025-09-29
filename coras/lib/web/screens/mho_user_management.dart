import 'package:coras/web/screens/modal/user_form.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UserManagement extends StatefulWidget {
  const UserManagement({super.key});

  @override
  State<UserManagement> createState() => _UserManagementState();
}

class _UserManagementState extends State<UserManagement> {
  final List<Map<String, String>> _users = [
    {
      "name": "Juan Dela Cruz",
      "email": "juan.delacruz@health.gov.ph",
      "role": "BHW",
      "location": "San Jose",
      "status": "Active",
    },
    {
      "name": "Anna Reyes",
      "email": "anna.reyes@health.gov.ph",
      "role": "MHO",
      "location": "Poblacion 1",
      "status": "Inactive",
    },
  ];

  int currentPage = 1;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tabs
          const SizedBox(height: 8),
          TabBar(
            isScrollable: true,
            labelColor: Colors.blue,
            unselectedLabelColor: Colors.black54,
            indicatorColor: Colors.blue,
            indicatorWeight: 2,
            labelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600),
            unselectedLabelStyle: GoogleFonts.poppins(
              fontWeight: FontWeight.w400,
            ),
            tabs: const [Tab(text: "Users"), Tab(text: "User Permissions")],
          ),

          const SizedBox(height: 12),

          // Tab content
          Expanded(
            child: TabBarView(
              children: [
                // ---------------- USERS TAB ----------------
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 📊 Stat Cards
                      Row(
                        children: [
                          _buildStatCard(
                            "27",
                            "Total Users",
                            Colors.blue,
                            Icons.people,
                          ),
                          _buildStatCard(
                            "23",
                            "Active Users",
                            Colors.green,
                            Icons.person,
                          ),
                          _buildStatCard(
                            "4",
                            "Inactive Users",
                            Colors.red,
                            Icons.person_off,
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // 🔍 Search + Filters Row
                      Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 40,
                              child: TextField(
                                decoration: InputDecoration(
                                  hintText:
                                      "Search by name, email, role, or location...",
                                  hintStyle: GoogleFonts.poppins(fontSize: 13),
                                  prefixIcon: const Icon(
                                    Icons.search,
                                    size: 18,
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 0,
                                    horizontal: 12,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          _buildDropdown("Sort by", ["Name", "Role"]),
                          const SizedBox(width: 12),
                          _buildDropdown("Role", ["Admin", "BHW", "MHO"]),
                          const SizedBox(width: 12),
                          _buildDropdown("Barangays", [
                            "Poblacion 1",
                            "Poblacion 5",
                            "San Jose",
                          ]),
                          const SizedBox(width: 12),
                          _buildDropdown("Status", ["Active", "Inactive"]),
                        ],
                      ),

                      const SizedBox(height: 12),

                      // ➕ Add User button (Right aligned)
                      Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                            textStyle: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          onPressed: () {
                            UserFormModal.show(
                              context,
                              title: "Add User",
                              actionLabel: "Save",
                            );
                          },
                          icon: const Icon(Icons.add, size: 18),
                          label: const Text("Add User"),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // 🔼 Pagination (above table)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            onPressed:
                                currentPage > 1
                                    ? () {
                                      setState(() {
                                        currentPage--;
                                      });
                                    }
                                    : null,
                            child: const Text("Prev"),
                          ),
                          for (int i = 1; i <= 5; i++)
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4,
                              ),
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  backgroundColor:
                                      i == currentPage
                                          ? Colors.green.shade100
                                          : null,
                                ),
                                onPressed: () {
                                  setState(() {
                                    currentPage = i;
                                  });
                                },
                                child: Text(
                                  "$i",
                                  style: GoogleFonts.poppins(fontSize: 13),
                                ),
                              ),
                            ),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                currentPage++;
                              });
                            },
                            child: const Text("Next"),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      // 📋 Table
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            children: [
                              // Table Header
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(8),
                                  ),
                                ),
                                child: Row(
                                  children: const [
                                    _TableHeader("User", flex: 2),
                                    _TableHeader("Email", flex: 3),
                                    _TableHeader("Role"),
                                    _TableHeader("Location"),
                                    _TableHeader("Status"),
                                    _TableHeader("Actions"),
                                  ],
                                ),
                              ),

                              // Table Rows
                              Expanded(
                                child: ListView.separated(
                                  itemCount: _users.length,
                                  separatorBuilder:
                                      (_, __) => Divider(
                                        color: Colors.grey.shade300,
                                        height: 1,
                                      ),
                                  itemBuilder: (context, index) {
                                    final user = _users[index];
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 10,
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            flex: 2,
                                            child: Text(
                                              user["name"]!,
                                              style: _rowStyle(),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 3,
                                            child: Text(
                                              user["email"]!,
                                              style: _rowStyle(),
                                            ),
                                          ),
                                          Expanded(
                                            child: Text(
                                              user["role"]!,
                                              style: _rowStyle(),
                                            ),
                                          ),
                                          Expanded(
                                            child: Text(
                                              user["location"]!,
                                              style: _rowStyle(),
                                            ),
                                          ),
                                          Expanded(
                                            child: _statusPill(user["status"]!),
                                          ),
                                          Expanded(
                                            child: IconButton(
                                              onPressed: () {
                                                UserFormModal.show(
                                                  context,
                                                  title: "Edit User",
                                                  actionLabel: "Update",
                                                );
                                              },
                                              icon: const Icon(
                                                Icons.edit,
                                                size: 18,
                                                color: Colors.black54,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // ---------------- PERMISSIONS TAB ----------------
                const Center(child: Text("Manage User Permissions")),
              ],
            ),
          ),
        ],
      ),
    );
  }

  TextStyle _rowStyle() =>
      GoogleFonts.poppins(fontSize: 13, color: Colors.black87);

  Widget _statusPill(String status) {
    final isActive = status == "Active";
    return Align(
      alignment: Alignment.center,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: isActive ? Colors.green.shade100 : Colors.grey.shade300,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          status,
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isActive ? Colors.green.shade800 : Colors.grey.shade700,
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(
    String value,
    String title,
    Color color,
    IconData icon,
  ) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: Container(
        width: 200,
        height: 80,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.shade300),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200,
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(width: 12),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown(String hint, List<String> items) {
    return SizedBox(
      width: 140,
      height: 40,
      child: DropdownButtonFormField<String>(
        hint: Text(hint, style: GoogleFonts.poppins(fontSize: 13)),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 0,
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
        ),
        items:
            items
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
        onChanged: (_) {},
      ),
    );
  }
}

// Table Header Widget (center aligned)
class _TableHeader extends StatelessWidget {
  final String label;
  final int flex;
  const _TableHeader(this.label, {this.flex = 1});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Center(
        child: Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }
}
