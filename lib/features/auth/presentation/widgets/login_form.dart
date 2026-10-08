import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_dimensions.dart';
import '../../../../core/presentation/widgets/buttons/app_button.dart';
import '../../../../core/presentation/widgets/inputs/app_text_field.dart';
import '../../../../core/utils/validators/auth_validators.dart';
import '../bloc/auth_bloc.dart';

class LoginForm extends StatefulWidget {
  final VoidCallback? onSignUpPressed;

  const LoginForm({super.key, this.onSignUpPressed});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;

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
    return Card(
      color: AppColors.cardColor,
      elevation: 12,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.loginCardPadding),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Sign in to your account',
                style: Theme.of(
                  context,
                ).textTheme.headlineMedium?.copyWith(color: AppColors.darkText),
              ),
              const SizedBox(height: AppDimensions.spacing24),
              AppTextField(
                variant: AppTextFieldVariant.dark,
                focusedBorderColor: AppColors.primary,
                label: 'Username',
                hint: 'Enter username',
                controller: _usernameController,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                validator: AuthValidators.validateUsername,
              ),
              const SizedBox(height: AppDimensions.spacing16),
              AppTextField(
                variant: AppTextFieldVariant.dark,
                label: 'Password',
                hint: 'Enter password',
                controller: _passwordController,
                focusedBorderColor: AppColors.primary,
                keyboardType: TextInputType.visiblePassword,
                textInputAction: TextInputAction.done,
                obscureText: _obscurePassword,
                suffixIconColor: AppColors.secondary,
                suffixIcon: IconButton(
                  onPressed: _togglePasswordVisibility,
                  icon: Icon(
                    _obscurePassword
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                  ),
                ),
                validator: AuthValidators.validatePassword,
                onSubmitted: (_) => _submit(),
              ),
              const SizedBox(height: AppDimensions.spacing24),
              _LoginSubmitButton(onPressed: _submit),
              const SizedBox(height: AppDimensions.spacing24),
              _SignUpPrompt(onSignUpPressed: widget.onSignUpPressed),
            ],
          ),
        ),
      ),
    );
  }
}

class _LoginSubmitButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _LoginSubmitButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      buildWhen: (previous, current) =>
          previous.runtimeType != current.runtimeType,
      builder: (context, state) {
        final isLoading = state is AuthLoading;

        return AppButton(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textPrimary,
          label: 'Sign in',
          isLoading: isLoading,
          onPressed: isLoading ? null : onPressed,
        );
      },
    );
  }
}

class _SignUpPrompt extends StatelessWidget {
  final VoidCallback? onSignUpPressed;

  const _SignUpPrompt({this.onSignUpPressed});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Don't have an account?",
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: AppColors.darkText),
        ),
        TextButton(
          onPressed: onSignUpPressed,
          child: const Text(
            'Sign Up',
            style: TextStyle(color: AppColors.primary),
          ),
        ),
      ],
    );
  }
}
