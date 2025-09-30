import 'package:flutter/material.dart';

class RadioGroupField extends StatelessWidget {
  final String label;
  final List<String> options;
  final String? value;
  final Function(String?) onChanged;
  final String? Function(String?)? validator;

  const RadioGroupField({
    super.key,
    required this.label,
    required this.options,
    required this.value,
    required this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      validator: validator,
      initialValue: value,
      builder: (fieldState) {
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
                        groupValue: fieldState.value,
                        activeColor: const Color(0xFF2E7D32),
                        onChanged: (val) {
                          onChanged(val);
                          fieldState.didChange(val);
                        },
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
              if (fieldState.hasError)
                Padding(
                  padding: const EdgeInsets.only(left: 12.0, top: 4),
                  child: Text(
                    fieldState.errorText!,
                    style: const TextStyle(
                      color: Color(0xFFAD2117),
                      fontSize: 12,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
