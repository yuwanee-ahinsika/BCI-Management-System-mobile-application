import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Single Responsibility: Reusable empty state UI component (SRP / DRY).
class EmptyStateView extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget? action;
  final Color? iconColor;
  final Color? circleBackgroundColor;

  const EmptyStateView({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.action,
    this.iconColor,
    this.circleBackgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: circleBackgroundColor ?? AppTheme.surfaceLight,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: iconColor ?? AppTheme.textHint,
                size: 48,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppTheme.textHint,
                fontSize: 13.5,
              ),
            ),
            if (action != null) ...[
              const SizedBox(height: 20),
              action!,
            ],
          ],
        ),
      ),
    );
  }
}
