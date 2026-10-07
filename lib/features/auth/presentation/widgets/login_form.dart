import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_dimensions.dart';
import '../../../../core/presentation/widgets/buttons/app_button.dart';
import '../../../../core/presentation/widgets/inputs/app_text_field.dart';
import '../bloc/auth_bloc.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

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

  String? _validateUsername(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Username is required';
    }

    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    return null;
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
        padding: const EdgeInsets.all(32),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTitle(),

              const SizedBox(height: 24),

              _buildUsernameField(),

              const SizedBox(height: 16),

              _buildPasswordField(),

              const SizedBox(height: 24),

              _buildSubmitButton(),
              const SizedBox(height: 24),
              _buildAuthOption(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        'Sign in to your account',
        style: Theme.of(
          context,
        ).textTheme.headlineMedium?.copyWith(color: AppColors.darkText),
      ),
    );
  }

  Widget _buildUsernameField() {
    return AppTextField(
      variant: AppTextFieldVariant.dark,
      focusedBorderColor: AppColors.primary,
      label: 'Username',
      hint: 'Enter username',
      controller: _usernameController,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      validator: _validateUsername,
    );
  }

  Widget _buildPasswordField() {
    return AppTextField(
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
      validator: _validatePassword,
      onSubmitted: (_) => _submit(),
    );
  }

  Widget _buildSubmitButton() {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final isLoading = state is AuthLoading;

        return AppButton(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textPrimary,
          label: 'Sign in',
          onPressed: isLoading ? null : _submit,
        );
      },
    );
  }

  Widget _buildAuthOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Dont have an account?",
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: AppColors.darkText),
        ),
        TextButton(
          onPressed: () {
            // Handle "Sign Up" action
          },
          child: const Text(
            'Sign Up',
            style: TextStyle(color: AppColors.primary),
          ),
        ),
      ],
    );
  }
}
