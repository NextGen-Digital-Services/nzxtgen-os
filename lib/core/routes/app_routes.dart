import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/splash/presentation/screens/splash_screen.dart';
import '../../features/onboarding/presentation/screens/onboarding_screen.dart';
import '../../features/home/presentation/screens/main_navigation_screen.dart';
import '../../features/services/presentation/screens/services_screen.dart';
import '../../features/services/presentation/screens/service_detail_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/signup_screen.dart';

class AppRoutes {
  AppRoutes._();

  static const String splash = '/splash';
  static const String onboarding = '/onboarding';
  static const String home = '/';
  static const String services = '/services';
  static const String serviceDetail = '/services/:id';
  static const String login = '/login';
  static const String signup = '/signup';

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
        path: login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: signup,
        builder: (context, state) => const SignupScreen(),
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
