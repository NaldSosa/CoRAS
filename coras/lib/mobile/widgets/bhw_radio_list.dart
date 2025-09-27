import 'package:flutter/material.dart';

class RadioGroupField extends StatelessWidget {
  final String label;
  final List<String> options;
  final String? value;
  final Function(String?) onChanged;

  const RadioGroupField({
    super.key,
    required this.label,
    required this.options,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Column(
            children:
                options.map((opt) {
                  return RadioListTile<String>(
                    value: opt,
                    groupValue: value,
                    activeColor: const Color(0xFF2E7D32),
                    onChanged: onChanged,
                    title: Text(
                      opt,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    dense: true,
                    visualDensity: VisualDensity.compact,
                    contentPadding: EdgeInsets.zero,
                  );
                }).toList(),
          ),
        ],
      ),
    );
  }
}
