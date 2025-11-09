import 'dart:math';
import 'package:coras/web/config/app_config_web.dart';
import 'package:flutter/material.dart';

class UserForm extends StatefulWidget {
  final Map<String, dynamic>? user;
  const UserForm({super.key, this.user});

  @override
  State<UserForm> createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController middleNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController suffixController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String? selectedSex;
  String? selectedRole;
  String? selectedLocation;
  List<Map<String, dynamic>> locations = [];

  bool isEditMode = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.user != null) {
      isEditMode = true;
      _loadUserData();
    }
  }

  void _loadUserData() {
    final u = widget.user!;
    firstNameController.text = u['first_name'] ?? '';
    middleNameController.text = u['middle_name'] ?? '';
    lastNameController.text = u['last_name'] ?? '';
    suffixController.text = u['suffix'] ?? '';
    emailController.text = u['email'] ?? '';
    phoneController.text = u['phone_number'] ?? '';
    ageController.text = u['age']?.toString() ?? '';
    selectedSex = u['sex'];
    selectedRole = u['role'];

    if (selectedRole == 'Barangay Health Worker') {
      selectedLocation = u['barangay']?['id']?.toString();
    } else if (selectedRole == 'Municipal Health Worker') {
      selectedLocation = u['rhu']?['id']?.toString();
    }

    if (selectedRole != null) _fetchLocations(selectedRole!);
  }

  Future<void> _fetchLocations(String role) async {
    setState(() {
      locations = [];
      selectedLocation = null;
    });
    if (role == 'Admin') return;

    try {
      final res = await AppConfigWeb.get(
        '/api/users/location-options/',
        queryParameters: {'role': role},
      );
      if (res.statusCode == 200) {
        setState(() {
          locations = List<Map<String, dynamic>>.from(res.data);
        });
      }
    } catch (e) {
      debugPrint('Fetch location error: $e');
    }
  }

  String generatePassword() {
    const chars =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789@#%!';
    return List.generate(
      10,
      (i) => chars[Random().nextInt(chars.length)],
    ).join();
  }

  Future<void> _saveUser() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => isLoading = true);

    final data = {
      'first_name': firstNameController.text,
      'middle_name': middleNameController.text,
      'last_name': lastNameController.text,
      'suffix': suffixController.text,
      "username": usernameController.text,
      'age': int.tryParse(ageController.text.trim()) ?? 0,
      'sex': selectedSex,
      'email': emailController.text,
      'phone_number': phoneController.text,
      'groups': [selectedRole],
      'password': passwordController.text,
    };

    if (selectedRole == "Barangay Health Worker") {
      data["barangay_id"] = selectedLocation;
    } else if (selectedRole == "Municipal Health Worker") {
      data["rhu_id"] = selectedLocation;
    }

    try {
      if (isEditMode) {
        await AppConfigWeb.put('/api/users/${widget.user!['id']}/', data: data);
      } else {
        await AppConfigWeb.post('/api/users/', data: data);
      }

      if (mounted) {
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(isEditMode ? 'User updated!' : 'User added!')),
        );
      }
    } catch (e) {
      debugPrint('Save user error: $e');
      debugPrint("Request body: $data");

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Error saving user.')));
      }
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  Widget buildField(Widget child) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff4eff7),
      appBar: AppBar(
        title: Text(
          isEditMode ? 'Edit User' : 'Add User',
          style: const TextStyle(color: Colors.green),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.black87),
            onPressed: () => Navigator.pop(context, false),
          ),
        ],
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Wrap(
                    runSpacing: 8,
                    children: [
                      Row(
                        children: [
                          buildField(
                            TextFormField(
                              controller: firstNameController,
                              decoration: const InputDecoration(
                                labelText: 'First Name',
                              ),
                              validator: (v) => v!.isEmpty ? 'Required' : null,
                            ),
                          ),
                          buildField(
                            TextFormField(
                              controller: middleNameController,
                              decoration: const InputDecoration(
                                labelText: 'Middle Name',
                              ),
                            ),
                          ),
                          buildField(
                            TextFormField(
                              controller: lastNameController,
                              decoration: const InputDecoration(
                                labelText: 'Last Name',
                              ),
                              validator: (v) => v!.isEmpty ? 'Required' : null,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          buildField(
                            TextFormField(
                              controller: suffixController,
                              decoration: const InputDecoration(
                                labelText: 'Suffix',
                              ),
                            ),
                          ),
                          buildField(
                            TextFormField(
                              controller: usernameController,
                              decoration: const InputDecoration(
                                labelText: 'Username',
                              ),
                              validator: (v) => v!.isEmpty ? 'Required' : null,
                            ),
                          ),
                          buildField(
                            TextFormField(
                              controller: ageController,
                              decoration: const InputDecoration(
                                labelText: 'Age',
                              ),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          buildField(
                            DropdownButtonFormField<String>(
                              value: selectedSex,
                              decoration: const InputDecoration(
                                labelText: 'Sex',
                              ),
                              items: const [
                                DropdownMenuItem(
                                  value: 'Male',
                                  child: Text('Male'),
                                ),
                                DropdownMenuItem(
                                  value: 'Female',
                                  child: Text('Female'),
                                ),
                              ],
                              onChanged: (v) => setState(() => selectedSex = v),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          buildField(
                            TextFormField(
                              controller: phoneController,
                              decoration: const InputDecoration(
                                labelText: 'Contact Number',
                              ),
                            ),
                          ),
                          buildField(
                            TextFormField(
                              controller: emailController,
                              decoration: const InputDecoration(
                                labelText: 'Email',
                              ),
                            ),
                          ),
                          buildField(
                            DropdownButtonFormField<String>(
                              value: selectedRole,
                              decoration: const InputDecoration(
                                labelText: 'Role',
                              ),
                              items: const [
                                DropdownMenuItem(
                                  value: 'Admin',
                                  child: Text('Admin'),
                                ),
                                DropdownMenuItem(
                                  value: 'Municipal Health Worker',
                                  child: Text('Municipal Health Worker'),
                                ),
                                DropdownMenuItem(
                                  value: 'Barangay Health Worker',
                                  child: Text('Barangay Health Worker'),
                                ),
                              ],
                              onChanged: (v) {
                                setState(() => selectedRole = v);
                                if (v != null) _fetchLocations(v);
                              },
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          if (selectedRole != null && selectedRole != 'Admin')
                            buildField(
                              DropdownButtonFormField<String>(
                                value: selectedLocation,
                                decoration: const InputDecoration(
                                  labelText: 'Location',
                                ),
                                items:
                                    locations
                                        .map(
                                          (loc) => DropdownMenuItem(
                                            value: loc['id'].toString(),
                                            child: Text(
                                              loc['barangay_name'] ??
                                                  loc['rhu_name'] ??
                                                  '',
                                            ),
                                          ),
                                        )
                                        .toList(),
                                onChanged:
                                    (v) => setState(() => selectedLocation = v),
                              ),
                            )
                          else
                            buildField(
                              TextFormField(
                                enabled: false,
                                decoration: const InputDecoration(
                                  labelText: 'Location',
                                ),
                              ),
                            ),
                          buildField(
                            TextFormField(
                              controller: passwordController,
                              obscureText: true,
                              decoration: const InputDecoration(
                                labelText: 'Password',
                              ),
                              validator:
                                  (v) =>
                                      v!.isEmpty
                                          ? 'Enter or generate password'
                                          : null,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 4),
                            child: ElevatedButton(
                              onPressed: () {
                                final pwd = generatePassword();
                                passwordController.text = pwd;
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                              ),
                              child: const Text('Generate'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton(
                          onPressed: _saveUser,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                          ),
                          child: const Text('Save'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
    );
  }
}
