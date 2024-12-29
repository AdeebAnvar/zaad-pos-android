// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:pos_app/constatnts/colors.dart';
import 'package:pos_app/constatnts/styles.dart';

class CustomDrawerWidget extends StatelessWidget {
  const CustomDrawerWidget({super.key, this.index = 1, required this.onClick});
  final int index;
  final void Function(int? index) onClick;
  @override
  Widget build(BuildContext context) {
    List<DrawerButton> drawerButtons = [
      DrawerButton(icon: Icons.home, title: "Opening Balance"),
      DrawerButton(icon: Icons.home, title: "CRM"),
      DrawerButton(icon: Icons.home, title: "Sale Window"),
      DrawerButton(icon: Icons.home, title: "Recent Sales"),
      DrawerButton(icon: Icons.home, title: "Credit Sales"),
      DrawerButton(icon: Icons.home, title: "Day Closing"),
      DrawerButton(icon: Icons.home, title: "Expense"),
      DrawerButton(icon: Icons.home, title: "Pay Back"),
    ];
    return Container(
      width: MediaQuery.sizeOf(context).width / 1.5,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(15),
            bottomRight: Radius.circular(15),
          )),
      padding: EdgeInsets.only(top: 84, left: 14, right: 14, bottom: 14),
      child: Column(children: [
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
                      Icon(color: e.key == index ? Colors.white : null, e.value.icon),
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
        AnimatedContainer(
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
        )
      ]),
    );
  }
}

class DrawerButton {
  String title;
  IconData icon;
  Widget? navigateTo;
  DrawerButton({
    required this.title,
    required this.icon,
    this.navigateTo,
  });
}
