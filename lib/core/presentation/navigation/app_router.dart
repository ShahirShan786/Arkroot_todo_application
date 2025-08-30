import 'package:arkroot_todo_app/core/presentation/pages/home/home_screen.dart';
import 'package:arkroot_todo_app/core/presentation/pages/login_screen.dart';
import 'package:arkroot_todo_app/core/presentation/pages/signup_screen.dart';
import 'package:arkroot_todo_app/core/presentation/pages/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:arkroot_todo_app/core/presentation/pages/dummy_screen.dart';
import 'package:arkroot_todo_app/core/presentation/utils/widget_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';

final GoRouter router = GoRouter(
  errorBuilder: (context, state) => const DummyScreen(text: "Error Screen"),
  redirect: (BuildContext context, GoRouterState state) {
    // Get current authentication state
    final user = FirebaseAuth.instance.currentUser;
    final isAuthenticated = user != null;

    if (state.fullPath == '/') {
      return null; 
    }

    // Define public routes (no auth required)
    final publicRoutes = ["/", "/login", "/signup", "/forgotPassword" , "/home" , "/splash"];

    // If user is not authenticated and trying to access protected route
    if (!isAuthenticated && !publicRoutes.contains(state.fullPath)) {
      return '/login';
    }

    // If user is authenticated and on login page, redirect to home
    if (isAuthenticated &&
        (state.fullPath == '/login' || state.fullPath == '/')) {
      return '/home';
    }

    // Allow navigation
    return null;
  },
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const SplashScreen();
      },
    ),
    
    GoRoute(
      path: '/login',
      pageBuilder:
          (context, state) => buildPageWithDefaultTransition<void>(
            context: context,
            state: state,
            child: const LoginScreen(),
          ),
    ),
    GoRoute(
      path: '/signup',
      pageBuilder:
          (context, state) => buildPageWithDefaultTransition<void>(
            context: context,
            state: state,
            child: const SignUpScreen(),
          ),
    ),
    GoRoute(
      path: '/forgotPassword',
      pageBuilder:
          (context, state) => buildPageWithDefaultTransition<void>(
            context: context,
            state: state,
            child: const DummyScreen(text: "Forgot Password Screen"),
          ),
    ),
    GoRoute(
      path: '/home',
      pageBuilder:
          (context, state) => buildPageWithDefaultTransition<void>(
            context: context,
            state: state,
            child: const HomeScreen(),
          ),
    ),
  ],
);
