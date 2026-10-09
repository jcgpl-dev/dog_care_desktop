import 'dart:ui';
import 'package:flutter/material.dart';

import '../../../../config/theme/app_colors.dart';

class GlassContainer extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final double blurSigma;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final double? height;
  final Color? borderColor;
  final double borderWidth;
  final List<Color>? gradientColors;

  const GlassContainer({
    super.key,
    required this.child,
    this.borderRadius = 24.0,
    this.blurSigma = 20.0,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.borderColor,
    this.borderWidth = 1.2,
    this.gradientColors,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveBorderColor =
        borderColor ?? AppColors.primaryContainer.withValues(alpha: 0.35);

    final effectiveGradientColors =
        gradientColors ??
        [
          AppColors.primary.withValues(alpha: 0.28),
          AppColors.secondary.withValues(alpha: 0.25),
          AppColors.cardColor.withValues(alpha: 0.35),
        ];

    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: AppColors.secondary.withValues(alpha: 0.25),
            blurRadius: 32,
            spreadRadius: -4,
            offset: const Offset(0, 16),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.18),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadius),
              border: Border.all(
                color: effectiveBorderColor,
                width: borderWidth,
              ),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: effectiveGradientColors,
                stops: const [0.0, 0.5, 1.0],
              ),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
