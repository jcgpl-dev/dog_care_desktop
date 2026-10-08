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

class DogCareApp extends StatefulWidget {
  const DogCareApp({super.key});

  @override
  State<DogCareApp> createState() => _DogCareAppState();
}

class _DogCareAppState extends State<DogCareApp> {
  late final AuthBloc _authBloc;
  late final router = AppRouter.createRouter(_authBloc);

  @override
  void initState() {
    super.initState();
    _authBloc = sl<AuthBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>.value(value: _authBloc),
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
            routerConfig: router,
          );
        },
      ),
    );
  }
}