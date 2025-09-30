import 'dart:math';

import 'package:flutter/material.dart';

class UserFormModal extends StatelessWidget {
  final String title;
  final String actionLabel;
  final Map<String, String>? userData;

  const UserFormModal({
    super.key,
    required this.title,
    required this.actionLabel,
    this.userData,
  });

  static Future<void> show(
    BuildContext context, {
    required String title,
    required String actionLabel,
    Map<String, String>? userData,
  }) {
    return showDialog(
      context: context,
      builder:
          (_) => UserFormModal(
            title: title,
            actionLabel: actionLabel,
            userData: userData,
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final data = userData ?? {};

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        width: 720,
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color:
                        title.contains("Edit")
                            ? Colors.blue[800]
                            : Colors.green[800],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 16),

            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                _buildTextField("First Name", data["firstName"] ?? ""),
                _buildTextField("Middle Name", data["middleName"] ?? ""),
                _buildTextField("Last Name", data["lastName"] ?? ""),
                _buildDropdown("Suffix", [
                  "None",
                  "Jr.",
                  "Sr.",
                  "III",
                ], data["suffix"] ?? "None"),
                _buildTextField("Age", data["age"] ?? ""),
                _buildDropdown("Sex", [
                  "Male",
                  "Female",
                ], data["sex"] ?? "Male"),
                _buildTextField("Contact Number", data["contact"] ?? ""),
                _buildTextField("Email", data["email"] ?? ""),
                _buildDropdown("Role", [
                  "Admin",
                  "BHW",
                  "MHO",
                ], data["role"] ?? "BHW"),
                _buildTextField("Location", data["location"] ?? ""),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 180,
                      child: _buildTextField(
                        "Password",
                        data["password"] ?? "",
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      onPressed: () {
                        // TODO: Generate password logic
                      },
                      child: const Text("Generate"),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 24),

            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      title.contains("Edit") ? Colors.blue : Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 28,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(actionLabel),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _buildTextField(String label, String initialValue) {
    return SizedBox(
      width: 180,
      child: TextField(
        controller: TextEditingController(text: initialValue),
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
          isDense: true,
        ),
      ),
    );
  }

  static Widget _buildDropdown(
    String label,
    List<String> items,
    String selected,
  ) {
    return SizedBox(
      width: 180,
      child: DropdownButtonFormField<String>(
        value: selected,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
          isDense: true,
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

String generatePassword({int length = 8}) {
  const String chars =
      "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789@_";
  Random random = Random.secure();
  return List.generate(
    length,
    (index) => chars[random.nextInt(chars.length)],
  ).join();
}
