import 'dart:math' show max;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/constatnts/colors.dart' show AppColors;

import '../constatnts/styles.dart';
import '../data/models/cart_model.dart';
import '../logic/cart_logic/cart_bloc.dart';

class CartProductCard extends StatelessWidget {
  const CartProductCard({super.key, required this.cartItemModel});
  final CartItemModel cartItemModel;
  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 80,
      padding: const EdgeInsets.all(13),
      margin: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            blurRadius: 8,
            color: Colors.black26,
            spreadRadius: 0.1,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                cartItemModel.product.name ?? "",
                style: AppStyles.getSemiBoldTextStyle(fontSize: 13),
              ),
              SizedBox(height: 5),
              Text(
                'Unit Price AED ${cartItemModel.product.unitPrice}',
                style: AppStyles.getRegularTextStyle(fontSize: 11, color: Colors.grey.shade700),
              ),
              SizedBox(height: 5),
              Text(
                'Discount Price AED ${cartItemModel.product.discountPrice}',
                style: AppStyles.getRegularTextStyle(fontSize: 11, color: Colors.grey.shade700),
              ),
              SizedBox(height: 5),
              Text(
                'total price AED ${cartItemModel.totalPrice}',
                style: AppStyles.getSemiBoldTextStyle(fontSize: 11, color: Colors.grey.shade700),
              ),
            ],
          ),
          BlocBuilder<CartBloc, CartState>(
            builder: (context, state) {
              if (state is CartLoadedState) {
                // Find the item in the cart state
                final cartItem = state.cart.cartItems.firstWhere(
                  (item) => item.product.id == cartItemModel.product.id,
                  orElse: () => CartItemModel(product: cartItemModel.product, quantity: 0),
                );

                return Container(
                  height: 35,
                  width: 100,
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const [
                      BoxShadow(
                        blurRadius: 8,
                        color: Colors.black26,
                        spreadRadius: 0.1,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // Decrease quantity button
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            int newQuantity = max(1, cartItem.quantity - 1);
                            BlocProvider.of<CartBloc>(context).add(UpdateCartQuantityEvent(
                              product: cartItem.product,
                              quantity: newQuantity,
                            ));
                          },
                          child: Container(
                            decoration: BoxDecoration(color: AppColors.primaryColor),
                            child: Center(
                              child: Text(
                                '-',
                                style: AppStyles.getBoldTextStyle(fontSize: 15, color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Quantity display
                      Expanded(
                        flex: 2,
                        child: Container(
                          child: Center(
                            child: Text(
                              cartItem.quantity.toString(),
                              style: AppStyles.getRegularTextStyle(fontSize: 15),
                            ),
                          ),
                        ),
                      ),

                      // Increase quantity button
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            int newQuantity = cartItem.quantity + 1;
                            BlocProvider.of<CartBloc>(context).add(UpdateCartQuantityEvent(
                              product: cartItem.product,
                              quantity: newQuantity,
                            ));
                          },
                          child: Container(
                            decoration: BoxDecoration(color: AppColors.primaryColor),
                            child: Center(
                              child: Text(
                                '+',
                                style: AppStyles.getBoldTextStyle(fontSize: 15, color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }
              return SizedBox.shrink(); // Return an empty widget if cart is not loaded
            },
          )
        ],
      ),
    );
  }
}
