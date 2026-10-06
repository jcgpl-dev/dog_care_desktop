import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:dog_care_desktop/config/theme/app_colors.dart';
import 'package:dog_care_desktop/core/presentation/widgets/buttons/custom_window_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class WindowControls extends StatefulWidget {
  final Color? iconColor;
  final Color? minimizeColor;
  final Color? maximizeColor;
  final Color? closeColor;

  const WindowControls({
    super.key,
    this.iconColor,
    this.minimizeColor,
    this.maximizeColor,
    this.closeColor,
  });

  @override
  State<WindowControls> createState() => _WindowControlsState();
}

class _WindowControlsState extends State<WindowControls>
    with WidgetsBindingObserver {
  bool _isMaximized = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);

    _isMaximized = appWindow.isMaximized;
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    final isMaximized = appWindow.isMaximized;

    if (_isMaximized != isMaximized) {
      setState(() {
        _isMaximized = isMaximized;
      });
    }
  }

  void _toggleMaximize() {
    if (_isMaximized) {
      appWindow.restore();
    } else {
      appWindow.maximize();
    }

    setState(() {
      _isMaximized = appWindow.isMaximized;
    });
  }

  @override
  Widget build(BuildContext context) {
    final defaultIconColor = widget.iconColor ?? AppColors.textPrimary;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomWindowIconButton(
          icon: PhosphorIconsRegular.minus,
          iconColor: widget.minimizeColor ?? defaultIconColor,
          tooltip: 'Minimize',
          onPressed: appWindow.minimize,
        ),

        CustomWindowIconButton(
          icon: _isMaximized
              ? PhosphorIconsRegular.cornersIn
              : PhosphorIconsRegular.cornersOut,
          iconColor: widget.maximizeColor ?? defaultIconColor,
          tooltip: _isMaximized ? 'Restore' : 'Maximize',
          onPressed: _toggleMaximize,
        ),

        CustomWindowIconButton(
          icon: PhosphorIconsRegular.x,
          iconColor: widget.closeColor ?? defaultIconColor,
          tooltip: 'Close',
          hoverColor: Colors.red.withValues(alpha: 0.2),
          onPressed: appWindow.close,
        ),
      ],
    );
  }
}
