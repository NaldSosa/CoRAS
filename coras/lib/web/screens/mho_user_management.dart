import 'package:coras/web/config/app_config_web.dart';
import 'package:coras/web/screens/modal/user_form.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UserManagement extends StatefulWidget {
  const UserManagement({super.key});

  @override
  State<UserManagement> createState() => _UserManagementState();
}

class _UserManagementState extends State<UserManagement> {
  bool isLoading = false;
  List<Map<String, dynamic>> users = [];

  int totalUsers = 0;
  int activeUsers = 0;
  int inactiveUsers = 0;

  int currentPage = 1;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  /// 🔹 Fetch users from backend and compute stats
  Future<void> _loadUsers() async {
    setState(() => isLoading = true);
    try {
      final response = await AppConfigWeb.get('/api/users/');
      if (response.statusCode == 200) {
        final fetched = List<Map<String, dynamic>>.from(response.data);

        // compute stats
        final total = fetched.length;
        final active =
            fetched.where((u) => (u['status'] ?? true) == true).length;
        final inactive = total - active;

        setState(() {
          users = fetched;
          totalUsers = total;
          activeUsers = active;
          inactiveUsers = inactive;
        });
      }
    } catch (e) {
      debugPrint('Error loading users: $e');
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Failed to load users.')));
      }
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  /// 🔹 Open Add/Edit user form
  Future<void> _openUserForm({Map<String, dynamic>? user}) async {
    final result = await showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (_) => Dialog(
            insetPadding: const EdgeInsets.all(32),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: SizedBox(width: 700, child: UserForm(user: user)),
          ),
    );

    if (result == true) _loadUsers();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
          Expanded(
            child: TabBarView(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// 📊 Stat Cards — now dynamic
                      Row(
                        children: [
                          _buildStatCard(
                            "$totalUsers",
                            "Total Users",
                            Colors.blue,
                            Icons.people,
                          ),
                          _buildStatCard(
                            "$activeUsers",
                            "Active Users",
                            Colors.green,
                            Icons.person,
                          ),
                          _buildStatCard(
                            "$inactiveUsers",
                            "Inactive Users",
                            Colors.red,
                            Icons.person_off,
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      /// 🔍 Filters
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
                          _buildDropdown("Role", ["Admin", "BHW", "MHW"]),
                          const SizedBox(width: 12),
                          _buildDropdown("Barangays", [
                            "Poblacion 1",
                            "San Jose",
                          ]),
                          const SizedBox(width: 12),
                          _buildDropdown("Status", ["Active", "Inactive"]),
                        ],
                      ),

                      const SizedBox(height: 12),

                      /// ➕ Add User Button
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
                          onPressed: () => _openUserForm(),
                          icon: const Icon(Icons.add, size: 18),
                          label: const Text("Add User"),
                        ),
                      ),

                      const SizedBox(height: 16),

                      /// 📋 User Table
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            children: [
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
                                    _TableHeader("Email", flex: 2),
                                    _TableHeader("Role"),
                                    _TableHeader("Location"),
                                    _TableHeader("Status"),
                                    _TableHeader("Actions"),
                                  ],
                                ),
                              ),

                              /// Table Rows
                              Expanded(
                                child:
                                    isLoading
                                        ? const Center(
                                          child: CircularProgressIndicator(),
                                        )
                                        : users.isEmpty
                                        ? const Center(
                                          child: Text("No users found."),
                                        )
                                        : ListView.separated(
                                          itemCount: users.length,
                                          separatorBuilder:
                                              (_, __) => Divider(
                                                color: Colors.grey.shade300,
                                                height: 1,
                                              ),
                                          itemBuilder: (context, index) {
                                            final u = users[index];
                                            final fullName =
                                                '${u['first_name'] ?? ''} ${u['middle_name'] ?? ''} ${u['last_name'] ?? ''}'
                                                    .trim();
                                            final role = u['role'] ?? 'N/A';
                                            final email = u['email'] ?? '';
                                            final loc =
                                                u['barangay']?['barangay_name'] ??
                                                u['rhu']?['rhu_name'] ??
                                                '-';
                                            final active =
                                                (u['status'] ?? true) == true;

                                            return Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 12,
                                                    vertical: 10,
                                                  ),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    flex: 2,
                                                    child: Text(
                                                      fullName,
                                                      style: _rowStyle(),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 2,
                                                    child: Text(
                                                      email,
                                                      style: _rowStyle(),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                      role,
                                                      style: _rowStyle(),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                      loc,
                                                      style: _rowStyle(),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: _statusPill(
                                                      active
                                                          ? "Active"
                                                          : "Inactive",
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: IconButton(
                                                      onPressed:
                                                          () => _openUserForm(
                                                            user: u,
                                                          ),
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
                const Center(child: Text("Manage User Permissions")),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // === UI HELPERS ===

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
          contentPadding: const EdgeInsets.symmetric(horizontal: 10),
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
