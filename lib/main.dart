import 'package:dog_care_desktop/config/window/app_window.dart';
import 'package:dog_care_desktop/core/presentation/widgets/app_window/app_window_frame.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'config/theme/app_theme.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'injection_container.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await init();

  runApp(const DogCareApp());

  doWhenWindowReady(() {
    final window = appWindow;

    window.minSize = AppWindow.minimumSize;
    window.size = AppWindow.initialSize;
    window.alignment = Alignment.center;

    window.show();
  });
}

class DogCareApp extends StatelessWidget {
  const DogCareApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AuthBloc>(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Dog Care & Monitoring System',

        theme: AppTheme.lightTheme,

        home: const AppWindowFrame(child: LoginPage()),
      ),
    );
  }
}
