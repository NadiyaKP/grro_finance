import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/splash/view/splash_screen.dart';
import '../../features/auth/view/login_screen.dart';
import '../../features/home/view/home_screen.dart';
import '../../features/withdrawal/view/withdrawal_request_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/withdrawal-request',
      builder: (context, state) => const WithdrawalRequestScreen(),
    ),
  ],
);