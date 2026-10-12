import 'package:dog_care_desktop/config/theme/app_colors.dart';
import 'package:dog_care_desktop/config/theme/app_dimensions.dart';
import 'package:dog_care_desktop/config/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../domain/entities/dog.dart';

/// Required choice with no hidden default ("Male" was silently preselected).
class DogSexSelector extends StatelessWidget {
  const DogSexSelector({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final DogSex? value;
  final ValueChanged<DogSex> onChanged;

  @override
  Widget build(BuildContext context) {
    return FormField<DogSex>(
      initialValue: value,
      validator: (v) => v == null ? 'Please choose a sex' : null,
      builder: (field) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Sex *', style: AppTextStyles.labelMedium),
            const SizedBox(height: AppDimensions.spacing8),
            SizedBox(
              width: double.infinity,
              child: SegmentedButton<DogSex>(
                style: SegmentedButton.styleFrom(
                  visualDensity: VisualDensity.compact,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.spacing12,
                    vertical: AppDimensions.spacing8,
                  ),
                  textStyle: Theme.of(context).textTheme.labelMedium,
                  foregroundColor: Theme.of(
                    context,
                  ).colorScheme.onSurfaceVariant,
                  backgroundColor: Theme.of(context).colorScheme.surface,
                  selectedForegroundColor: Theme.of(
                    context,
                  ).colorScheme.onPrimary,
                  selectedBackgroundColor: Theme.of(
                    context,
                  ).colorScheme.primary,
                  side: BorderSide(color: Theme.of(context).dividerColor),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      AppDimensions.radiusSmall,
                    ),
                  ),
                ),
                emptySelectionAllowed: true,
                showSelectedIcon: false,
                segments: [
                  ButtonSegment(
                    value: DogSex.male,
                    label: const Text('Male'),
                    icon: Icon(
                      PhosphorIcons.genderMale(PhosphorIconsStyle.bold),
                      size: 16,
                    ),
                  ),
                  ButtonSegment(
                    value: DogSex.female,
                    label: const Text('Female'),
                    icon: Icon(
                      PhosphorIcons.genderFemale(PhosphorIconsStyle.bold),
                      size: 16,
                    ),
                  ),
                ],
                selected: field.value == null ? <DogSex>{} : {field.value!},
                onSelectionChanged: (selection) {
                  if (selection.isEmpty) return;
                  field.didChange(selection.first);
                  onChanged(selection.first);
                },
              ),
            ),
            if (field.hasError)
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(
                  field.errorText!,
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.error,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
