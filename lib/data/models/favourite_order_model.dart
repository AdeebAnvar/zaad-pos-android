// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:pos_app/data/models/product_model.dart';

class FavouriteOrderModel {
  String id;
  ProductModel product;
  String purchasedCount;
  FavouriteOrderModel({
    required this.id,
    required this.product,
    required this.purchasedCount,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'product': product.toMap(),
      'purchasedCount': purchasedCount,
    };
  }

  factory FavouriteOrderModel.fromMap(Map<String, dynamic> map) {
    return FavouriteOrderModel(
      id: map['id'] as String,
      product: ProductModel.fromMap(map['product'] as Map<String, dynamic>),
      purchasedCount: map['purchasedCount'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory FavouriteOrderModel.fromJson(String source) => FavouriteOrderModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
