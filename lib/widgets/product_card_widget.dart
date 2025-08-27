import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/constatnts/colors.dart';
import 'package:pos_app/constatnts/styles.dart';
import 'package:pos_app/data/api/urls.dart';
import 'package:pos_app/data/models/product_model.dart';
import 'package:pos_app/logic/cart_logic/cart_bloc.dart';
import 'package:pos_app/logic/sale_controllers.dart';
import 'package:pos_app/logic/sale_logic/sale_bloc.dart';
import 'package:pos_app/widgets/custom_snackbar.dart';

class ProductCard extends StatefulWidget {
  const ProductCard({
    super.key,
    required this.product,
    this.onAddToCart,
    required this.isGrid,
  });

  final ProductModel product;
  final bool isGrid;
  final VoidCallback? onAddToCart;

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
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

  void _handleTap() {
    if (widget.onAddToCart != null) {
      widget.onAddToCart!();
    } else {
      context.read<CartBloc>().add(AddToCartEvent(product: widget.product));
      context.read<SaleBloc>().add(LoadProductsEvent(productName: SaleControllers.searchController.text));
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
        onTapCancel: _onTapCancel,
        onTap: _handleTap,
        child: AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) => Transform.scale(
            scale: _scaleAnimation.value,
            child: widget.isGrid ? _buildGridCard() : _buildListCard(),
          ),
        ),
      ),
    );
  }

  Widget _buildListCard() {
    return Container(
      height: 90,
      padding: const EdgeInsets.symmetric(horizontal: 13),
      margin: const EdgeInsets.symmetric(vertical: 5),
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
      child: Row(
        children: [
          // Product Image with Stock Badge
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                  ),
                  child: widget.product.localImagePath != null
                      ? Image.file(
                          File(widget.product.localImagePath!),
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Icon(
                            Icons.image_not_supported,
                            color: Colors.grey[400],
                          ),
                        )
                      : Icon(
                          Icons.image_not_supported,
                          color: Colors.grey[400],
                        ),
                ),
              ),
              if (widget.product.minStockQty != null)
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(8),
                        topRight: Radius.circular(8),
                      ),
                    ),
                    child: Text(
                      widget.product.minStockQty.toString(),
                      style: AppStyles.getMediumTextStyle(
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 12),
          // Product Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.product.name ?? "",
                  style: AppStyles.getMediumTextStyle(fontSize: 14),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (widget.product.categoryNameArabic != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    widget.product.categoryNameArabic!,
                    style: AppStyles.getMediumTextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ],
            ),
          ),
          // Price Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.primaryColor,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              "AED ${widget.product.unitPrice?.toStringAsFixed(2) ?? "0.00"}",
              style: AppStyles.getMediumTextStyle(
                fontSize: 12,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGridCard() {
    return AnimatedContainer(
      duration: Duration(milliseconds: 600),
      height: 200,
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: _isHovered ? Colors.grey[50] : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            blurRadius: _isHovered ? 12 : 8,
            color: Colors.black26,
            spreadRadius: _isHovered ? 0.2 : 0.1,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Image with Stock Badge
          Expanded(
            flex: 3,
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                    ),
                    child: widget.product.localImagePath != null
                        ? Image.file(
                            File(widget.product.localImagePath!),
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
                if (widget.product.minStockQty != null)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        widget.product.minStockQty.toString(),
                        style: AppStyles.getMediumTextStyle(
                          fontSize: 10,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // Product Name
          Expanded(
            flex: 1,
            child: Text(
              widget.product.name ?? "",
              style: AppStyles.getMediumTextStyle(fontSize: 13),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          // Category Name
          if (widget.product.categoryNameArabic != null) ...[
            Expanded(
              flex: 1,
              child: Text(
                widget.product.categoryNameArabic!,
                style: AppStyles.getMediumTextStyle(
                  fontSize: 11,
                  color: Colors.grey[600],
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
          const SizedBox(height: 4),
          // Price and Add to Cart Button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    "AED ${widget.product.unitPrice?.toStringAsFixed(2) ?? "0.00"}",
                    style: AppStyles.getMediumTextStyle(
                      fontSize: 11,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              // const SizedBox(width: 6),
              // Container(
              //   padding: const EdgeInsets.all(4),
              //   decoration: BoxDecoration(
              //     color: AppColors.primaryColor,
              //     borderRadius: BorderRadius.circular(4),
              //   ),
              //   child: Icon(
              //     Icons.add_shopping_cart,
              //     color: Colors.white,
              //     size: 16,
              //   ),
              // ),
            ],
          ),
        ],
      ),
    );
  }
}
