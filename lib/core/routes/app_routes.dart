import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/splash/presentation/screens/splash_screen.dart';
import '../../features/onboarding/presentation/screens/onboarding_screen.dart';
import '../../features/home/presentation/screens/main_navigation_screen.dart';
import '../../features/services/presentation/screens/services_screen.dart';
import '../../features/services/presentation/screens/service_detail_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/signup_screen.dart';
import '../../features/auth/presentation/screens/auth_gate_screen.dart';
import '../../features/auth/presentation/screens/forgot_password_screen.dart';
import '../../features/home/presentation/screens/project_detail_screen.dart';
import '../../features/home/presentation/screens/payments_screen.dart';
import '../../features/home/presentation/screens/live_chat_screen.dart';
import '../../features/home/presentation/screens/notifications_screen.dart';

class AppRoutes {
  AppRoutes._();

  static const String splash = '/splash';
  static const String onboarding = '/onboarding';
  static const String authGate = '/auth-gate';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String forgotPassword = '/forgot-password';
  static const String home = '/';
  static const String services = '/services';
  static const String serviceDetail = '/services/:id';
  static const String projectDetail = '/project/:id';
  static const String payments = '/payments';
  static const String chat = '/chat';
  static const String notifications = '/notifications';

  static final GoRouter router = GoRouter(
    initialLocation: splash,
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: authGate,
        builder: (context, state) => const AuthGateScreen(),
      ),
      GoRoute(
        path: login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: signup,
        builder: (context, state) => const SignupScreen(),
      ),
      GoRoute(
        path: forgotPassword,
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: home,
        builder: (context, state) => const MainNavigationScreen(),
      ),
      GoRoute(
        path: services,
        builder: (context, state) => const ServicesScreen(),
      ),
      GoRoute(
        path: serviceDetail,
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return ServiceDetailScreen(serviceId: id);
        },
      ),
      GoRoute(
        path: projectDetail,
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return ProjectDetailScreen(projectId: id);
        },
      ),
      GoRoute(
        path: payments,
        builder: (context, state) => const PaymentsScreen(),
      ),
      GoRoute(
        path: chat,
        builder: (context, state) => const LiveChatScreen(),
      ),
      GoRoute(
        path: notifications,
        builder: (context, state) => const NotificationsScreen(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text(
          'Page not found: ${state.uri.path}',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    ),
  );
}
