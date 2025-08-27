import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pos_app/constatnts/common_functions.dart';
import 'package:pos_app/presentation/screens/dashboard/admin/categories_screen.dart';
import 'package:pos_app/presentation/screens/dashboard/admin/create_item.dart';
import 'package:pos_app/presentation/screens/dashboard/admin/item_screen.dart';
import 'package:pos_app/presentation/screens/dashboard/super_admin/super_admin_dashboard.dart';

class AdminDashBoard extends StatelessWidget {
  const AdminDashBoard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () async => await AppFunctions.logout(context),
              icon: Icon(
                Icons.logout,
                color: Colors.white,
              ))
        ],
      ),
      body: GridView(
        padding: EdgeInsets.all(12),
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 405,
          mainAxisExtent: 160,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        children: [
          AdminCardWidget(onTap: () => context.pushNamed(ItemsScreen.route), title: "Items"),
          AdminCardWidget(onTap: () => context.pushNamed(CategoriesScreen.route), title: "Categories"),
        ],
      ),
    );
  }
}
