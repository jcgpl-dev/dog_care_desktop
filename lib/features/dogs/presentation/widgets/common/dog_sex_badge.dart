import 'package:dog_care_desktop/config/theme/app_dimensions.dart';
import 'package:dog_care_desktop/config/theme/app_pallette.dart';
import 'package:dog_care_desktop/config/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../domain/entities/dog.dart';
import '../../utils/dog_formatters.dart';

class DogSexBadge extends StatelessWidget {
  const DogSexBadge({super.key, required this.sex});

  final DogSex sex;

  static const double _minWidth = 76;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final isMale = sex == DogSex.male;
    final color = isMale ? c.accentBlue : c.accentPink;

    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: _minWidth),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.spacing12,
            vertical: AppDimensions.spacing4,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isMale
                    ? PhosphorIcons.genderMale(PhosphorIconsStyle.bold)
                    : PhosphorIcons.genderFemale(PhosphorIconsStyle.bold),
                size: 14,
                color: color,
              ),
              const SizedBox(width: AppDimensions.spacing4),
              Flexible(
                child: Text(
                  DogFormatters.sexLabel(sex),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.labelMedium.copyWith(
                    color: color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
