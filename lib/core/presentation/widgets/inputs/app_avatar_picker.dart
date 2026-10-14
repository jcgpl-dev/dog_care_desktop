import 'dart:io';

import 'package:dog_care_desktop/config/theme/app_colors.dart';
import 'package:dog_care_desktop/config/theme/app_dimensions.dart';
import 'package:dog_care_desktop/config/theme/app_text_styles.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class AppAvatarPicker extends StatelessWidget {
  const AppAvatarPicker({
    super.key,
    required this.imagePath,
    required this.onChanged,
    this.maxBytes = 5 * 1024 * 1024, // Default 5 MB
    this.fallbackIcon,
    this.helperText = 'Optional · JPG or PNG, up to 5 MB',
  });

  final String? imagePath;
  final ValueChanged<String?> onChanged;
  final int maxBytes;
  final IconData? fallbackIcon;
  final String helperText;

  Future<void> _pick(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    final result = await FilePicker.pickFiles(type: FileType.image);
    final file = result?.files.single;
    if (file == null || file.path == null) return;

    if (file.size > maxBytes) {
      final sizeMb = (maxBytes / (1024 * 1024)).toStringAsFixed(0);
      messenger.showSnackBar(
        SnackBar(content: Text('Image must be $sizeMb MB or smaller')),
      );
      return;
    }
    onChanged(file.path);
  }

  @override
  Widget build(BuildContext context) {
    final hasImage = imagePath != null;

    return Row(
      children: [
        CircleAvatar(
          radius: 36,
          backgroundColor: AppColors.primaryContainer,
          foregroundImage: hasImage
              ? ResizeImage(FileImage(File(imagePath!)), width: 144)
              : null,
          onForegroundImageError: hasImage ? (_, _) {} : null,
          child: Icon(
            fallbackIcon ?? PhosphorIcons.camera(PhosphorIconsStyle.bold),
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
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          AppDimensions.radiusSmall,
                        ),
                      ),
                    ),
                    onPressed: () => _pick(context),
                    child: Text(hasImage ? 'Change photo' : 'Upload photo'),
                  ),
                  if (hasImage)
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
                helperText,
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
