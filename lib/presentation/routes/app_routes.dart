import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pos_app/data/models/customer_model.dart';
import 'package:pos_app/presentation/screens/cart_screen.dart';
import 'package:pos_app/presentation/screens/dashboard/customer_details.dart';
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
      path: DashBoardScreen.route,
      name: DashBoardScreen.route,
      pageBuilder: (BuildContext context, GoRouterState state) {
        return getCustomTransition(
          state,
          const DashBoardScreen(),
        );
      },
    ),
    GoRoute(
      path: CustomerDetailsScreen.route,
      name: CustomerDetailsScreen.route,
      pageBuilder: (BuildContext context, GoRouterState state) {
        var data = state.extra as Map<String, dynamic>;
        return getCustomTransition(
          state,
          CustomerDetailsScreen(
            customerModel: data["data"] as CustomerModel,
          ),
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
