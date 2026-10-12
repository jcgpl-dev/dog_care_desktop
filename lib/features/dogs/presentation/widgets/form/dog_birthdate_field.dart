import 'package:dog_care_desktop/config/theme/app_colors.dart';
import 'package:dog_care_desktop/config/theme/app_text_styles.dart';
import 'package:dog_care_desktop/core/presentation/widgets/inputs/app_date_field.dart';
import 'package:flutter/material.dart';

import '../../utils/dog_formatters.dart';

class DogBirthdateField extends StatelessWidget {
  const DogBirthdateField({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final DateTime? value;
  final ValueChanged<DateTime?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppDateField(
          label: 'Birthdate *',
          initialValue: value,
          firstDate: DateTime(2000),
          lastDate: DateTime.now(),
          requiredMessage: 'Birthdate is required',
          pickerHelpText: 'Select birthdate',
          onChanged: onChanged,
        ),
        if (value != null)
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(
              '${DogFormatters.age(value!)} old',
              style: AppTextStyles.labelSmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
      ],
    );
  }
}
