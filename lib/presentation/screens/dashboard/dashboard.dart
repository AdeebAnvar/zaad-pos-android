import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pos_app/constatnts/enums.dart';
import 'package:pos_app/logic/dashboard_logic.dart/dashboard_bloc.dart';
import 'package:pos_app/presentation/screens/auth/login.dart';
import 'package:pos_app/presentation/screens/dashboard/credit_sales.dart';
import 'package:pos_app/presentation/screens/dashboard/crm.dart';
import 'package:pos_app/presentation/screens/dashboard/day_closing.dart';
import 'package:pos_app/presentation/screens/dashboard/payback_screen.dart';
import 'package:pos_app/presentation/screens/dashboard/recent_sales.dart';
import 'package:pos_app/presentation/screens/dashboard/sale_window.dart';
import 'package:pos_app/widgets/custom_drawer_widget.dart';
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
    const CrmScreen(),
    const SaleWindowScreen(),
    const RecentSalesHistory(),
    const CreditSalesHistory(),
    const DayClosingScreen(),
    Container(),
    const PaybackScreen(),
  ];

  final screenTitles = ['', 'CRM', 'Sale', 'Sale History', 'Credit Sales History', 'Day Closing', '', 'Pay Back'];

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

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DashBoardBloc, DashBoardState>(
      bloc: _dashBoardBloc,
      listener: (context, state) {
        if (state is DashBoardSuccessState) {
          selectedDrawerIndex = state.index;
        }
        if (state is SyncDataLoadingState) {
          isAnimating = state.isAnimating;
        }
        if (state is SyncDataSuccessState) {
          isAnimating = state.isAnimating;
          customSnackBar(context, "Data Loaded Please Refresh the screen");
          _controller.stop();
        }
      },
      builder: (context, state) {
        return Scaffold(
            appBar: AppBar(
              title: Text(
                screenTitles[selectedDrawerIndex].toString(),
                style: AppStyles.getSemiBoldTextStyle(fontSize: 16, color: Colors.white),
              ),
              backgroundColor: AppColors.primaryColor,
              toolbarHeight: 70,
              actions: [
                AnimatedCrossFade(
                  firstChild: Text(""),
                  secondChild: Text(
                    CurrentScreen.fromIndex(selectedDrawerIndex).syncMessage,
                    style: AppStyles.getSemiBoldTextStyle(fontSize: 14, color: Colors.white),
                  ),
                  crossFadeState: isAnimating ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                  duration: Duration(
                    milliseconds: 800,
                  ),
                ),
                RotationTransition(
                  turns: _controller,
                  child: IconButton(
                    onPressed: () async {
                      _controller.repeat();
                      _dashBoardBloc.add(
                        SyncDataEvent(screen: CurrentScreen.fromIndex(selectedDrawerIndex)),
                      );
                    },
                    icon: Icon(
                      Icons.sync,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
              leading: InkWell(onTap: () => scaffoldKey.currentState?.openDrawer(), child: Icon(Icons.menu, color: Colors.white)),
            ),
            key: scaffoldKey,
            drawer: CustomDrawerWidget(
              index: selectedDrawerIndex,
              onClick: (i) {
                context.pop();
                if (i == 0) {
                  showOpeningBalanceSheet(context);
                } else if (i == 7) {
                  showOpeningBalanceSheet(context);
                } else {
                  _dashBoardBloc.add(DashbBoardChangeIndexDrawer(index: i!));
                }
              },
            ),
            body: screens[selectedDrawerIndex]);
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
