// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:pos_app/constatnts/colors.dart';
import 'package:pos_app/constatnts/styles.dart';
import 'package:pos_app/data/db/hive_db.dart';
import 'package:pos_app/presentation/screens/auth/login.dart';

class CustomDrawerWidget extends StatelessWidget {
  const CustomDrawerWidget({super.key, this.index = 1, required this.onClick});
  final int index;
  final void Function(int? index) onClick;
  @override
  Widget build(BuildContext context) {
    List<DrawerButton> drawerButtons = [
      DrawerButton(icon: "assets/images/svg/openingbal.svg", title: "Opening Balance"),
      DrawerButton(icon: "assets/images/svg/CRM.svg", title: "CRM"),
      DrawerButton(icon: "assets/images/svg/sale.svg", title: "Sale Window"),
      // DrawerButton(icon: "assets/images/svg/report.svg", title: "Recent Sales"),
      // DrawerButton(icon: "assets/images/svg/credit.svg", title: "Credit Sales"),
      // DrawerButton(icon: "assets/images/svg/units.svg", title: "Day Closing"),
      // DrawerButton(icon: "assets/images/svg/expenses.svg", title: "Expense"),
      // DrawerButton(icon: "assets/images/svg/performance_report.svg", title: "Pay Back"),
    ];
    return Container(
      width: MediaQuery.sizeOf(context).width / 1.5,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(15),
            bottomRight: Radius.circular(15),
          )),
      padding: EdgeInsets.only(top: 28, left: 14, right: 14, bottom: 14),
      child: Column(children: [
        Hero(
          tag: 'assets/images/png/logo.png',
          child: Padding(
            padding: const EdgeInsets.all(7.0),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Image.asset(
                height: 45,
                width: 45,
                'assets/images/png/logo.png',
              ),
            ),
          ),
        ),
        SizedBox(height: 30),
        ...drawerButtons.asMap().entries.map((e) => InkWell(
              onTap: () {
                onClick(e.key);
                print(e.key);
              },
              child: AnimatedContainer(
                duration: Duration(milliseconds: 900),
                margin: EdgeInsets.all(5),
                height: 50,
                padding: EdgeInsets.symmetric(horizontal: 17, vertical: 8),
                decoration: BoxDecoration(color: e.key == index ? AppColors.primaryColor : null, borderRadius: BorderRadius.circular(10)),
                child: Center(
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        e.value.icon,
                        height: 30,
                        color: e.key == index ? Colors.white : AppColors.textColor,
                        width: 30,
                      ),
                      SizedBox(width: 18),
                      Text(
                        e.value.title,
                        style: AppStyles.getMediumTextStyle(fontSize: 14, color: e.key == index ? Colors.white : null),
                      ),
                    ],
                  ),
                ),
              ),
            )),
        Spacer(),
        InkWell(
          onTap: () {
            HiveDb.clearDb();
            context.goNamed(LoginScreen.route);
          },
          child: AnimatedContainer(
            duration: Duration(milliseconds: 800),
            margin: EdgeInsets.all(5),
            height: 50,
            padding: EdgeInsets.symmetric(horizontal: 17, vertical: 8),
            decoration: BoxDecoration(color: AppColors.primaryColor, borderRadius: BorderRadius.circular(10)),
            child: Center(
              child: Row(
                children: [
                  Icon(color: Colors.white, Icons.power_settings_new_rounded),
                  SizedBox(width: 18),
                  Text(
                    "Logout",
                    style: AppStyles.getMediumTextStyle(fontSize: 14, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        )
      ]),
    );
  }
}

class DrawerButton {
  String title;
  String icon;
  Widget? navigateTo;
  DrawerButton({
    required this.title,
    required this.icon,
    this.navigateTo,
  });
}
