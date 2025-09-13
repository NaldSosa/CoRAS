import 'package:flutter/material.dart';

class YesNoField extends StatelessWidget {
  final String label;
  final bool readOnly;
  final bool required;
  final bool? value;
  final Function(bool?) onChanged;

  const YesNoField({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.readOnly = false,
    this.required = false,
  });

  @override
  Widget build(BuildContext context) {
    return FormField<bool>(
      validator: (_) {
        if (required && value == null) {
          return 'This field is required';
        }
        return null;
      },
      builder: (field) {
        final hasError = field.hasError;

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: hasError ? Colors.red : Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Expanded(
                    child: RadioListTile<bool>(
                      value: true,
                      groupValue: value,
                      activeColor:
                          hasError ? Colors.red : const Color(0xFF2E7D32),
                      onChanged:
                          readOnly
                              ? null
                              : (val) {
                                onChanged(val);
                                field.didChange(val);
                              },
                      title: Text(
                        "Yes",
                        style: TextStyle(
                          color: hasError ? Colors.red : Colors.black87,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      dense: true,
                      visualDensity: VisualDensity.compact,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<bool>(
                      value: false,
                      groupValue: value,
                      activeColor:
                          hasError ? Colors.red : const Color(0xFF2E7D32),
                      onChanged:
                          readOnly
                              ? null
                              : (val) {
                                onChanged(val);
                                field.didChange(val);
                              },
                      title: Text(
                        "No",
                        style: TextStyle(
                          color: hasError ? Colors.red : Colors.black87,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      dense: true,
                      visualDensity: VisualDensity.compact,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ],
              ),
              if (hasError)
                Padding(
                  padding: const EdgeInsets.only(left: 12.0, top: 4),
                  child: Text(
                    field.errorText!,
                    style: const TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
