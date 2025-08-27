// To parse this JSON data, do
//
//     final orderModel = orderModelFromJson(jsonString);

import 'dart:convert';

List<OrderModel> orderModelFromJson(String str) => List<OrderModel>.from(json.decode(str).map((x) => OrderModel.fromJson(x)));

String orderModelToJson(List<OrderModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class OrderModel {
  int? orderId;
  num? customerId;
  num? cardAmount;
  num? cashAmount;
  String? paymentMethod;
  String? recieptNumber;
  String? orderType;
  String? orderNumber;
  num? grossTotal;
  num? discount;
  num? netTotal;
  List<OrderItem>? orderItems;

  OrderModel({
    this.orderId,
    this.customerId,
    this.cardAmount,
    this.cashAmount,
    this.paymentMethod,
    this.recieptNumber,
    this.orderType,
    this.orderNumber,
    this.grossTotal,
    this.discount,
    this.netTotal,
    this.orderItems,
  });

  // Validate order data
  bool isValid() {
    if (orderItems == null || orderItems!.isEmpty) {
      return false;
    }

    if (grossTotal == null || grossTotal! <= 0) {
      return false;
    }

    if (netTotal == null || netTotal! < 0) {
      return false;
    }

    if (discount == null || discount! < 0) {
      return false;
    }

    // Validate payment amounts
    double totalPayment = (cardAmount?.toDouble() ?? 0.0) + (cashAmount?.toDouble() ?? 0.0);
    if (totalPayment < (netTotal?.toDouble() ?? 0.0)) {
      return false;
    }

    return true;
  }

  factory OrderModel.fromJson(Map<String, dynamic> json) => OrderModel(
        orderId: json["order_id"],
        customerId: json["customerId"],
        cardAmount: json["cardAmount"],
        cashAmount: json["cashAmount"],
        paymentMethod: json["paymentMethod"],
        recieptNumber: json["reciept_number"],
        orderType: json["order_type"],
        orderNumber: json["order_number"],
        grossTotal: json["grossTotal"],
        discount: json["discount"],
        netTotal: json["netTotal"],
        orderItems: json["orderItems"] == null ? [] : List<OrderItem>.from(json["orderItems"]!.map((x) => OrderItem.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "order_id": orderId,
        "customerId": customerId,
        "cardAmount": cardAmount,
        "cashAmount": cashAmount,
        "paymentMethod": paymentMethod,
        "reciept_number": recieptNumber,
        "order_type": orderType,
        "order_number": orderNumber,
        "grossTotal": grossTotal,
        "discount": discount,
        "netTotal": netTotal,
        "orderItems": orderItems == null ? [] : List<dynamic>.from(orderItems!.map((x) => x.toJson())),
      };
}

class OrderItem {
  double? price; // Changed from int to double for better precision
  int? quantity;
  int? productId;

  OrderItem({
    this.price,
    this.quantity,
    this.productId,
  });

  // Validate order item
  bool isValid() {
    if (price == null || price! <= 0) {
      return false;
    }

    if (quantity == null || quantity! <= 0) {
      return false;
    }

    if (productId == null || productId! <= 0) {
      return false;
    }

    return true;
  }

  factory OrderItem.fromJson(Map<String, dynamic> json) => OrderItem(
        price: (json["price"] as num?)?.toDouble(), // Convert to double
        quantity: json["quantity"],
        productId: json["productId"],
      );

  Map<String, dynamic> toJson() => {
        "price": price,
        "quantity": quantity,
        "productId": productId,
      };
}
