import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Shows a standardized delete confirmation dialog.
Future<bool?> showDeleteConfirmDialog({
  required BuildContext context,
  required String title,
  required String message,
  String confirmText = 'Delete',
  String cancelText = 'Cancel',
  VoidCallback? onConfirm,
}) {
  return showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: Text(
            cancelText,
            style: const TextStyle(color: AppTheme.textSecondary),
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(ctx, true);
            onConfirm?.call();
          },
          child: Text(
            confirmText,
            style: const TextStyle(color: AppTheme.error),
          ),
        ),
      ],
    ),
  );
}
