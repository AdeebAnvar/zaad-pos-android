import 'dart:developer';

import 'package:hive/hive.dart';
import 'package:pos_app/data/models/orders_model.dart';

class OrderDb {
  static String orderBoxName = "zaad_pos_order";
  static late Box orderBox;
  static initOrderDb() async => orderBox = await Hive.openBox(orderBoxName);

  static createCustomerOrder(OrderModel orderModel) async {
    orderModel.id = orderBox.isEmpty ? 1 : orderBox.keys.last + 1;
    await orderBox.add(orderModel.toMap());
    log("dfsdg ${orderBox.values}");
  }

  static List<OrderModel> getAllOrders() {
    log(orderBox.values.toString());
    return orderBox.values.map((orderData) {
      final Map<String, dynamic> orderMap = Map<String, dynamic>.from(orderData);
      return OrderModel.fromMap(orderMap);
    }).toList();
  }

  static List<OrderModel> getAllOrdersOfCustomer(int customerId) {
    final List<OrderModel> orders = orderBox.values
        .map((orderData) {
          print('sdfasdf  ${orderData}');

          final Map<String, dynamic> orderMap = Map<String, dynamic>.from(orderData as Map);
          return OrderModel.fromMap(orderMap);
        })
        .where((order) => order.customerId == customerId)
        .toList();
    return orders;
  }
}
