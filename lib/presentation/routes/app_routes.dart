import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pos_app/presentation/screens/cart.dart';
import 'package:pos_app/presentation/screens/dashboard/dashboard.dart';
import '../screens/auth/login.dart';

GoRouter router = GoRouter(
  initialLocation: '/',
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      name: '/',
      pageBuilder: (BuildContext context, GoRouterState state) {
        return getCustomTransition(
          state,
          const LoginScreen(),
        );
      },
    ),
    GoRoute(
      path: HomeScreen.route,
      name: HomeScreen.route,
      pageBuilder: (BuildContext context, GoRouterState state) {
        return getCustomTransition(
          state,
          const HomeScreen(),
        );
      },
    ),
    GoRoute(
      path: CartView.route,
      name: CartView.route,
      pageBuilder: (BuildContext context, GoRouterState state) {
        return getCustomTransition(
          state,
          const CartView(),
        );
      },
    ),
  ],
);

CustomTransitionPage<dynamic> getCustomTransition(GoRouterState state, Widget child) {
  return CustomTransitionPage<dynamic>(
    transitionDuration: const Duration(milliseconds: 400),
    key: state.pageKey,
    child: child,
    transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
      return CupertinoPageTransition(
        primaryRouteAnimation: animation,
        secondaryRouteAnimation: secondaryAnimation,
        linearTransition: true,
        child: child,
      );
    },
  );
}
