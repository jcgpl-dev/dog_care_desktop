import 'package:dog_care_desktop/config/theme/app_colors.dart';
import 'package:dog_care_desktop/config/theme/app_dimensions.dart';
import 'package:dog_care_desktop/core/presentation/widgets/buttons/app_button.dart';
import 'package:dog_care_desktop/core/presentation/widgets/inputs/app_text_field.dart';
import 'package:dog_care_desktop/features/auth/presentation/widgets/auth_background.dart';
import 'package:dog_care_desktop/features/auth/presentation/widgets/login_footer.dart';
import 'package:dog_care_desktop/features/auth/presentation/widgets/login_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/auth_bloc.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    context.read<AuthBloc>().add(
      AuthLoginRequested(
        username: _usernameController.text.trim(),
        password: _passwordController.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Background
        AuthBackground(child: Container()),

        Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),
              child: Column(
                children: [
                  LoginHeader(),
                  SizedBox(height: AppDimensions.spacing16),
                  Card(
                    color: AppColors.cardColor,
                    elevation: 12,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        AppDimensions.radiusSmall,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,

                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const Text(
                                  'Sign in to your account',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 24),

                            AppTextField(
                              textColor: AppColors.darkText,
                              labelColor: AppColors.darkText,
                              fillColor: AppColors.cardColor,
                              hintColor: AppColors.textDisabled,
                              borderColor: AppColors.darkBorderDisabled,
                              hint: 'Enter username',
                              label: 'Username',
                              controller: _usernameController,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Username is required';
                                }
                                return null;
                              },
                            ),

                            const SizedBox(height: 16),

                            AppTextField(
                              textColor: AppColors.darkText,
                              fillColor: AppColors.cardColor,
                              labelColor: AppColors.darkText,
                              hint: 'Enter password',
                              hintColor: AppColors.textDisabled,
                              borderColor: AppColors.darkBorderDisabled,
                              label: 'Password',
                              controller: _passwordController,
                              obscureText: _obscurePassword,
                              suffixIconColor: AppColors.secondary,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Password is required';
                                }
                                return null;
                              },
                              suffixIcon: IconButton(
                                onPressed: _togglePasswordVisibility,
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                ),
                              ),
                            ),

                            const SizedBox(height: 24),

                            BlocBuilder<AuthBloc, AuthState>(
                              builder: (context, state) {
                                final isLoading = state is AuthLoading;
                                return AppButton(
                                  label: 'Login',
                                  onPressed: () {
                                    isLoading ? null : _submit;
                                  },
                                );
                              },
                            ),

                            const SizedBox(height: 16),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Don't have an account?",
                                  style: TextStyle(
                                    color: AppColors.darkText,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    // Registration will be implemented later.
                                  },
                                  child: const Text(
                                    'Register here',
                                    style: TextStyle(
                                      color: Color(0xFF00E676),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppDimensions.spacing16),

                  LoginFooter(),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
