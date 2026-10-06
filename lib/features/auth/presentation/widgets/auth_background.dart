import 'package:flutter/material.dart';

import '../../../../config/theme/app_colors.dart';

class AuthBackground extends StatelessWidget {
  final Widget child;

  const AuthBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset('assets/images/login_bg.webp', fit: BoxFit.cover),
        Container(color: AppColors.overlay),
        child,
      ],
    );
  }
}
