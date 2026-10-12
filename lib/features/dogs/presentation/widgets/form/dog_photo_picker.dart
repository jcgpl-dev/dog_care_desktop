import 'dart:io';

import 'package:dog_care_desktop/config/theme/app_colors.dart';
import 'package:dog_care_desktop/config/theme/app_dimensions.dart';
import 'package:dog_care_desktop/config/theme/app_text_styles.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class DogPhotoPicker extends StatelessWidget {
  const DogPhotoPicker({
    super.key,
    required this.photoPath,
    required this.onChanged,
  });

  final String? photoPath;
  final ValueChanged<String?> onChanged;

  static const _maxBytes = 5 * 1024 * 1024;

  Future<void> _pick(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    final result = await FilePicker.pickFiles(type: FileType.image);
    final file = result?.files.single;
    if (file == null || file.path == null) return;

    if (file.size > _maxBytes) {
      messenger.showSnackBar(
        const SnackBar(content: Text('Photo must be 5 MB or smaller')),
      );
      return;
    }
    onChanged(file.path);
  }

  @override
  Widget build(BuildContext context) {
    final hasPhoto = photoPath != null;

    return Row(
      children: [
        CircleAvatar(
          radius: 36,
          backgroundColor: AppColors.primaryContainer,
          foregroundImage: hasPhoto
              ? ResizeImage(FileImage(File(photoPath!)), width: 144)
              : null,
          onForegroundImageError: hasPhoto ? (_, __) {} : null,
          child: Icon(
            PhosphorIcons.camera(PhosphorIconsStyle.bold),
            color: AppColors.primary,
          ),
        ),
        const SizedBox(width: AppDimensions.spacing16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: AppDimensions.spacing8,
                children: [
                  OutlinedButton(
                    onPressed: () => _pick(context),
                    child: Text(hasPhoto ? 'Change photo' : 'Upload photo'),
                  ),
                  if (hasPhoto)
                    TextButton(
                      onPressed: () => onChanged(null),
                      child: Text(
                        'Remove',
                        style: TextStyle(color: AppColors.error),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                'Optional · JPG or PNG, up to 5 MB',
                style: AppTextStyles.labelSmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
