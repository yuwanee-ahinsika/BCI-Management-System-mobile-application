import 'package:flutter/material.dart';

/// Reusable icon button for list items and card action bars.
class ActionIconButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final double size;
  final EdgeInsets padding;
  final double borderRadius;
  final String? tooltip;

  const ActionIconButton({
    super.key,
    required this.icon,
    required this.color,
    required this.onTap,
    this.size = 19,
    this.padding = const EdgeInsets.all(6),
    this.borderRadius = 8,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    Widget button = Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(borderRadius),
        child: Padding(
          padding: padding,
          child: Icon(icon, size: size, color: color),
        ),
      ),
    );

    if (tooltip != null) {
      return Tooltip(message: tooltip!, child: button);
    }
    return button;
  }
}
