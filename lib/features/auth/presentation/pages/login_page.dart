import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/theme/app_colors.dart';
import '../bloc/auth_bloc.dart';
import '../widgets/auth_background.dart';
import '../widgets/login_footer.dart';
import '../widgets/login_form.dart';
import '../widgets/login_header.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: _onAuthStateChanged,
      child: const Scaffold(body: _LoginContent()),
    );
  }

  void _onAuthStateChanged(BuildContext context, AuthState state) {
    if (state is AuthAuthenticated) {
      _navigateToDashboard(context);
      return;
    }

    if (state is AuthFailure) {
      _showErrorMessage(context, state.message);
    }
  }

  void _navigateToDashboard(BuildContext context) {
    context.go('/dashboard');
  }

  void _showErrorMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: AppColors.error),
    );
  }
}

class _LoginContent extends StatelessWidget {
  const _LoginContent();

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        const AuthBackground(child: SizedBox.expand()),
        Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  LoginHeader(),
                  SizedBox(height: 16),
                  LoginForm(),
                  SizedBox(height: 16),
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
