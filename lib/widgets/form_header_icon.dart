import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Reusable icon header with subtitle for add/edit form screens.
class FormHeaderIcon extends StatelessWidget {
  final IconData icon;
  final String subtitle;
  final Gradient? gradient;
  final Color? shadowColor;

  const FormHeaderIcon({
    super.key,
    required this.icon,
    required this.subtitle,
    this.gradient,
    this.shadowColor,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveGradient = gradient ?? AppTheme.accentGradient;
    final effectiveShadowColor = shadowColor ??
        (effectiveGradient is LinearGradient
            ? effectiveGradient.colors.first.withAlpha(50)
            : AppTheme.accent.withAlpha(50));

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            gradient: effectiveGradient,
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: effectiveShadowColor,
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Icon(icon, color: Colors.white, size: 30),
        ),
        const SizedBox(height: 10),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: AppTheme.textSecondary,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 32),
      ],
    );
  }
}
