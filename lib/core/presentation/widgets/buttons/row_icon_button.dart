import 'package:dog_care_desktop/config/theme/app_colors.dart';
import 'package:dog_care_desktop/config/theme/app_dimensions.dart';
import 'package:flutter/material.dart';

class RowIconButton extends StatelessWidget {
  const RowIconButton({
    super.key,
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    this.color = AppColors.primary,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;

  final Color color;

  static const double _size = 32;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: tooltip,
      onPressed: onPressed,
      icon: Icon(icon),
      style: ButtonStyle(
        iconSize: const WidgetStatePropertyAll(18),
        fixedSize: const WidgetStatePropertyAll(Size(_size, _size)),
        minimumSize: const WidgetStatePropertyAll(Size(_size, _size)),
        padding: const WidgetStatePropertyAll(EdgeInsets.zero),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        splashFactory: NoSplash.splashFactory,
        mouseCursor: const WidgetStatePropertyAll(SystemMouseCursors.click),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
          ),
        ),
        foregroundColor: WidgetStatePropertyAll(color),
        // The background itself carries the state, so no separate overlay.
        overlayColor: const WidgetStatePropertyAll(Colors.transparent),
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.pressed)) {
            return color.withValues(alpha: 0.28);
          }
          if (states.contains(WidgetState.hovered)) {
            return color.withValues(alpha: 0.20);
          }
          return color.withValues(alpha: 0.12);
        }),
        // Keyboard focus ring (Tab navigation); invisible for mouse users.
        side: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.focused)
              ? BorderSide(color: color, width: 1.5)
              : BorderSide.none,
        ),
      ),
    );
  }
}
