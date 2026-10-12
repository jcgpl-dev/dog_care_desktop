import 'package:dog_care_desktop/config/theme/app_colors.dart';
import 'package:dog_care_desktop/config/theme/app_dimensions.dart';
import 'package:dog_care_desktop/config/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../domain/entities/dog.dart';
import '../../utils/dog_formatters.dart';

/// Icon + text, so meaning never depends on color alone.
class DogSexBadge extends StatelessWidget {
  const DogSexBadge({super.key, required this.sex});

  final DogSex sex;

  @override
  Widget build(BuildContext context) {
    final isMale = sex == DogSex.male;
    final color = isMale ? AppColors.info : Colors.pink;

    return Expanded(
      child: Container(
        width: 100,
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.spacing16,
          vertical: AppDimensions.spacing4,
        ),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isMale
                  ? PhosphorIcons.genderMale(PhosphorIconsStyle.bold)
                  : PhosphorIcons.genderFemale(PhosphorIconsStyle.bold),
              size: 12,
              color: color,
            ),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                DogFormatters.sexLabel(sex),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.labelSmall.copyWith(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
