import 'package:flutter/material.dart';
import 'package:pos_app/presentation/screens/dashboard/counter_sale/sale_window.dart';

class CounterSaleDashboard extends StatelessWidget {
  const CounterSaleDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: SaleWindowScreen(),
    );
  }
}
