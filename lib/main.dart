import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/constatnts/colors.dart';
import 'package:pos_app/data/db/hive_db.dart';
import 'package:pos_app/logic/auth_logic/auth_bloc.dart';
import 'package:pos_app/logic/cart_logic/cart_bloc.dart';
import 'package:pos_app/logic/crm_logic/crm_bloc.dart';
import 'package:pos_app/logic/dashboard_logic.dart/dashboard_bloc.dart';
import 'package:pos_app/logic/sale_logic/sale_bloc.dart';

import 'presentation/routes/app_routes.dart' as route;

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveDb.initHive();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<DashBoardBloc>(
          create: (BuildContext context) => DashBoardBloc(),
        ),
        BlocProvider<CrmBloc>(
          create: (BuildContext context) => CrmBloc(),
        ),
        BlocProvider<AuthBloc>(
          create: (BuildContext context) => AuthBloc(),
        ),
        BlocProvider<SaleBloc>(
          create: (BuildContext context) => SaleBloc(),
        ),
        BlocProvider<CartBloc>(
          create: (BuildContext context) => CartBloc(),
        ),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'ZAAD POS',
        routerConfig: route.router,
        theme: ThemeData(
          primaryColor: AppColors.primaryColor,
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.transparent,
            surfaceTintColor: Colors.transparent,
            elevation: 0,
            iconTheme: IconThemeData(color: AppColors.primaryColor),
          ),
          dialogBackgroundColor: Colors.white,
          bottomSheetTheme: BottomSheetThemeData(
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.transparent,
          ),
          colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primaryColor),
          scaffoldBackgroundColor: AppColors.scaffoldColor,
          useMaterial3: true,
        ),
      ),
    );
  }
}
