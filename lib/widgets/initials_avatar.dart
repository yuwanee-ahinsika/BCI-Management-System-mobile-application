import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Reusable avatar displaying initial letter or icon within a styled gradient container.
class InitialsAvatar extends StatelessWidget {
  final String? text;
  final IconData? icon;
  final double size;
  final Gradient? gradient;
  final Color? backgroundColor;
  final double borderRadius;
  final double? fontSize;
  final double? iconSize;
  final BoxBorder? border;

  const InitialsAvatar({
    super.key,
    this.text,
    this.icon,
    this.size = 50,
    this.gradient,
    this.backgroundColor,
    this.borderRadius = 14,
    this.fontSize,
    this.iconSize,
    this.border,
  }) : assert(text != null || icon != null, 'Either text or icon must be provided.');

  @override
  Widget build(BuildContext context) {
    final effectiveGradient = backgroundColor == null
        ? (gradient ?? AppTheme.accentGradient)
        : null;

    final initial = (text != null && text!.trim().isNotEmpty)
        ? text!.trim()[0].toUpperCase()
        : '?';

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor,
        gradient: effectiveGradient,
        borderRadius: BorderRadius.circular(borderRadius),
        border: border,
      ),
      child: Center(
        child: icon != null
            ? Icon(
                icon,
                color: Colors.white,
                size: iconSize ?? (size * 0.44),
              )
            : Text(
                initial,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: fontSize ?? (size * 0.4),
                ),
              ),
      ),
    );
  }
}
