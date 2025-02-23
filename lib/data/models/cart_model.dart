// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:pos_app/data/models/product_model.dart';

class CartModel {
  final List<CartItemModel> cartItems;
  final double totalCartPrice;

  CartModel({required this.cartItems, required this.totalCartPrice});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'cartItems': cartItems.map((x) => x.toJson()).toList(),
      'totalCartPrice': totalCartPrice,
    };
  }

  factory CartModel.fromMap(Map<String, dynamic> map) {
    return CartModel(
      cartItems: map['cartItems'] != null
          ? List<CartItemModel>.from(
              (map['cartItems'] as List).map<CartItemModel>(
                (x) => CartItemModel.fromJson(x as Map<String, dynamic>),
              ),
            )
          : [], // Return an empty list if cartItems is null
      totalCartPrice: map['totalCartPrice'] != null ? map['totalCartPrice'] as double : 0.0, // Default to 0.0 if totalCartPrice is null
    );
  }
}

class CartItemModel {
  int quantity;
  final double totalPrice;
  ProductModel product;
  CartItemModel({
    this.totalPrice = 0.00,
    required this.product,
    required this.quantity,
  });

  Map<String, dynamic> toJson() {
    double priceOfProduct = (product.discountPrice != null && product.unitPrice != null && (product.discountPrice! < product.unitPrice! || product.unitPrice == 0))
        ? product.discountPrice ?? 0
        : product.unitPrice ?? 0;
    return <String, dynamic>{
      'total_price': priceOfProduct * quantity,
      'product': product.toJson(),
      'quantity': quantity,
    };
  }

  factory CartItemModel.fromJson(Map<String, dynamic> map) {
    return CartItemModel(
      totalPrice: map['total_price'] as double,
      product: ProductModel.fromJson(Map<String, dynamic>.from(map['product'])), // Explicit conversion
      quantity: map['quantity'] as int,
    );
  }
}
