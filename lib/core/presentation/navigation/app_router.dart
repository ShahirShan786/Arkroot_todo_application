import 'package:arkroot_todo_app/core/presentation/pages/home_screen.dart';
import 'package:arkroot_todo_app/core/presentation/pages/login_screen.dart';
import 'package:arkroot_todo_app/core/presentation/pages/signup_screen.dart';
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

    // Define public routes (no auth required)
    final publicRoutes = ["/", "/login", "/signup", "/forgotPassword" , "/home"];

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
        return const LoginScreen();
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

// import 'dart:math';

// import 'package:arkroot_todo_app/core/presentation/pages/login_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:arkroot_todo_app/core/presentation/pages/dummy_screen.dart';

// import 'package:arkroot_todo_app/core/presentation/utils/widget_helper.dart';

// import 'package:go_router/go_router.dart';

// final GoRouter router = GoRouter(
//   errorBuilder: (context, state) => const DummyScreen(text: "Error Screen"),
//   redirect: (BuildContext context, GoRouterState state) {
//     if (![
//       "/home",
//       "/signin",
//       "/forgotPassword",
//       "/signup",
//       "/sample",
//       "/login"
//     ].contains(state.fullPath)) {
//       // if any routes which needs auth, check for auth
//       bool auth = Random().nextBool();
//       if (!auth) {
//         // if not authenticated, show signin screen
//         return '/login';
//       } else {
//         // if authenticated, proceed
//         return null;
//       }
//     } else {
//       // for any screens which not need auth, proceed
//       return null;
//     }
//   },
//   routes: <RouteBase>[
//     GoRoute(
//       path: '/',
//       builder: (BuildContext context, GoRouterState state) {
//         return const LoginScreen();
//       },
//       routes: <RouteBase>[
//         // GoRoute(
//         //   path: 'signin',
//         //   pageBuilder:
//         //       (context, state) => buildPageWithDefaultTransition<void>(
//         //         context: context,
//         //         state: state,
//         //         child: const SigninScreen(),
//         //       ),
//         // ),
//         GoRoute(
//           path: 'forgotPassword',
//           pageBuilder:
//               (context, state) => buildPageWithDefaultTransition<void>(
//                 context: context,
//                 state: state,
//                 child: const DummyScreen(text: "Forgot Password Screen"),
//               ),
//         ),
//         GoRoute(
//           path: 'home',
//           pageBuilder:
//               (context, state) => buildPageWithDefaultTransition<void>(
//                 context: context,
//                 state: state,
//                 child: const DummyScreen(text: "Home Screen"),
//               ),
//         ),
//         GoRoute(
//           path: 'login',
//           pageBuilder:
//               (context, state) => buildPageWithDefaultTransition<void>(
//                 context: context,
//                 state: state,
//                 child: const LoginScreen(),
//               ),
//         ),
//       ],
//     ),
//   ],
// );
