import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Single Responsibility: Reusable section header title with visual accent bar (SRP / DRY).
class SectionHeader extends StatelessWidget {
  final String title;
  final Gradient? gradient;
  final Gradient? accentGradient;
  final double fontSize;
  final Widget? trailing;

  const SectionHeader({
    super.key,
    required this.title,
    this.gradient,
    this.accentGradient,
    this.fontSize = 18,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveGradient = accentGradient ?? gradient ?? AppTheme.accentGradient;

    return Row(
      children: [
        Container(
          width: 4,
          height: 20,
          decoration: BoxDecoration(
            gradient: effectiveGradient,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: TextStyle(
            color: AppTheme.textPrimary,
            fontSize: fontSize,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.3,
          ),
        ),
        if (trailing != null) ...[
          const Spacer(),
          trailing!,
        ],
      ],
    );
  }
}
