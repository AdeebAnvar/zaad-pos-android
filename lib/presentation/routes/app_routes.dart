import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pos_app/data/models/customer_model.dart';
import 'package:pos_app/main.dart';
import 'package:pos_app/presentation/screens/cart_screen.dart';
import 'package:pos_app/presentation/screens/dashboard/admin/categories_screen.dart';
import 'package:pos_app/presentation/screens/dashboard/admin/create_item.dart';
import 'package:pos_app/presentation/screens/dashboard/admin/item_screen.dart';
import 'package:pos_app/presentation/screens/dashboard/counter_sale/customer_details.dart';
import 'package:pos_app/presentation/screens/dashboard/counter_sale_dashboard.dart';
import 'package:pos_app/presentation/screens/dashboard/main_dashboard.dart';
import 'package:pos_app/presentation/screens/dashboard/super_admin/branch_listing_screen.dart';
import 'package:pos_app/presentation/screens/dashboard/super_admin/create_branch.dart';
import 'package:pos_app/presentation/screens/dashboard/super_admin/create_user_screen.dart';
import 'package:pos_app/presentation/screens/dashboard/super_admin/users_permissions.dart';
import 'package:pos_app/widgets/cart_items_des.dart';
import '../screens/auth/login.dart';

GoRouter router = GoRouter(
  initialLocation: '/',
  navigatorKey: navigatorKey,
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      name: '/',
      pageBuilder: (BuildContext context, GoRouterState state) {
        return getCustomTransition(
          state,
          LoginScreen(),
        );
      },
    ),
    GoRoute(
      path: CounterSaleDashBoardScreen.route,
      name: CounterSaleDashBoardScreen.route,
      pageBuilder: (BuildContext context, GoRouterState state) {
        return getCustomTransition(
          state,
          const CounterSaleDashBoardScreen(),
        );
      },
    ),
    GoRoute(
      path: MainDashboard.route,
      name: MainDashboard.route,
      pageBuilder: (BuildContext context, GoRouterState state) {
        return getCustomTransition(
          state,
          const MainDashboard(),
        );
      },
    ),
    GoRoute(
      path: BranchListingScreen.route,
      name: BranchListingScreen.route,
      pageBuilder: (BuildContext context, GoRouterState state) {
        return getCustomTransition(
          state,
          const BranchListingScreen(),
        );
      },
    ),
    GoRoute(
      path: CreateBranchScreen.route,
      name: CreateBranchScreen.route,
      pageBuilder: (BuildContext context, GoRouterState state) {
        return getCustomTransition(
          state,
          const CreateBranchScreen(),
        );
      },
    ),
    GoRoute(
      path: UsersAndPermissions.route,
      name: UsersAndPermissions.route,
      pageBuilder: (BuildContext context, GoRouterState state) {
        return getCustomTransition(
          state,
          const UsersAndPermissions(),
        );
      },
    ),
    GoRoute(
      path: CreateUserScreen.route,
      name: CreateUserScreen.route,
      pageBuilder: (BuildContext context, GoRouterState state) {
        return getCustomTransition(
          state,
          const CreateUserScreen(),
        );
      },
    ),
    GoRoute(
      path: CreateItemScreen.route,
      name: CreateItemScreen.route,
      pageBuilder: (BuildContext context, GoRouterState state) {
        return getCustomTransition(
          state,
          const CreateItemScreen(),
        );
      },
    ),
    GoRoute(
      path: ItemsScreen.route,
      name: ItemsScreen.route,
      pageBuilder: (BuildContext context, GoRouterState state) {
        return getCustomTransition(
          state,
          const ItemsScreen(),
        );
      },
    ),
    GoRoute(
      path: CategoriesScreen.route,
      name: CategoriesScreen.route,
      pageBuilder: (BuildContext context, GoRouterState state) {
        return getCustomTransition(
          state,
          const CategoriesScreen(),
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
      path: CartItemsDes.route,
      name: CartItemsDes.route,
      pageBuilder: (BuildContext context, GoRouterState state) {
        return getCustomTransition(
          state,
          const CartItemsDes(),
        );
      },
    ),
    GoRoute(
      path: LoginScreen.route,
      name: LoginScreen.route,
      pageBuilder: (BuildContext context, GoRouterState state) {
        return getCustomTransition(
          state,
          LoginScreen(),
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
