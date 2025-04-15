import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pos_app/constatnts/app_responsive.dart';
import 'package:pos_app/constatnts/enums.dart';
import 'package:pos_app/logic/dashboard_logic.dart/dashboard_bloc.dart';
import 'package:pos_app/presentation/screens/dashboard/crm.dart';
import 'package:pos_app/presentation/screens/dashboard/sale_window.dart';
import 'package:pos_app/presentation/screens/dashboard/settings_screen.dart';
import 'package:pos_app/widgets/custom_drawer_widget.dart';
import 'package:pos_app/widgets/custom_scaffold.dart';
import 'package:pos_app/widgets/custom_textfield.dart';

import '../../../../constatnts/colors.dart';
import '../../../../constatnts/styles.dart';

class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({super.key});
  static String route = '/dashboard';

  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  bool isAnimating = false;
  int selectedDrawerIndex = 2;
  final DashBoardBloc _dashBoardBloc = DashBoardBloc();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  final screens = [
    Container(),
    ResponsiveWrapper(child: CrmScreen()),
    SaleWindowScreen(),
    // ResponsiveWrapper(child: RecentSalesHistory()),
    // ResponsiveWrapper(child: CreditSalesHistory()),
    // ResponsiveWrapper(child: DayClosingScreen()),
    // Container(),
    // ResponsiveWrapper(child: PaybackScreen()),
    ResponsiveWrapper(child: SettingsScreen()),
  ];

  final screenTitles = ['', 'CRM', 'Sale', 'Settings'];

  @override
  void initState() {
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool isMenuOpen = false;
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return BlocConsumer<DashBoardBloc, DashBoardState>(
      bloc: _dashBoardBloc,
      listener: (context, state) {
        if (state is DashbBoardChangeIndexSuccessDrawer) {
          selectedDrawerIndex = state.index;
        }
      },
      builder: (context, state) {
        return AppResponsive.isDesktop(context)
            ? CustomScaffold(
                menuChildren: [
                  ...drawerButtons.asMap().entries.map(
                        (e) => DrawerItem(
                          textColor: e.key == selectedDrawerIndex ? AppColors.textColor : Colors.white,
                          icon: e.value.icon,
                          backgroundColor: e.key == selectedDrawerIndex ? Colors.white.withOpacity(0.8) : null,
                          title: e.value.title,
                          isSelected: e.key == selectedDrawerIndex,
                          onTap: () {
                            if (e.key == 0 || e.key == 7) {
                              showOpeningBalanceSheet(context);
                            } else {
                              _dashBoardBloc.add(DashbBoardChangeIndexDrawer(index: e.key!));
                            }
                          },
                        ),
                      )
                ],
                mainChildren: [
                  Text(
                    screenTitles[selectedDrawerIndex],
                    style: AppStyles.getSemiBoldTextStyle(fontSize: 22),
                  ),
                  SizedBox(height: 16),
                  screens[selectedDrawerIndex]
                ],
              )
            : Scaffold(
                key: scaffoldKey,
                appBar: AppBar(
                  title: Text(
                    screenTitles[selectedDrawerIndex],
                    style: AppStyles.getSemiBoldTextStyle(
                      fontSize: isMobile ? 14 : 18,
                      color: Colors.white,
                    ),
                  ),
                  backgroundColor: AppColors.primaryColor,
                  toolbarHeight: isMobile ? 60 : 70,
                  leading: InkWell(
                    onTap: () => scaffoldKey.currentState?.openDrawer(),
                    child: Icon(Icons.menu, color: Colors.white, size: isMobile ? 22 : 28),
                  ),
                ),
                drawer: CustomDrawerWidget(
                  index: selectedDrawerIndex,
                  onClick: (i) {
                    context.pop();
                    if (i == 0 || i == 7) {
                      showOpeningBalanceSheet(context);
                    } else {
                      _dashBoardBloc.add(DashbBoardChangeIndexDrawer(index: i!));
                    }
                  },
                ),
                body: LayoutBuilder(
                  builder: (context, constraints) {
                    return Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: isMobile ? 8.0 : 16.0,
                        vertical: isMobile ? 8.0 : 12.0,
                      ),
                      child: AnimatedContainer(duration: const Duration(milliseconds: 300), child: screens[selectedDrawerIndex]),
                    );
                  },
                ),
              );
      },
    );
  }

  void showOpeningBalanceSheet(BuildContext context) {
    TextEditingController openingCashController = TextEditingController(text: "500");
    GlobalKey<FormState> formKey = GlobalKey();
    showModalBottomSheet(
      backgroundColor: AppColors.scaffoldColor,
      isScrollControlled: true, // Add this
      context: context,
      builder: (c) {
        return Padding(
          padding: EdgeInsets.only(
            left: 18.0,
            right: 18.0,
            top: 18.0,
            bottom: MediaQuery.of(context).viewInsets.bottom + 18.0,
          ),
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "ENTER OPENING CASH",
                    style: AppStyles.getSemiBoldTextStyle(fontSize: 14),
                  ),
                  SizedBox(height: 15),
                  CustomTextField(
                    labelText: "Cash",
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    keyBoardType: TextInputType.number,
                    validator: (value) {
                      num amount = num.parse(value ?? "0");
                      if (amount < 500) {
                        return "Enter amount above 500";
                      }
                      return null;
                    },
                    fillColor: Colors.transparent,
                    controller: openingCashController,
                  ),
                  SizedBox(height: 15),
                  ElevatedButton(
                    onPressed: () {
                      if (!formKey.currentState!.validate()) {
                        return;
                      }
                      context.pop();
                    },
                    style: AppStyles.filledButton.copyWith(
                      fixedSize: WidgetStatePropertyAll(
                        Size(MediaQuery.sizeOf(context).width, 60),
                      ),
                    ),
                    child: Text("SAVE"),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class ResponsiveWrapper extends StatelessWidget {
  final Widget child;

  const ResponsiveWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: width < 600 ? 8.0 : 24.0),
      child: child,
    );
  }
}
