// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:pos_app/constatnts/enums.dart';
import 'package:pos_app/data/models/cart_model.dart';
import 'package:pos_app/data/models/product_model.dart';

class OrderModel {
  int? id;
  int? customerId;
  double? cardAmount;
  double? cashAmount;
  PaymentMode? paymentMethod;
  final String recieptNumber;
  final String orderType;
  final String orderNumber;
  final double grossTotal;
  final double discount;
  final double netTotal;
  final CartModel cart;

  OrderModel({
    this.id,
    this.customerId,
    this.cardAmount,
    this.cashAmount,
    this.paymentMethod,
    required this.recieptNumber,
    required this.orderType,
    required this.orderNumber,
    required this.grossTotal,
    required this.discount,
    required this.netTotal,
    required this.cart,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'customerId': customerId,
      'cardAmount': cardAmount,
      'cashAmount': cashAmount,
      'paymentMethod': paymentMethod == PaymentMode.card
          ? "Card"
          : paymentMethod == PaymentMode.cash
              ? "Cash"
              : paymentMethod == PaymentMode.split
                  ? "Split"
                  : "Credit",
      'recieptNumber': recieptNumber,
      'orderType': orderType,
      'orderNumber': orderNumber,
      'grossTotal': grossTotal,
      'discount': discount,
      'netTotal': netTotal,
      'cart': cart.toMap(),
    };
  }

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    // Ensure map['cart'] is a Map<String, dynamic>
    final cartMap = map['cart'] is Map<String, dynamic> ? map['cart'] as Map<String, dynamic> : <String, dynamic>{};

    return OrderModel(
      id: map['id'] != null ? map['id'] as int : null,
      customerId: map['customerId'] != null ? map['customerId'] as int : null,
      cardAmount: map['cardAmount'] != null ? map['cardAmount'] as double : null,
      cashAmount: map['cashAmount'] != null ? map['cashAmount'] as double : null,
      paymentMethod: map['paymentMethod'] != null ? _paymentMethodFromString(map['paymentMethod'] as String) : null,
      recieptNumber: map['recieptNumber'] as String,
      orderType: map['orderType'] as String,
      orderNumber: map['orderNumber'] as String,
      grossTotal: map['grossTotal'] as double,
      discount: map['discount'] as double,
      netTotal: map['netTotal'] as double,
      cart: CartModel.fromMap(cartMap), // Using the corrected cartMap
    );
  }

  String toJson() => json.encode(toMap());

  factory OrderModel.fromJson(String source) => OrderModel.fromMap(json.decode(source) as Map<String, dynamic>);

  // Helper function to convert string to PaymentMode enum
  static PaymentMode _paymentMethodFromString(String method) {
    switch (method) {
      case 'Card':
        return PaymentMode.card;
      case 'Cash':
        return PaymentMode.cash;
      case 'Split':
        return PaymentMode.split;
      case 'Credit':
        return PaymentMode.credit;
      default:
        return PaymentMode.cash;
    }
  }
}
