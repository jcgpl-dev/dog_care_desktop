import 'package:dog_care_desktop/config/theme/app_colors.dart';
import 'package:flutter/material.dart';

/// Returns true only when the user explicitly confirms.
Future<bool> showConfirmDeleteDialog(
  BuildContext context, {
  required int count,
  String? singleLabel,
}) async {
  final isSingle = count == 1;
  final subject = isSingle
      ? (singleLabel ?? 'this record')
      : 'these $count records';

  final confirmed = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text(isSingle ? 'Delete dog record?' : 'Delete $count records?'),
      content: Text(
        'This will permanently remove $subject. This action cannot be undone.',
      ),
      actions: [
        TextButton(
          autofocus: true,
          onPressed: () => Navigator.of(dialogContext).pop(false),
          child: const Text('Cancel'),
        ),
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.error,
            foregroundColor: Colors.white,
          ),
          onPressed: () => Navigator.of(dialogContext).pop(true),
          child: const Text('Delete'),
        ),
      ],
    ),
  );
  return confirmed ?? false;
}
