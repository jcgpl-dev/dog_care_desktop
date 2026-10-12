import 'package:dog_care_desktop/config/theme/app_dimensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import 'app_date_picker.dart';
import 'app_text_field.dart';

class AppDateField extends StatefulWidget {
  const AppDateField({
    super.key,
    this.label,
    this.initialValue,
    required this.onChanged,
    required this.firstDate,
    required this.lastDate,
    this.isRequired = true,
    this.requiredMessage = 'Date is required',
    this.pickerHelpText = 'Select date',
  });

  final String? label;
  final DateTime? initialValue;
  final ValueChanged<DateTime?> onChanged;
  final DateTime firstDate;
  final DateTime lastDate;
  final bool isRequired;
  final String requiredMessage;
  final String pickerHelpText;

  @override
  State<AppDateField> createState() => _AppDateFieldState();
}

class _AppDateFieldState extends State<AppDateField> {
  static final DateFormat _format = DateFormat('MM/dd/yyyy');

  late final TextEditingController _controller;
  late final DateTime _first = DateUtils.dateOnly(widget.firstDate);
  late final DateTime _last = DateUtils.dateOnly(widget.lastDate);
  DateTime? _current; // last value emitted to the parent

  @override
  void initState() {
    super.initState();
    final initial = widget.initialValue;
    _current = initial == null ? null : DateUtils.dateOnly(initial);
    _controller = TextEditingController(
      text: _current == null ? '' : _format.format(_current!),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  DateTime? _parse(String text) {
    if (text.length != 10) return null;
    try {
      return _format.parseStrict(text); // rejects 02/30/2024, 13/01/2024...
    } on FormatException {
      return null;
    }
  }

  bool _inRange(DateTime d) => !d.isBefore(_first) && !d.isAfter(_last);

  String? _validate(String? text) {
    final value = text?.trim() ?? '';
    if (value.isEmpty) return widget.isRequired ? widget.requiredMessage : null;

    final parsed = _parse(value);
    if (parsed == null) {
      return value.length < 10
          ? 'Enter the full date (MM/DD/YYYY)'
          : 'That date does not exist';
    }
    if (parsed.isBefore(_first)) {
      return 'Date must be on or after ${_format.format(_first)}';
    }
    if (parsed.isAfter(_last)) {
      return 'Date must be on or before ${_format.format(_last)}';
    }
    return null;
  }

  void _emit(DateTime? next) {
    final same = next == null
        ? _current == null
        : (_current != null && DateUtils.isSameDay(next, _current));
    if (same) return;
    _current = next;
    widget.onChanged(next);
  }

  void _handleTyped(FormFieldState<String> field, String text) {
    final parsed = _parse(text);
    _emit(parsed != null && _inRange(parsed) ? parsed : null);
    field.didChange(text);
    if (field.hasError) field.validate(); // clear/update error live
  }

  Future<void> _openPicker(FormFieldState<String> field) async {
    final typed = _parse(_controller.text);
    final today = DateUtils.dateOnly(DateTime.now());
    final seed = typed != null && _inRange(typed)
        ? typed
        : (today.isAfter(_last)
              ? _last
              : (today.isBefore(_first) ? _first : today));

    final picked = await showAppDatePicker(
      context,
      initialDate: seed,
      firstDate: _first,
      lastDate: _last,
      helpText: widget.pickerHelpText,
    );
    if (picked == null || !mounted) return;

    final text = _format.format(picked);
    _controller.text = text;
    _emit(DateUtils.dateOnly(picked));
    field.didChange(text);
    if (field.hasError) field.validate();
  }

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      initialValue: _controller.text,
      validator: _validate,
      builder: (field) => AppTextField(
        controller: _controller,
        label: widget.label,
        hint: 'MM/DD/YYYY',
        errorText: field.errorText,
        keyboardType: TextInputType.number,
        inputFormatters: [
          _DateMaskFormatter(minYear: _first.year, maxYear: _last.year),
        ],
        onChanged: (text) => _handleTyped(field, text),
        suffixIcon: IconButton(
          tooltip: 'Pick a date',
          icon: Icon(
            PhosphorIcons.calendar(PhosphorIconsStyle.bold),
            size: AppDimensions.spacing20,
          ),
          onPressed: () => _openPicker(field),
        ),
      ),
    );
  }
}

/// Validates EVERY digit as it is typed, so an impossible date can't be entered.
/// Also auto-pads: typing 4 in the month becomes 04, typing 5 in a day that
/// can't start with 5 becomes 05. Accepts pasted 04122023, 4/12/2023 or
/// ISO 2023-04-12.
class _DateMaskFormatter extends TextInputFormatter {
  _DateMaskFormatter({required this.minYear, required this.maxYear});

  final int minYear;
  final int maxYear;

  // Feb allows 29 until the year is known; the validator catches 02/29 in
  // non-leap years once the year is complete.
  static const _maxDays = [31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];

  int _maxDay(List<int> d) => _maxDays[d[0] * 10 + d[1] - 1];

  bool _yearPrefixOk(String prefix) {
    for (var y = minYear; y <= maxYear; y++) {
      if ('$y'.startsWith(prefix)) return true;
    }
    return false;
  }

  /// Returns the digits to append, or null if [digit] is not allowed here.
  List<int>? _accept(List<int> d, int digit) {
    switch (d.length) {
      case 0: // month, first digit
        return digit <= 1 ? [digit] : [0, digit];
      case 1: // month, second digit
        final month = d[0] * 10 + digit;
        return month >= 1 && month <= 12 ? [digit] : null;
      case 2: // day, first digit
        return digit <= _maxDay(d) ~/ 10 ? [digit] : [0, digit];
      case 3: // day, second digit
        final day = d[2] * 10 + digit;
        return day >= 1 && day <= _maxDay(d) ? [digit] : null;
      default: // year digits
        final prefix = [...d.sublist(4), digit].join();
        return _yearPrefixOk(prefix) ? [digit] : null;
    }
  }

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var text = newValue.text;
    final iso = RegExp(r'^(\d{4})-(\d{2})-(\d{2})$').firstMatch(text);
    if (iso != null) text = '${iso[2]}${iso[3]}${iso[1]}';

    final digits = <int>[];
    for (final unit in text.codeUnits) {
      if (unit < 48 || unit > 57 || digits.length >= 8) continue;
      final add = _accept(digits, unit - 48);
      if (add != null) digits.addAll(add);
    }

    final buffer = StringBuffer();
    for (var i = 0; i < digits.length; i++) {
      if (i == 2 || i == 4) buffer.write('/');
      buffer.write(digits[i]);
    }
    final formatted = buffer.toString();
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
