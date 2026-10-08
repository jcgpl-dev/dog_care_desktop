import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/presentation/shell/app_shell.dart';
import '../../features/alerts/presentation/pages/alerts_page.dart';
import '../../features/appointments/presentation/pages/appointments_page.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../../features/dogs/presentation/pages/dogs_page.dart';
import '../../features/health_records/presentation/pages/health_records_page.dart';
import '../../features/reports/presentation/pages/reports_page.dart';
import '../../features/services/presentation/pages/deworming_page.dart';
import '../../features/services/presentation/pages/treatments_page.dart';
import '../../features/services/presentation/pages/vaccinations_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
import '../../features/user_management/presentation/pages/user_management_page.dart';
import 'app_router_notifier.dart';

class AppRouter {
  AppRouter._();

  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _shellNavigatorKey = GlobalKey<NavigatorState>();

  static GoRouter createRouter(AuthBloc authBloc) {
    final notifier = AppRouterNotifier(authBloc);

    return GoRouter(
      navigatorKey: _rootNavigatorKey,
      initialLocation: '/dashboard',
      refreshListenable: notifier,
      redirect: (context, state) {
        final authState = notifier.state;
        final isLoggingIn = state.matchedLocation == '/login';

        final isAuthenticated = authState is AuthAuthenticated;

        if (!isAuthenticated && !isLoggingIn) {
          return '/login';
        }

        if (isAuthenticated && isLoggingIn) {
          return '/dashboard';
        }

        return null;
      },
      routes: [
        GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
        ShellRoute(
          navigatorKey: _shellNavigatorKey,
          builder: (context, state, child) => AppShell(child: child),
          routes: [
            GoRoute(
              path: '/dashboard',
              pageBuilder: (context, state) =>
                  const NoTransitionPage(child: DashboardPage()),
            ),
            GoRoute(
              path: '/dogs',
              pageBuilder: (context, state) =>
                  const NoTransitionPage(child: DogsPage()),
            ),
            GoRoute(
              path: '/health-records',
              pageBuilder: (context, state) =>
                  const NoTransitionPage(child: HealthRecordsPage()),
            ),
            GoRoute(
              path: '/vaccinations',
              pageBuilder: (context, state) =>
                  const NoTransitionPage(child: VaccinationsPage()),
            ),
            GoRoute(
              path: '/deworming',
              pageBuilder: (context, state) =>
                  const NoTransitionPage(child: DewormingPage()),
            ),
            GoRoute(
              path: '/treatments',
              pageBuilder: (context, state) =>
                  const NoTransitionPage(child: TreatmentsPage()),
            ),
            GoRoute(
              path: '/appointments',
              pageBuilder: (context, state) =>
                  const NoTransitionPage(child: AppointmentsPage()),
            ),
            GoRoute(
              path: '/reports',
              pageBuilder: (context, state) =>
                  const NoTransitionPage(child: ReportsPage()),
            ),
            GoRoute(
              path: '/alerts',
              pageBuilder: (context, state) =>
                  const NoTransitionPage(child: AlertsPage()),
            ),
            GoRoute(
              path: '/manage-users',
              pageBuilder: (context, state) =>
                  const NoTransitionPage(child: UserManagementPage()),
            ),
            GoRoute(
              path: '/settings',
              pageBuilder: (context, state) =>
                  const NoTransitionPage(child: SettingsPage()),
            ),
          ],
        ),
      ],
    );
  }
}
