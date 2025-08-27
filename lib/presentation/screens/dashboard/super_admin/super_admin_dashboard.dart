import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pos_app/constatnts/colors.dart';
import 'package:pos_app/constatnts/common_functions.dart';
import 'package:pos_app/constatnts/styles.dart';
import 'package:pos_app/presentation/screens/dashboard/super_admin/branch_listing_screen.dart';
import 'package:pos_app/presentation/screens/dashboard/super_admin/users_permissions.dart';

class SuperAdminDashBoard extends StatelessWidget {
  const SuperAdminDashBoard({super.key});

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
            AdminCardWidget(onTap: () {}, title: "Software Settings"),
            AdminCardWidget(onTap: () => context.pushNamed(BranchListingScreen.route), title: "Manage Banches"),
            AdminCardWidget(onTap: () => context.pushNamed(UsersAndPermissions.route), title: "Users and Permissions"),
          ],
        ));
  }
}

class AdminCardWidget extends StatelessWidget {
  const AdminCardWidget({
    super.key,
    this.onTap,
    required this.title,
  });
  final void Function()? onTap;
  final String title;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: Colors.white,
        child: Row(
          children: [
            Image.asset('assets/images/png/appicon2.webp'),
            SizedBox(width: 10),
            Text(
              title,
              style: AppStyles.getSemiBoldTextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
