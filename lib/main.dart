import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:dog_care_desktop/app/presentation/shell/cubit/sidebar_cubit.dart';
import 'package:dog_care_desktop/config/theme/cubit/theme_cubit.dart';
import 'package:dog_care_desktop/config/theme/cubit/theme_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'config/router/app_router.dart';
import 'config/theme/app_theme.dart';
import 'config/window/app_window.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'injection_container.dart';

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

// lib/main.dart
class DogCareApp extends StatelessWidget {
  const DogCareApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<AuthBloc>()),
        BlocProvider(create: (_) => sl<ThemeCubit>()),
        BlocProvider(create: (_) => sl<SidebarCubit>()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, themeState) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: 'Dog Care & Monitoring System',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeState.themeMode,
            routerConfig: AppRouter.router,
          );
        },
      ),
    );
  }
}
