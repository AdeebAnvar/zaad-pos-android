import 'package:flutter/material.dart';
import 'package:pos_app/constatnts/enums.dart';
import 'package:pos_app/data/db/user_db.dart';
import 'package:pos_app/data/models/user_models.dart';
import 'package:pos_app/presentation/screens/dashboard/admin/admin_dashboard.dart';
import 'package:pos_app/presentation/screens/dashboard/branch_admin/branch_admin_dashboard.dart';
import 'package:pos_app/presentation/screens/dashboard/counter_sale/counter_sale_dashboard.dart';
import 'package:pos_app/presentation/screens/dashboard/counter_sale_dashboard.dart';
import 'package:pos_app/presentation/screens/dashboard/super_admin/super_admin_dashboard.dart';

class MainDashboard extends StatelessWidget {
  const MainDashboard({super.key});
  static String route = '/main';
  @override
  Widget build(BuildContext context) {
    UserModel? userModel = UserDb.getUserFromLocal();
    print(UserType.superAdmin);
    return userModel?.type == UserType.superAdmin.value
        ? SuperAdminDashBoard()
        : userModel?.type == UserType.mainAdmin.value || userModel?.type == UserType.branchAdmin.value
            ? AdminDashBoard()
            : userModel?.type == UserType.counterSales.value
                ? CounterSaleDashBoardScreen()
                : Scaffold(
                    body: Center(
                      child: Text('MAIN'),
                    ),
                  );
  }
}
