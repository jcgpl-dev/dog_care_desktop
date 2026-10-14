import 'package:dog_care_desktop/config/theme/app_dimensions.dart';
import 'package:dog_care_desktop/config/theme/app_shadows.dart';
import 'package:flutter/material.dart';

class AppTableContainer extends StatelessWidget {
  const AppTableContainer({super.key, required this.child, this.footer});

  final Widget child;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final radius = BorderRadius.circular(AppDimensions.radiusSmall);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: radius,
        boxShadow: isDark ? AppShadows.cardDark : AppShadows.cardLight,
      ),
      child: ClipRRect(
        borderRadius: radius,
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.spacing12),
          child: Column(
            children: [
              Expanded(child: child),
              if (footer != null) footer!,
            ],
          ),
        ),
      ),
    );
  }
}
