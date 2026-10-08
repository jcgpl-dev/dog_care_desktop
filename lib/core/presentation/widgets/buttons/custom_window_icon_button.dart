import 'package:dog_care_desktop/config/theme/app_colors.dart';
import 'package:flutter/material.dart';

class CustomWindowIconButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final String? tooltip;
  final Color? hoverColor;
  final double splashRadius;
  final Color? iconColor;
  final Color? closeHoverIconColor;

  const CustomWindowIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.tooltip,
    this.hoverColor,
    this.splashRadius = 18,
    this.iconColor,
    this.closeHoverIconColor,
  });

  @override
  State<CustomWindowIconButton> createState() => _CustomWindowIconButtonState();
}

class _CustomWindowIconButtonState extends State<CustomWindowIconButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final effectiveIconColor =
        (_isHovered && widget.closeHoverIconColor != null)
        ? widget.closeHoverIconColor!
        : (widget.iconColor ?? AppColors.textPrimary);

    return Tooltip(
      message: widget.tooltip ?? "",
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.zero,
          hoverColor: widget.hoverColor ?? Colors.black.withValues(alpha: 0.06),
          onHover: (hovered) {
            setState(() {
              _isHovered = hovered;
            });
          },
          onTap: widget.onPressed,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8.0),
            child: Center(
              child: Icon(widget.icon, size: 18, color: effectiveIconColor),
            ),
          ),
        ),
      ),
    );
  }
}
