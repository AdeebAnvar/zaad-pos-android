import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/constatnts/styles.dart';
import 'package:pos_app/data/db/cart_db.dart';
import 'package:pos_app/data/models/cart_model.dart';
import 'package:pos_app/data/models/product_model.dart';
import 'package:pos_app/logic/cart_logic/cart_bloc.dart';
import 'package:pos_app/widgets/cart_product_Card.dart';
import 'package:pos_app/widgets/custom_button.dart';

class CartItemsDes extends StatelessWidget {
  const CartItemsDes({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 1000;

    return BlocConsumer<CartBloc, CartState>(
      listener: (context, s) {
        if (s is CartSubmittedState) {
          CartDb.clearCartDb();
        }
      },
      builder: (context, state) {
        if (state is CartLoadedState) {
          return Stack(
            children: [
              state.cart.cartItems.isEmpty
                  ? Center(
                      child: Text('No Items in Cart'),
                    )
                  : ListView(
                      children: [
                        ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          itemCount: state.cart.cartItems.length,
                          shrinkWrap: true,
                          itemBuilder: (context, i) {
                            return CartProductCard(cartItemModel: state.cart.cartItems[i]);
                          },
                        ),
                        SizedBox(height: 120)
                      ],
                    ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: isSmallScreen ? 120 : 100,
                  color: Colors.white,
                  padding: EdgeInsets.symmetric(
                    vertical: isSmallScreen ? 10 : 8,
                    horizontal: isSmallScreen ? 10 : 20,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Wrap(
                        spacing: 20,
                        runSpacing: 5,
                        alignment: WrapAlignment.center,
                        children: [
                          Text(
                            'Total Items : ${state.cart.cartItems.length}',
                            style: AppStyles.getMediumTextStyle(fontSize: isSmallScreen ? 11 : 14),
                          ),
                          // Text(
                          //   'Total Amount : 500',
                          //   style: AppStyles.getMediumTextStyle(fontSize: isSmallScreen ? 11 : 14),
                          // ),
                          Text(
                            'Net Amount : ${state.cart.totalCartPrice.toStringAsFixed(1)}',
                            style: AppStyles.getMediumTextStyle(fontSize: isSmallScreen ? 11 : 14),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: CustomResponsiveButton(height: 40, onPressed: () {}, text: "Submit"),
                      )
                    ],
                  ),
                ),
              )
            ],
          );
        }
        return Center(
          child: Text('No Items in Cart'),
        );
      },
    );
  }
}
