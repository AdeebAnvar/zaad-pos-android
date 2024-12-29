import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:pos_app/presentation/screens/dashboard/credit_sales.dart';
import 'package:pos_app/presentation/screens/dashboard/crm.dart';
import 'package:pos_app/presentation/screens/dashboard/day_closing.dart';
import 'package:pos_app/presentation/screens/dashboard/payback_screen.dart';
import 'package:pos_app/presentation/screens/dashboard/recent_sales.dart';
import 'package:pos_app/presentation/screens/dashboard/sale_window.dart';
import 'package:pos_app/widgets/custom_drawer_widget.dart';

import '../../../../constatnts/colors.dart';
import '../../../../constatnts/styles.dart';

import '../../../../data/models/category_model.dart';
import '../../../../data/models/item_model.dart';
import '../../../../widgets/category_button.dart';
import '../../../../widgets/custom_textfield.dart';
import '../../../../widgets/suggestion_box.dart';
import '../../../logic/dashboard_logic.dart/dashboard_bloc.dart';
import '../cart.dart';

List<String> suggestions = <String>[];

List<String> burgerItems = <String>['Juicy Lucy', 'Onion Burger', 'Bison Burger', 'Butter Burger', 'Elk Burger', 'Green Chile', 'Cheeseburger', 'Pimento Cheeseburger'];
List<String> shawarmaItems = <String>[
  'Chicken Shawarma Deluxe',
  'Beef Shawarma Supreme',
  'Lamb Shawarma Wrap',
  'Spicy Chicken Shawarma',
  'Garlic Beef Shawarma',
  'Classic Lamb Shawarma',
  'Falafel Shawarma',
  'Veggie Shawarma',
  'DelightMixed',
  'Meat Shawarma',
  'BBQ Chicken Shawarma'
];

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  static String route = '/home';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  TextEditingController searchQueryController = TextEditingController();
  List<CategoryModel> categoryList = <CategoryModel>[];
  List<ProductModel> itemsList = <ProductModel>[];
  int? selectedItemId;
  bool isLoading = false;
  bool isAnimating = false;
  int selectedDrawerIndex = 1;
  DashBoardBloc _dashBoardBloc = DashBoardBloc();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  List<Widget> screens = [
    Container(),
    CrmScreen(),
    SaleWindowScreen(),
    RecentSalesHistory(),
    CreditSalesHistory(),
    DayClosingScreen(),
    Container(),
    PaybackScreen(),
  ];

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
        if (state is SyncProductsLoadingState) {
          isAnimating = state.isAnimating;
        }
        if (state is SyncProductsSuccessState) {
          isAnimating = state.isAnimating;
        }
      },
      builder: (context, state) {
        return Scaffold(
          drawerEnableOpenDragGesture: false,
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
          body: Scaffold(
              appBar: AppBar(
                backgroundColor: AppColors.primaryColor,
                toolbarHeight: 70,
                actions: [
                  AnimatedCrossFade(
                    firstChild: Text(""),
                    secondChild: Text(
                      "Syncing...",
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
                        _dashBoardBloc.add(SyncProductsEvent());
                        await Future.delayed(const Duration(seconds: 10), () {
                          if (mounted) {
                            _controller.stop();
                          }
                        });
                      },
                      icon: Icon(
                        Icons.sync,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
                leading: InkWell(
                  onTap: () => scaffoldKey.currentState?.openDrawer(),
                  child: Hero(
                    tag: 'assets/images/png/logo.png',
                    child: Padding(
                      padding: const EdgeInsets.all(7.0),
                      child: Image.asset(
                        height: 45,
                        width: 45,
                        'assets/images/png/logo.png',
                      ),
                    ),
                  ),
                ),
              ),
              body: screens[selectedDrawerIndex]),
        );
      },
    );
  }

  OverlayEntry _overlayEntry() {
    return OverlayEntry(builder: (BuildContext c) {
      return Container(
        height: 100,
        width: 100,
        color: Colors.red,
      );
    });
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
                    hint: "Cash",
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      num amount = num.parse(value ?? "0");
                      if (amount < 500) {
                        return "Enter amount above 500";
                      }
                      return null;
                    },
                    fillColor: Colors.transparent,
                    border: OutlineInputBorder(borderSide: BorderSide(color: AppColors.primaryColor)),
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

class ItemCard extends StatelessWidget {
  const ItemCard({
    super.key,
    required this.item,
  });

  final String item;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 13),
      margin: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            blurRadius: 8,
            color: Colors.black26,
            spreadRadius: 0.1,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            item,
            style: AppStyles.getRegularTextStyle(fontSize: 13),
          ),
          Text(
            'AED 200',
            style: AppStyles.getRegularTextStyle(fontSize: 13),
          ),
        ],
      ),
    );
  }
}
