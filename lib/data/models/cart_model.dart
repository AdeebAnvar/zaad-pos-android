// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:pos_app/data/models/product_model.dart';

class CartModel {
  final int cartId;
  final String invoiceNumber;
  final List<CartItemModel> cartItems;
  double totalCartPrice;
  double discount;
  final int isHolded;
  CartModel({required this.isHolded, required this.cartId, required this.invoiceNumber, required this.cartItems, required this.totalCartPrice, required this.discount});

  // Calculate total cart price including all items with their quantities and discounts
  double calculateTotalCartPrice() {
    double total = 0.0;
    for (var item in cartItems) {
      total += item.calculateTotalPrice();
    }

    double finalTotal = total - discount;
    return finalTotal.clamp(0.0, double.infinity);
  }

  // Update total cart price
  void updateTotalCartPrice() {
    totalCartPrice = calculateTotalCartPrice();
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': cartId,
      'discount': discount,
      'cartItems': cartItems.map((x) => x.toJson()).toList(),
      'totalCartPrice': totalCartPrice,
      'invoice_number': invoiceNumber,
      'holded': isHolded,
    };
  }

  void applyDiscount(double discountAmount, {bool isPercentage = false}) {
    double totalPrice = calculateTotalCartPrice();
    if (discount != 0) {
      for (var item in cartItems) {
        item.removeDiscount();
      }
    }
    if (isPercentage) {
      if (discountAmount > 100) {
        throw ArgumentError('Discount percentage cannot exceed 100%');
      }
      discount = totalPrice * (discountAmount / 100);
    } else {
      if (discountAmount > totalPrice) {
        throw ArgumentError('Discount amount cannot exceed item total');
      }
      discount = discountAmount;
    }

    updateTotalCartPrice();
  }

  // Remove discount from this item
  void removeDiscount() {
    discount = 0.0;
    updateTotalCartPrice();
  }

  factory CartModel.fromMap(Map<String, dynamic> map) {
    return CartModel(
      cartId: map['id'],
      invoiceNumber: map['invoice_number'],
      discount: map['discount'] ?? 0,
      cartItems: map['cartItems'] != null
          ? List<CartItemModel>.from(
              (map['cartItems'] as List).map<CartItemModel>(
                (x) => CartItemModel.fromJson(x as Map<String, dynamic>),
              ),
            )
          : [], // Return an empty list if cartItems is null
      totalCartPrice: map['totalCartPrice'] != null ? map['totalCartPrice'] as double : 0.0, // Default to 0.0 if totalCartPrice is null
      isHolded: map['holded'],
    );
  }
}

class CartItemModel {
  ProductModel product;
  int quantity;
  double totalPrice;
  double discount;
  int discountType;

  CartItemModel({
    required this.product,
    required this.quantity,
    this.totalPrice = 0,
    this.discount = 0,
    this.discountType = 1,
  });

  // Calculate total price for this item including quantity and discount
  double calculateTotalPrice() {
    double unitPrice = product.unitPrice ?? 0.0;
    double itemTotal = unitPrice * quantity;
    double finalTotal = itemTotal - discount;
    return finalTotal.clamp(0.0, double.infinity); // Ensure non-negative
  }

  // Update total price based on current values
  void updateTotalPrice() {
    totalPrice = calculateTotalPrice();
  }

  // Apply discount to this item
  void applyDiscount(double discountAmount, {bool isPercentage = false}) {
    double unitPrice = product.unitPrice ?? 0.0;
    double itemTotal = unitPrice * quantity;

    if (isPercentage) {
      if (discountAmount > 100) {
        throw ArgumentError('Discount percentage cannot exceed 100%');
      }
      discount = itemTotal * (discountAmount / 100);
    } else {
      if (discountAmount > itemTotal) {
        throw ArgumentError('Discount amount cannot exceed item total');
      }
      discount = discountAmount;
    }

    updateTotalPrice();
  }

  // Remove discount from this item
  void removeDiscount() {
    discount = 0.0;
    updateTotalPrice();
  }

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      product: ProductModel.fromJson(Map<String, dynamic>.from(json['product'] as Map)),
      quantity: json['quantity'] as int? ?? 0,
      totalPrice: (json['totalPrice'] as num?)?.toDouble() ?? 0,
      discount: (json['discount'] as num?)?.toDouble() ?? 0,
      discountType: json['discount_type'] ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product': product.toJson(),
      'quantity': quantity,
      'totalPrice': totalPrice,
      'discount': discount,
      'discount_type': discountType,
    };
  }
}
