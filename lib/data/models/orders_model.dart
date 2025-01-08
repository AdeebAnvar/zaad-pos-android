import 'dart:convert';

import 'package:pos_app/data/models/product_model.dart';

class OrderModel {
  int? id;
  int? customerId;
  final String recieptNumber;
  final String orderType;
  final String orderNumber;
  final double grossTotal;
  final double discount;
  final double netTotal;
  final List<ProductModel> products;

  OrderModel({
    this.id,
    this.customerId,
    required this.recieptNumber,
    required this.orderType,
    required this.orderNumber,
    required this.grossTotal,
    required this.discount,
    required this.netTotal,
    required this.products,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'customerId': customerId,
      'recieptNumber': recieptNumber,
      'orderType': orderType,
      'orderNumber': orderNumber,
      'grossTotal': grossTotal,
      'discount': discount,
      'netTotal': netTotal,
      'products': products.map((x) => x.toMap()).toList(),
    };
  }

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    print(map["products"]);
    return OrderModel(
      id: map['id'] as int?,
      customerId: map['customerId'] as int?,
      recieptNumber: map['recieptNumber'] as String,
      orderType: map['orderType'] as String,
      orderNumber: map['orderNumber'] as String,
      grossTotal: (map['grossTotal'] as num).toDouble(),
      discount: (map['discount'] as num).toDouble(),
      netTotal: (map['netTotal'] as num).toDouble(),
      products: List<ProductModel>.from(
        (map["products"] as List).map((x) {
          print(x);
          print(x.runtimeType);
          return ProductModel.fromMap(Map<String, dynamic>.from(x));
        }),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory OrderModel.fromJson(String source) => OrderModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
