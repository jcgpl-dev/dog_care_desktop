import 'package:dog_care_desktop/config/theme/app_colors.dart';
import 'package:flutter/material.dart';

Future<bool> showConfirmDeleteDialog(
  BuildContext context, {
  required int count,
  String? itemName,
  String itemTypeLabel = 'record',
}) async {
  final isSingle = count == 1;
  final subject = isSingle
      ? (itemName ?? 'this $itemTypeLabel')
      : 'these $count $itemTypeLabel${itemTypeLabel.endsWith('s') ? '' : 's'}';

  final confirmed = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text(
        isSingle ? 'Delete $itemTypeLabel?' : 'Delete $count records?',
      ),
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
