import 'dart:math' as math;

import 'package:dog_care_desktop/config/theme/app_colors.dart';
import 'package:dog_care_desktop/config/theme/app_dimensions.dart';
import 'package:dog_care_desktop/config/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

Future<DateTime?> showAppDatePicker(
  BuildContext context, {
  required DateTime initialDate,
  required DateTime firstDate,
  required DateTime lastDate,
  String helpText = 'Select date',
}) {
  return showDialog<DateTime>(
    context: context,
    builder: (_) => AppDatePickerDialog(
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
      helpText: helpText,
    ),
  );
}

class AppDatePickerDialog extends StatefulWidget {
  const AppDatePickerDialog({
    super.key,
    required this.initialDate,
    required this.firstDate,
    required this.lastDate,
    this.helpText = 'Select date',
  });

  final DateTime initialDate;
  final DateTime firstDate;
  final DateTime lastDate;
  final String helpText;

  @override
  State<AppDatePickerDialog> createState() => _AppDatePickerDialogState();
}

class _AppDatePickerDialogState extends State<AppDatePickerDialog> {
  static const double _cell = 40;
  static const double _weekdayRow = 28;
  static const double _yearRow = 44;

  late final DateTime _first = DateUtils.dateOnly(widget.firstDate);
  late final DateTime _last = DateUtils.dateOnly(widget.lastDate);
  late final ScrollController _yearScroll;

  late DateTime _selected;
  late DateTime _month; // first day of the month being shown
  bool _pickingYear = false;

  @override
  void initState() {
    super.initState();
    final initial = DateUtils.dateOnly(widget.initialDate);
    _selected = initial.isBefore(_first)
        ? _first
        : (initial.isAfter(_last) ? _last : initial);
    _month = DateTime(_selected.year, _selected.month);

    // Open the year grid already scrolled near the selected year.
    final row = (_last.year - _selected.year) ~/ 4;
    _yearScroll = ScrollController(
      initialScrollOffset: math.max(0.0, (row - 1) * _yearRow),
    );
  }

  @override
  void dispose() {
    _yearScroll.dispose();
    super.dispose();
  }

  bool get _canGoPrev =>
      !DateTime(_month.year, _month.month, 0).isBefore(_first);
  bool get _canGoNext =>
      !DateTime(_month.year, _month.month + 1, 1).isAfter(_last);

  void _shiftMonth(int delta) =>
      setState(() => _month = DateTime(_month.year, _month.month + delta));

  void _pickYear(int year) {
    var next = DateTime(year, _month.month);
    final min = DateTime(_first.year, _first.month);
    final max = DateTime(_last.year, _last.month);
    if (next.isBefore(min)) next = min;
    if (next.isAfter(max)) next = max;
    setState(() {
      _month = next;
      _pickingYear = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
        side: BorderSide(color: Theme.of(context).dividerColor),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 340),
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.spacing20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.helpText,
                style: AppTextStyles.labelMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                DateFormat('EEE, MMM d, yyyy').format(_selected),
                style: AppTextStyles.titleLarge,
              ),
              const SizedBox(height: AppDimensions.spacing16),
              _buildNavigation(),
              const SizedBox(height: AppDimensions.spacing8),
              // Fixed height so the dialog doesn't resize between modes.
              SizedBox(
                height: _weekdayRow + 6 * _cell,
                child: _pickingYear ? _buildYears(scheme) : _buildDays(scheme),
              ),
              const SizedBox(height: AppDimensions.spacing16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: AppDimensions.spacing8),
                  FilledButton(
                    onPressed: () => Navigator.of(context).pop(_selected),
                    child: const Text('Select'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavigation() {
    return Row(
      children: [
        IconButton(
          tooltip: 'Previous month',
          onPressed: _canGoPrev && !_pickingYear ? () => _shiftMonth(-1) : null,
          icon: Icon(
            PhosphorIcons.caretLeft(PhosphorIconsStyle.bold),
            size: 16,
          ),
        ),
        Expanded(
          child: Center(
            child: TextButton(
              onPressed: () => setState(() => _pickingYear = !_pickingYear),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(DateFormat('MMMM yyyy').format(_month)),
                  const SizedBox(width: 6),
                  Icon(
                    _pickingYear
                        ? PhosphorIcons.caretUp(PhosphorIconsStyle.bold)
                        : PhosphorIcons.caretDown(PhosphorIconsStyle.bold),
                    size: 14,
                  ),
                ],
              ),
            ),
          ),
        ),
        IconButton(
          tooltip: 'Next month',
          onPressed: _canGoNext && !_pickingYear ? () => _shiftMonth(1) : null,
          icon: Icon(
            PhosphorIcons.caretRight(PhosphorIconsStyle.bold),
            size: 16,
          ),
        ),
      ],
    );
  }

  Widget _buildDays(ColorScheme scheme) {
    final daysInMonth = DateUtils.getDaysInMonth(_month.year, _month.month);
    final leading = _month.weekday % 7; // Sunday-first grid

    return Column(
      children: [
        Row(
          children: [
            for (final letter in const ['S', 'M', 'T', 'W', 'T', 'F', 'S'])
              Expanded(
                child: SizedBox(
                  height: _weekdayRow,
                  child: Center(
                    child: Text(
                      letter,
                      style: AppTextStyles.labelMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
        for (var week = 0; week < 6; week++)
          Row(
            children: [
              for (var col = 0; col < 7; col++)
                Expanded(
                  child: _buildDayCell(
                    week * 7 + col - leading + 1,
                    daysInMonth,
                    scheme,
                  ),
                ),
            ],
          ),
      ],
    );
  }

  Widget _buildDayCell(int day, int daysInMonth, ColorScheme scheme) {
    if (day < 1 || day > daysInMonth) return const SizedBox(height: _cell);

    final date = DateTime(_month.year, _month.month, day);
    final enabled = !date.isBefore(_first) && !date.isAfter(_last);
    final isSelected = DateUtils.isSameDay(date, _selected);
    final isToday = DateUtils.isSameDay(date, DateTime.now());

    final Color textColor = isSelected
        ? scheme.onPrimary
        : (!enabled ? AppColors.textDisabled : scheme.onSurface);

    return SizedBox(
      height: _cell,
      child: Center(
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: enabled ? () => setState(() => _selected = date) : null,
          child: Container(
            width: 36,
            height: 36,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected ? scheme.primary : null,
              border: isToday && !isSelected
                  ? Border.all(color: scheme.primary)
                  : null,
            ),
            child: Text(
              '$day',
              style: AppTextStyles.bodyMedium.copyWith(
                color: textColor,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildYears(ColorScheme scheme) {
    final count = _last.year - _first.year + 1;

    return GridView.builder(
      controller: _yearScroll,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisExtent: _yearRow,
      ),
      itemCount: count,
      itemBuilder: (context, index) {
        final year = _last.year - index; // newest first
        final isCurrent = year == _month.year;

        return Center(
          child: InkWell(
            borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
            onTap: () => _pickYear(year),
            child: Container(
              width: 64,
              height: 32,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isCurrent ? scheme.primary : null,
                borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
              ),
              child: Text(
                '$year',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: isCurrent ? scheme.onPrimary : scheme.onSurface,
                  fontWeight: isCurrent ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
