import 'package:dog_care_desktop/core/presentation/widgets/cards/app_metric_card.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_dimensions.dart';
import '../../domain/entities/dog.dart';

class DogsMetricCards extends StatelessWidget {
  final List<Dog> dogs;

  const DogsMetricCards({super.key, required this.dogs});

  @override
  Widget build(BuildContext context) {
    final totalDogs = dogs.length;
    final maleCount = dogs.where((d) => d.sex == DogSex.male).length;
    final femaleCount = dogs.where((d) => d.sex == DogSex.female).length;

    final recentCount = dogs.where((d) {
      return d.registeredAt.year == 2026 && d.registeredAt.month == 10;
    }).length;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppDimensions.spacing24,
        AppDimensions.spacing24,
        AppDimensions.spacing24,
        AppDimensions.spacing16,
      ),
      child: Row(
        children: [
          Expanded(
            child: AppMetricCard(
              title: 'Total Registered',
              value: '$totalDogs',
              icon: PhosphorIcons.dog(PhosphorIconsStyle.bold),
              accentColor: AppColors.primary,
            ),
          ),
          const SizedBox(width: AppDimensions.spacing16),
          Expanded(
            child: AppMetricCard(
              title: 'Male Dogs',
              value: '$maleCount',
              icon: PhosphorIcons.genderMale(PhosphorIconsStyle.bold),
              accentColor: AppColors.info,
            ),
          ),
          const SizedBox(width: AppDimensions.spacing16),
          Expanded(
            child: AppMetricCard(
              title: 'Female Dogs',
              value: '$femaleCount',
              icon: PhosphorIcons.genderFemale(PhosphorIconsStyle.bold),
              accentColor: AppColors.secondary,
            ),
          ),
          const SizedBox(width: AppDimensions.spacing16),
          Expanded(
            child: AppMetricCard(
              title: 'Registered This Month',
              value: '$recentCount',
              icon: PhosphorIcons.calendarCheck(PhosphorIconsStyle.bold),
              accentColor: Colors.green,
            ),
          ),
        ],
      ),
    );
  }
}
