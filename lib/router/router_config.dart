import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:weather_buddy/router/router_constants.dart';
import 'package:weather_buddy/screens/dashboard_screen.dart';
import 'package:weather_buddy/screens/home_screen.dart';
import 'package:weather_buddy/screens/login_screen.dart';
import 'package:weather_buddy/screens/onboarding.dart';
import 'package:weather_buddy/screens/signup_screen.dart';

class MyAppRouter {
  final _secureStorage = const FlutterSecureStorage();

  late final GoRouter router = GoRouter(
    initialLocation: '/',
    redirect: (context, state) async {
      final token = await _secureStorage.read(key: "auth_token");
      final isLoggedIn = token != null;
      final isOnLogin = state.matchedLocation == '/login';
      final isOnSignup = state.matchedLocation == '/signup';
      if (!isLoggedIn && !isOnLogin && !isOnSignup) {
        return '/login';
      } else if (isLoggedIn && (isOnLogin || isOnSignup)) {
        return '/home';
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/home',
        name: MyAppConstants().homeRoute,
        pageBuilder: (context, state) {
          return MaterialPage(child: HomeScreen());
        },
      ),

      GoRoute(
        path: '/',
        name: MyAppConstants().onboardingroute,
        pageBuilder: (context, state) {
          return MaterialPage(child: StartupPage());
        },
      ),

      GoRoute(
        path: '/login',
        name: MyAppConstants().loginRoute,
        pageBuilder: (context, state) {
          return MaterialPage(child: LoginScreen());
        },
      ),

      GoRoute(
        path: '/signup',
        name: MyAppConstants().signUpRoute,
        pageBuilder: (context, state) {
          return MaterialPage(child: SignupScreen());
        },
      ),

      GoRoute(
        path: '/dashboard',
        name: MyAppConstants().dashboardroute,
        pageBuilder: (context, state) {
          return MaterialPage(child: DashboardScreen());
        },
      ),
    ],
  );
}
