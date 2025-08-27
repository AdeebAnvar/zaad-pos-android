import 'dart:io';
import 'dart:math' show max;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/constatnts/colors.dart' show AppColors;
import 'package:pos_app/constatnts/enums.dart';
import 'package:pos_app/logic/sale_controllers.dart';
import 'package:pos_app/logic/sale_logic/sale_bloc.dart';
import 'package:pos_app/widgets/custom_snackbar.dart';

import '../constatnts/styles.dart';
import '../data/models/cart_model.dart';
import '../logic/cart_logic/cart_bloc.dart';

class CartProductCard extends StatefulWidget {
  final CartItemModel cartItemModel;
  const CartProductCard({super.key, required this.cartItemModel});

  @override
  State<CartProductCard> createState() => _CartProductCardState();
}

class _CartProductCardState extends State<CartProductCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isHovered = false;
  bool _showDiscountFields = false;
  final TextEditingController _discountController = TextEditingController();
  DiscountType _discountType = DiscountType.byPercentage;

  @override
  void initState() {
    super.initState();
    _discountType = widget.cartItemModel.discountType == 1 ? DiscountType.byPercentage : DiscountType.byAmount;
    _discountController.text = widget.cartItemModel.discount.toString();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.02).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _discountController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
  }

  void _onTapCancel() {
    _controller.reverse();
  }

  void _applyDiscount() {
    if (_discountController.text.isEmpty) return;

    final discountValue = double.tryParse(_discountController.text) ?? 0;
    // final originalPrice = widget.cartItemModel.product.unitPrice ?? 0;
    // double discountedPrice = originalPrice;

    // if (_discountType == 'By Percentage') {
    //   if (discountValue > 100) {
    //     CustomSnackBar.showError(message: "Discount percentage cannot exceed 100%");
    //     return;
    //   }
    //   discountedPrice = originalPrice * (discountValue / 100);
    // } else {
    //   if (discountValue > originalPrice) {
    //     CustomSnackBar.showError(message: "Discount amount cannot exceed original price");
    //     return;
    //   }

    //   discountedPrice = originalPrice - discountValue;
    // }

    // widget.cartItemModel.totalPrice = discountedPrice;
    // widget.cartItemModel.discount = originalPrice - discountedPrice;

    setState(() {});
    BlocProvider.of<CartBloc>(context)
        .add(ProductDiscountEvent(cartItemModel: widget.cartItemModel, isPercentage: _discountType == DiscountType.byPercentage, discountedPrice: discountValue));
  }

  void _removeDiscount() {
    // widget.cartItemModel.totalPrice = widget.cartItemModel.product.unitPrice ?? 0;
    // widget.cartItemModel.discount = 0;
    setState(() {
      _showDiscountFields = false;
      _discountController.clear();
    });
    BlocProvider.of<CartBloc>(context).add(ProductDiscountEvent(discountedPrice: -1, cartItemModel: widget.cartItemModel, isPercentage: false));
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) => Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 5),
            child: Dismissible(
              key: Key(widget.cartItemModel.product.id.toString()),
              direction: DismissDirection.endToStart,
              confirmDismiss: (direction) async {
                return await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      backgroundColor: Colors.white,
                      title: const Text('Confirm'),
                      content: Text('Are you sure you want to remove ${widget.cartItemModel.product.name}?'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: const Text('CANCEL'),
                        ),
                        ElevatedButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: const Text('DELETE'),
                        ),
                      ],
                    );
                  },
                );
              },
              background: Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 20),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(Icons.delete, color: Colors.red.shade600, size: isSmallScreen ? 20 : 24),
                    const SizedBox(width: 5),
                    Text('Delete', style: AppStyles.getMediumTextStyle(fontSize: isSmallScreen ? 12 : 14)),
                  ],
                ),
              ),
              onDismissed: (d) {
                BlocProvider.of<CartBloc>(context).add(UpdateCartQuantityEvent(product: widget.cartItemModel.product, quantity: 0));
                context.read<SaleBloc>().add(LoadProductsEvent(productName: SaleControllers.searchController.text));

                CustomSnackBar.showSuccess(message: "${widget.cartItemModel.product.name} Removed");
              },
              child: Container(
                padding: const EdgeInsets.all(13),
                decoration: BoxDecoration(
                  color: _isHovered ? Colors.grey[50] : Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: _isHovered ? 12 : 8,
                      color: Colors.black26,
                      spreadRadius: _isHovered ? 0.2 : 0.1,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Product Info
                        Flexible(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: AnimatedContainer(
                              duration: Duration(milliseconds: 600),
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                              ),
                              child: widget.cartItemModel.product.localImagePath != null
                                  ? Image.file(
                                      File(widget.cartItemModel.product.localImagePath!),
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) => Icon(
                                        Icons.image_not_supported,
                                        color: Colors.grey[400],
                                        size: 40,
                                      ),
                                    )
                                  : Icon(
                                      Icons.image_not_supported,
                                      color: Colors.grey[400],
                                      size: 40,
                                    ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.cartItemModel.product.name ?? "",
                                style: AppStyles.getSemiBoldTextStyle(fontSize: isSmallScreen ? 12 : 14),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Unit Price AED ${widget.cartItemModel.product.unitPrice?.toStringAsFixed(2)}',
                                style: AppStyles.getRegularTextStyle(fontSize: isSmallScreen ? 10 : 12, color: Colors.grey.shade700),
                              ),
                              if (widget.cartItemModel.discount > 0) ...[
                                const SizedBox(height: 4),
                                Text(
                                  'Discount AED ${widget.cartItemModel.discount.toStringAsFixed(2)}',
                                  style: AppStyles.getRegularTextStyle(
                                    fontSize: isSmallScreen ? 10 : 12,
                                    color: Colors.green[700],
                                  ),
                                ),
                              ],
                              const SizedBox(height: 4),
                              Text(
                                'Total Price AED ${widget.cartItemModel.totalPrice.toStringAsFixed(2)}',
                                style: AppStyles.getSemiBoldTextStyle(
                                  fontSize: isSmallScreen ? 10 : 12,
                                  color: AppColors.primaryColor,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Quantity Modifier
                        BlocBuilder<CartBloc, CartState>(
                          builder: (context, state) {
                            if (state is CartLoadedState) {
                              if (state.cart != null) {
                                final cartItem = state.cart?.cartItems.firstWhere(
                                  (item) => item.product.id == widget.cartItemModel.product.id,
                                  orElse: () => CartItemModel(product: widget.cartItemModel.product, quantity: 0),
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
                                          onTapDown: _onTapDown,
                                          onTapUp: _onTapUp,
                                          onTapCancel: _onTapCancel,
                                          onTap: () {
                                            final newQuantity = max(0, cartItem!.quantity - 1);

                                            BlocProvider.of<CartBloc>(context).add(UpdateCartQuantityEvent(
                                              product: cartItem!.product,
                                              quantity: newQuantity,
                                            ));
                                            context.read<SaleBloc>().add(LoadProductsEvent(productName: SaleControllers.searchController.text));
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
                                            cartItem!.quantity.toString(),
                                            style: AppStyles.getRegularTextStyle(fontSize: isSmallScreen ? 13 : 15),
                                          ),
                                        ),
                                      ),

                                      // Increase Button
                                      Expanded(
                                        child: GestureDetector(
                                          onTapDown: _onTapDown,
                                          onTapUp: _onTapUp,
                                          onTapCancel: _onTapCancel,
                                          onTap: () {
                                            final newQuantity = cartItem.quantity + 1;
                                            BlocProvider.of<CartBloc>(context).add(UpdateCartQuantityEvent(
                                              product: cartItem.product,
                                              quantity: newQuantity,
                                            ));
                                            context.read<SaleBloc>().add(LoadProductsEvent(productName: SaleControllers.searchController.text));
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
                              } else {
                                return const SizedBox.shrink();
                              }
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                      ],
                    ),
                    if (_showDiscountFields) ...[
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<DiscountType>(
                              value: _discountType,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                              ),
                              items: DiscountType.values
                                  .map((e) => DropdownMenuItem<DiscountType>(
                                        value: e,
                                        child: Text(e.label),
                                      ))
                                  .toList(),
                              onChanged: (value) {
                                setState(() {
                                  _discountType = value!;
                                  _discountController.clear();
                                });
                              },
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                              controller: _discountController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hintText: _discountType == DiscountType.byPercentage ? 'Enter %' : 'Enter Amount',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: _removeDiscount,
                            child: const Text('Remove Discount'),
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: _applyDiscount,
                            child: const Text('Apply'),
                          ),
                        ],
                      ),
                    ] else ...[
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton.icon(
                          onPressed: () => setState(() => _showDiscountFields = true),
                          icon: const Icon(Icons.discount),
                          label: Text(widget.cartItemModel.discount > 0 ? 'Edit Discount' : 'Add Discount'),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
