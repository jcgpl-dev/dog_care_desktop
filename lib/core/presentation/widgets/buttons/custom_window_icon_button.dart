import 'package:dog_care_desktop/config/theme/app_colors.dart';
import 'package:flutter/material.dart';

class CustomWindowIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final String? tooltip;
  final Color hoverColor;
  final double splashRadius;
  final Color? iconColor;

  const CustomWindowIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.tooltip,
    this.hoverColor = const Color.fromARGB(34, 38, 68, 103),
    this.splashRadius = 18,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip ?? "",
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(0),
          hoverColor: hoverColor,
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8.0),
            child: Center(
              child: Icon(
                icon,
                size: 18,
                color: iconColor ?? AppColors.textPrimary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
