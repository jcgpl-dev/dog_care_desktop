import 'package:dog_care_desktop/config/theme/app_colors.dart';
import 'package:dog_care_desktop/config/theme/app_dimensions.dart';
import 'package:dog_care_desktop/core/presentation/widgets/cards/app_metric_card.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../models/dogs_metrics.dart';

/// Pure presentation: receives ready-made numbers, computes nothing.
/// Lays itself out as 4 / 2 / 1 columns depending on available width,
/// so a card is never squeezed below [_minCardWidth].
class DogsMetricCards extends StatelessWidget {
  const DogsMetricCards({super.key, required this.metrics});

  final DogsMetrics metrics;

  static const double _minCardWidth = 150;
  static const double _gap = AppDimensions.spacing16;

  int _columnsFor(double width) {
    bool fits(int n) => width >= n * _minCardWidth + (n - 1) * _gap;
    if (fits(4)) return 4;
    if (fits(2)) return 2;
    return 1;
  }

  @override
  Widget build(BuildContext context) {
    String _share(int part) {
      if (metrics.total == 0) return 'No dogs yet';
      return '${(part * 100 / metrics.total).round()}% of all dogs';
    }

    ({String text, Color? color}) _monthTrend() {
      final diff = metrics.registeredThisMonth - metrics.registeredLastMonth;
      if (diff > 0) return (text: '+$diff vs last month', color: Colors.green);
      if (diff < 0) return (text: '$diff vs last month', color: null);
      return (text: 'Same as last month', color: null);
    }

    final trend = _monthTrend();
    final cards = [
      AppMetricCard(
        title: 'Total Registered',
        value: '${metrics.total}',
        subtitle: metrics.owners == 1
            ? 'From 1 owner'
            : 'From ${metrics.owners} owners',
        icon: PhosphorIcons.dog(PhosphorIconsStyle.bold),
        accentColor: Colors.green,
        //black
      ),
      AppMetricCard(
        title: 'Registered This Month',
        value: '${metrics.registeredThisMonth}',
        subtitle: trend.text,
        subtitleColor: trend.color,
        icon: PhosphorIcons.calendarCheck(PhosphorIconsStyle.bold),
        accentColor: const Color.fromARGB(255, 228, 206, 0),
        // yellow
      ),
      AppMetricCard(
        title: 'Male Dogs',
        value: '${metrics.male}',
        subtitle: _share(metrics.male),
        icon: PhosphorIcons.genderMale(PhosphorIconsStyle.bold),
        accentColor: Colors.blue,
        //green
      ),
      AppMetricCard(
        title: 'Female Dogs',
        value: '${metrics.female}',
        subtitle: _share(metrics.female),
        icon: PhosphorIcons.genderFemale(PhosphorIconsStyle.bold),
        accentColor: Colors.pink,
        //red
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = _columnsFor(constraints.maxWidth);
        final cardWidth =
            (constraints.maxWidth - _gap * (columns - 1)) / columns;

        return Wrap(
          spacing: _gap,
          runSpacing: _gap,
          children: [
            for (final card in cards) SizedBox(width: cardWidth, child: card),
          ],
        );
      },
    );
  }
}
