import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Reusable form text field with a consistent label, styling, prefix icon, and validation.
class AppTextFormField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final IconData icon;
  final String hint;
  final TextInputType keyboardType;
  final int maxLines;
  final TextCapitalization? textCapitalization;
  final String? Function(String?)? validator;

  const AppTextFormField({
    super.key,
    required this.label,
    required this.controller,
    required this.icon,
    required this.hint,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
    this.textCapitalization,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final capitalization = textCapitalization ??
        (keyboardType == TextInputType.emailAddress ||
                keyboardType == TextInputType.phone ||
                keyboardType == TextInputType.number
            ? TextCapitalization.none
            : TextCapitalization.words);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppTheme.textSecondary,
            fontSize: 13,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.2,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          textCapitalization: capitalization,
          style: const TextStyle(
            color: AppTheme.textPrimary,
            fontSize: 14.5,
          ),
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Padding(
              padding: EdgeInsets.only(bottom: maxLines > 1 ? 40.0 : 0),
              child: Icon(icon, size: 20),
            ),
            alignLabelWithHint: maxLines > 1,
          ),
          validator: validator,
        ),
      ],
    );
  }
}
