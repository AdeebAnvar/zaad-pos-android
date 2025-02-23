import 'dart:developer';
import 'package:hive/hive.dart';
import 'package:pos_app/data/models/orders_model.dart';

class OrderDb {
  static String orderBoxName = "zaad_pos_order";
  static late Box orderBox;
  static initOrderDb() async => orderBox = await Hive.openBox(orderBoxName);

  static Map<String, dynamic> _convertToStringDynamicMap(Map map) {
    return map.map((key, value) {
      if (value is Map) {
        return MapEntry(key.toString(), _convertToStringDynamicMap(value));
      }
      if (value is List) {
        return MapEntry(
            key.toString(),
            value.map((item) {
              if (item is Map) {
                return _convertToStringDynamicMap(item);
              }
              return item;
            }).toList());
      }
      return MapEntry(key.toString(), value);
    });
  }

  static createCustomerOrder(OrderModel orderModel) async {
    orderModel.orderId = orderBox.isEmpty ? 1 : orderBox.keys.last + 1;
    final Map<String, dynamic> orderJson = orderModel.toJson();
    await orderBox.add(orderJson);
    log("Order added: ${orderBox.values}");
  }

  static List<OrderModel> getAllOrders() {
    log('getting all orders: ${orderBox.values.toString()}');
    final List<OrderModel> orders = orderBox.values.map((orderData) {
      final convertedData = _convertToStringDynamicMap(orderData as Map);
      return OrderModel.fromJson(convertedData);
    }).toList();
    return orders;
  }

  static List<OrderModel> getAllOrdersOfCustomer(int customerId) {
    print(customerId);
    final List<OrderModel> orders = orderBox.values
        .map((orderData) {
          final convertedData = _convertToStringDynamicMap(orderData as Map);
          return OrderModel.fromJson(convertedData);
        })
        .where((order) => order.customerId == customerId)
        .toList();
    return orders;
  }
}
