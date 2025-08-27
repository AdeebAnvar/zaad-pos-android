import 'package:flutter/material.dart';
import 'package:pos_app/constatnts/colors.dart';
import 'package:pos_app/constatnts/common_functions.dart';
import 'package:pos_app/widgets/custom_drawer_widget.dart';

class CustomScaffold extends StatefulWidget {
  const CustomScaffold({
    super.key,
    this.scaffoldKey,
    required this.menuChildren,
    required this.mainChildren,
  });

  final Key? scaffoldKey;
  final List<Widget> menuChildren;
  final List<Widget> mainChildren;

  @override
  State<CustomScaffold> createState() => _CustomScaffoldState();
}

class _CustomScaffoldState extends State<CustomScaffold> with SingleTickerProviderStateMixin {
  bool isMenuOpen = false;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  void toggleMenu() {
    setState(() {
      isMenuOpen = !isMenuOpen;
      isMenuOpen ? _animationController.forward() : _animationController.reverse();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: widget.scaffoldKey,
      backgroundColor: AppColors.primaryColor,
      body: Row(
        children: [
          // Menu
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: isMenuOpen ? 250 : 50,
            height: MediaQuery.sizeOf(context).height,
            color: AppColors.primaryColor,
            child: Column(
              children: [
                Align(
                  alignment: isMenuOpen ? Alignment.topRight : Alignment.center,
                  child: IconButton(
                    onPressed: toggleMenu,
                    icon: AnimatedIcon(
                      icon: AnimatedIcons.menu_arrow,
                      progress: _animationController,
                      color: Colors.white,
                    ),
                  ),
                ),
                if (isMenuOpen) ...[
                  Expanded(
                    child: ListView(
                      shrinkWrap: true,
                      padding: const EdgeInsets.all(8),
                      children: widget.menuChildren,
                    ),
                  ),
                  DrawerItem(
                      title: "Logout",
                      iconWidget: Icon(
                        Icons.power_settings_new_sharp,
                        color: Colors.white,
                      ),
                      isSelected: true,
                      onTap: () => AppFunctions.logout(context))
                ]
              ],
            ),
          ),

          /// Main Content
          Expanded(
            child: Container(
              height: MediaQuery.sizeOf(context).height,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(7),
                  bottomLeft: Radius.circular(7),
                ),
                color: AppColors.scaffoldColor,
              ),
              child: ListView(
                shrinkWrap: true,
                primary: true,
                padding: const EdgeInsets.all(16),
                children: widget.mainChildren,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
