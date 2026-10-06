import 'package:dog_care_desktop/config/theme/app_colors.dart';
import 'package:flutter/material.dart';

class LoginFooter extends StatelessWidget {
  const LoginFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      'Default admin: admin / admin123',
      style: TextStyle(color: AppColors.darkText, fontSize: 14),
    );
  }
}
