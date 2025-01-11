import 'package:hive/hive.dart';
import 'package:pos_app/data/models/orders_model.dart';

class OrderDb {
  static String orderBoxName = "zaad_pos_order";
  static late Box orderBox;
  static initOrderDb() async => orderBox = await Hive.openBox(orderBoxName);

  static createCustomerOrder(OrderModel orderModel) async {
    await orderBox.put(orderModel.id, orderModel.toMap());
  }

  static List<OrderModel> getAllOrders() {
    return orderBox.values.map((orderData) {
      final Map<String, dynamic> orderMap = Map<String, dynamic>.from(orderData as Map);
      return OrderModel.fromMap(orderMap);
    }).toList();
  }

  static List<OrderModel> getAllOrdersOfCustomer(int customerId) {
    final or = getAllOrders();
    final List<OrderModel> orders = orderBox.values
        .map((orderData) {
          final Map<String, dynamic> orderMap = Map<String, dynamic>.from(orderData as Map);
          return OrderModel.fromMap(orderMap);
        })
        .where((order) => order.customerId == customerId)
        .toList();
    print(or[1].customerId);
    print(customerId);
    return orders;
  }
}
