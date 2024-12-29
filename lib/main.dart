import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/logic/dashboard_logic.dart/dashboard_bloc.dart';

import 'constatnts/colors.dart';

import 'presentation/routes/app_routes.dart' as route;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await DatabaseServices().database;
  // await ItemServices().createTable();
  // await CategoryServices().createTable();
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
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'ZAAD POS',
        routerConfig: route.router,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
      ),
    );
  }
}
