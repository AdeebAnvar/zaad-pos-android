// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:pos_app/data/models/product_model.dart';

class CartModel {
  final List<CartItemModel> cartItems;
  final double grandTotal;

  CartModel({required this.cartItems, required this.grandTotal});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'cartItems': cartItems.map((x) => x.toMap()).toList(),
      'grandTotal': grandTotal,
    };
  }

  factory CartModel.fromMap(Map<String, dynamic> map) {
    return CartModel(
      cartItems: map['cartItems'] != null
          ? List<CartItemModel>.from(
              (map['cartItems'] as List).map<CartItemModel>(
                (x) => CartItemModel.fromMap(x as Map<String, dynamic>),
              ),
            )
          : [], // Return an empty list if cartItems is null
      grandTotal: map['grandTotal'] != null ? map['grandTotal'] as double : 0.0, // Default to 0.0 if grandTotal is null
    );
  }

  String toJson() => json.encode(toMap());

  factory CartModel.fromJson(String source) => CartModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

class CartItemModel {
  final ProductModel product;
  int quantity;
  final double totalPrice;

  CartItemModel({
    this.totalPrice = 0.00,
    required this.product,
    required this.quantity,
  });

  Map<String, dynamic> toMap() {
    double priceofProduct = (product.discountPrice < product.unitPrice || product.unitPrice == 0 ? product.discountPrice : product.unitPrice).toDouble();
    return <String, dynamic>{
      'total_price': priceofProduct * quantity,
      'product': product.toMap(),
      'quantity': quantity,
    };
  }

  factory CartItemModel.fromMap(Map<String, dynamic> map) {
    return CartItemModel(
      totalPrice: map['total_price'] as double,
      product: ProductModel.fromMap(Map<String, dynamic>.from(map['product'])), // Explicit conversion
      quantity: map['quantity'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory CartItemModel.fromJson(String source) => CartItemModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
