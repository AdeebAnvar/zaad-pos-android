import 'dart:math' show max;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/constatnts/colors.dart' show AppColors;
import 'package:pos_app/widgets/custom_snackbar.dart';

import '../constatnts/styles.dart';
import '../data/models/cart_model.dart';
import '../logic/cart_logic/cart_bloc.dart';

class CartProductCard extends StatelessWidget {
  const CartProductCard({super.key, required this.cartItemModel});
  final CartItemModel cartItemModel;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: Dismissible(
        key: Key(cartItemModel.product.id.toString()),
        background: Container(
          alignment: Alignment.center,
          color: Colors.red.shade50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.delete, color: Colors.red.shade600, size: isSmallScreen ? 20 : 24),
              const SizedBox(width: 5),
              Text('Delete', style: AppStyles.getMediumTextStyle(fontSize: isSmallScreen ? 12 : 14)),
            ],
          ),
        ),
        onDismissed: (d) {
          BlocProvider.of<CartBloc>(context).add(UpdateCartQuantityEvent(product: cartItemModel.product, quantity: 0));
          CustomSnackBar.showSuccess(message: "${cartItemModel.product.name} deleted");
        },
        child: Container(
          padding: const EdgeInsets.all(13),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [BoxShadow(blurRadius: 8, color: Colors.black26)],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Product Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      cartItemModel.product.name ?? "",
                      style: AppStyles.getSemiBoldTextStyle(fontSize: isSmallScreen ? 12 : 14),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Unit Price AED ${cartItemModel.product.unitPrice}',
                      style: AppStyles.getRegularTextStyle(fontSize: isSmallScreen ? 10 : 12, color: Colors.grey.shade700),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Discount Price AED ${cartItemModel.product.discountPrice}',
                      style: AppStyles.getRegularTextStyle(fontSize: isSmallScreen ? 10 : 12, color: Colors.grey.shade700),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Total Price AED ${cartItemModel.totalPrice}',
                      style: AppStyles.getSemiBoldTextStyle(fontSize: isSmallScreen ? 10 : 12, color: Colors.grey.shade700),
                    ),
                  ],
                ),
              ),

              // Quantity Modifier
              BlocBuilder<CartBloc, CartState>(
                builder: (context, state) {
                  if (state is CartLoadedState) {
                    final cartItem = state.cart!.cartItems.firstWhere(
                      (item) => item.product.id == cartItemModel.product.id,
                      orElse: () => CartItemModel(product: cartItemModel.product, quantity: 0),
                    );

                    return Container(
                      height: isSmallScreen ? 32 : 38,
                      width: isSmallScreen ? 90 : 100,
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: const [BoxShadow(blurRadius: 6, spreadRadius: 3, color: Colors.black26)],
                      ),
                      child: Row(
                        children: [
                          // Decrease Button
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                final newQuantity = max(0, cartItem.quantity - 1);
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
                                    style: AppStyles.getBoldTextStyle(fontSize: isSmallScreen ? 13 : 15, color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ),

                          // Quantity Display
                          Expanded(
                            flex: 2,
                            child: Center(
                              child: Text(
                                cartItem.quantity.toString(),
                                style: AppStyles.getRegularTextStyle(fontSize: isSmallScreen ? 13 : 15),
                              ),
                            ),
                          ),

                          // Increase Button
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                final newQuantity = cartItem.quantity + 1;
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
                                    style: AppStyles.getBoldTextStyle(fontSize: isSmallScreen ? 13 : 15, color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
