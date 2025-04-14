import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:pos_app/constatnts/colors.dart';
import 'package:pos_app/constatnts/styles.dart';
import 'package:pos_app/data/db/hive_db.dart';
import 'package:pos_app/presentation/screens/auth/login.dart';
import 'package:pos_app/widgets/custom_button.dart';
import 'package:pos_app/widgets/custom_dialogue.dart';

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
      DrawerButton(icon: "assets/images/svg/settings.svg", title: "Settings"),
    ];

    return Container(
      width: MediaQuery.of(context).size.width.clamp(250.0, 350.0),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(15),
          bottomRight: Radius.circular(15),
        ),
      ),
      padding: const EdgeInsets.only(top: 28, left: 14, right: 14, bottom: 14),
      child: Column(
        children: [
          Hero(
            tag: 'assets/images/png/appicon2.webp',
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
                  'assets/images/png/appicon2.webp',
                ),
              ),
            ),
          ),
          const SizedBox(height: 30),

          ...drawerButtons.asMap().entries.map(
                (e) => DrawerItem(
                  icon: e.value.icon,
                  title: e.value.title,
                  isSelected: e.key == index,
                  onTap: () {
                    onClick(e.key);
                  },
                ),
              ),

          const Spacer(),

          // Logout Button
          DrawerItem(
            icon: "", // we'll use an Icon widget instead
            title: "Logout",
            isSelected: false,
            iconWidget: const Icon(Icons.power_settings_new_rounded, color: Colors.white),
            onTap: () async {
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
            },
            backgroundColor: AppColors.primaryColor,
            textColor: Colors.white,
          )
        ],
      ),
    );
  }
}

class DrawerButton {
  final String title;
  final String icon;
  final Widget? navigateTo;

  DrawerButton({required this.title, required this.icon, this.navigateTo});
}

class DrawerItem extends StatelessWidget {
  final String title;
  final String icon;
  final bool isSelected;
  final VoidCallback onTap;
  final Color? backgroundColor;
  final Color? textColor;
  final Widget? iconWidget;

  const DrawerItem({
    Key? key,
    required this.title,
    required this.icon,
    required this.isSelected,
    required this.onTap,
    this.backgroundColor,
    this.textColor,
    this.iconWidget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bgColor = backgroundColor ?? (isSelected ? AppColors.primaryColor : null);
    final fgColor = textColor ?? (isSelected ? Colors.white : AppColors.textColor);

    return InkWell(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.all(5),
        height: 50,
        padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 8),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            iconWidget ??
                SvgPicture.asset(
                  icon,
                  height: 30,
                  width: 30,
                  color: fgColor,
                ),
            const SizedBox(width: 18),
            Text(
              title,
              style: AppStyles.getMediumTextStyle(fontSize: 14, color: fgColor),
            ),
          ],
        ),
      ),
    );
  }
}
