import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Reusable informational row tile with an icon badge, label, and value text.
class InfoRowTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? accentColor;
  final VoidCallback? onTap;

  const InfoRowTile({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.accentColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveColor = accentColor ?? AppTheme.accent;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: effectiveColor.withAlpha(12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: effectiveColor),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: AppTheme.textHint,
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  value,
                  style: const TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 14.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
