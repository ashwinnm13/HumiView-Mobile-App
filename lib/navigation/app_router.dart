import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'main_shell.dart';
import '../screens/splash/splash_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/dashboard/dashboard_screen.dart';
import '../screens/monitoring/live_monitoring_screen.dart';
import '../screens/heater/heater_control_screen.dart';
import '../screens/alerts/alert_center_screen.dart';
import '../screens/alerts/notifications_screen.dart';
import '../screens/analytics/analytics_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/patient/add_patient_screen.dart';
import '../providers/auth_provider.dart';

class AppRouter {
  AppRouter._();

  static final rootNavigatorKey = GlobalKey<NavigatorState>();
  static final shellNavigatorKey = GlobalKey<NavigatorState>();

  static GoRouter createRouter(AuthProvider authProvider) {
    return GoRouter(
      navigatorKey: rootNavigatorKey,
      initialLocation: '/splash',
      refreshListenable: authProvider,
      redirect: (context, state) {
        final isAuthenticated = authProvider.isAuthenticated;
        final isSplash = state.matchedLocation == '/splash';
        final isLogin = state.matchedLocation == '/login';

        if (isSplash) return null;

        if (!isAuthenticated && !isLogin) {
          return '/login';
        }

        if (isAuthenticated && isLogin) {
          return '/dashboard';
        }

        return null;
      },
      routes: [
        GoRoute(
          path: '/splash',
          builder: (context, state) => const SplashScreen(),
        ),
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginScreen(),
        ),
        StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) {
            return MainShell(navigationShell: navigationShell);
          },
          branches: [
            // Dashboard Branch
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/dashboard',
                  builder: (context, state) => const DashboardScreen(),
                ),
              ],
            ),
            // Alerts Branch
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/alerts',
                  builder: (context, state) => const AlertCenterScreen(),
                ),
              ],
            ),
            // Analytics Branch
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/analytics',
                  builder: (context, state) => const AnalyticsScreen(),
                ),
              ],
            ),
            // Profile Branch
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/profile',
                  builder: (context, state) => const ProfileScreen(),
                ),
              ],
            ),
          ],
        ),
        // Details routes outside shell
        GoRoute(
          path: '/monitoring/:id',
          parentNavigatorKey: rootNavigatorKey,
          builder: (context, state) {
            final id = state.pathParameters['id']!;
            return LiveMonitoringScreen(patientId: id);
          },
        ),
        GoRoute(
          path: '/heater/:id',
          parentNavigatorKey: rootNavigatorKey,
          builder: (context, state) {
            final id = state.pathParameters['id']!;
            return HeaterControlScreen(patientId: id);
          },
        ),
        GoRoute(
          path: '/notifications',
          parentNavigatorKey: rootNavigatorKey,
          builder: (context, state) => const NotificationsScreen(),
        ),
        GoRoute(
          path: '/add-patient',
          parentNavigatorKey: rootNavigatorKey,
          builder: (context, state) => const AddPatientScreen(),
        ),
      ],
    );
  }
}
