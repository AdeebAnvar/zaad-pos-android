import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pos_app/constatnts/colors.dart';
import 'package:pos_app/data/db/hive_db.dart';
import 'package:pos_app/presentation/screens/auth/login.dart';
import 'package:pos_app/widgets/custom_button.dart';
import 'package:pos_app/widgets/custom_dialogue.dart';

class AppFunctions {
  static Future<void> logout(BuildContext context) async {
    CustomDialog.showResponsiveDialog(
      context,
      title: 'Confirm Logout',
      Column(
        children: [
          const Text('Are you sure you want to logout?'),
          SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
            child: Row(
              children: [
                Expanded(
                    child: CustomResponsiveButton(
                        height: 40,
                        textColor: AppColors.textColor,
                        elevation: 0,
                        backgroundColor: Colors.transparent,
                        onPressed: () => Navigator.pop(context, false),
                        text: 'Cancel')),
                SizedBox(width: 8),
                Expanded(
                  child: CustomResponsiveButton(
                    height: 40,
                    onPressed: () async {
                      context.goNamed(LoginScreen.route);
                      await HiveDb.clearDb();
                    },
                    text: 'Logout',
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
