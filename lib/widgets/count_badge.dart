import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Reusable badge pill displaying an item count with semantic background and foreground colors.
class CountBadge extends StatelessWidget {
  final int count;
  final String singularLabel;
  final String pluralLabel;
  final Color? activeColor;
  final Color? inactiveColor;
  final EdgeInsets padding;
  final double borderRadius;
  final double fontSize;

  const CountBadge({
    super.key,
    required this.count,
    required this.singularLabel,
    required this.pluralLabel,
    this.activeColor,
    this.inactiveColor,
    this.padding = const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
    this.borderRadius = 8,
    this.fontSize = 11,
  });

  @override
  Widget build(BuildContext context) {
    final hasItems = count > 0;
    final color = hasItems
        ? (activeColor ?? AppTheme.accent)
        : (inactiveColor ?? AppTheme.textHint);
    final bgColor = hasItems ? color.withAlpha(15) : AppTheme.surfaceLight;
    final label = count == 1 ? singularLabel : pluralLabel;

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Text(
        '$count $label',
        style: TextStyle(
          color: color,
          fontSize: fontSize,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
