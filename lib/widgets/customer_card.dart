import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pos_app/constatnts/styles.dart';
import 'package:pos_app/data/models/customer_model.dart';
import 'package:pos_app/presentation/screens/dashboard/customer_details.dart';

import '../constatnts/colors.dart';

class CustomerCard extends StatelessWidget {
  final CustomerModel customerModel;
  const CustomerCard({
    super.key,
    required this.customerModel,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.pushNamed(CustomerDetailsScreen.route, extra: {"data": customerModel}),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(3),
        ),
        color: Colors.white,
        surfaceTintColor: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: ListTile(
            title: Text(
              customerModel.customerName ?? "",
              style: AppStyles.getMediumTextStyle(fontSize: 14),
            ),
            subtitle: Text(
              customerModel.mobileNumber ?? "",
              style: AppStyles.getRegularTextStyle(fontSize: 14),
            ),
            leading: CircleAvatar(
              backgroundColor: AppColors.primaryColor,
              child: Center(
                child: Icon(
                  Icons.person,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
