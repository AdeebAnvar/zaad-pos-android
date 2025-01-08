import 'package:hive_flutter/hive_flutter.dart';
import 'package:pos_app/data/models/customer_model.dart';
import 'package:pos_app/data/models/orders_model.dart';
import 'dart:math' show max;

import 'package:pos_app/data/models/product_model.dart';

class HiveDb {
  static String customerBoxName = "zaad_pos_customers";
  static String orderBoxName = "zaad_pos_order";
  static String productBoxName = "zaad_pos_product";

  static late Box customerBox;
  static late Box orderBox;
  static late Box productBox;

  static initHive() async {
    await Hive.initFlutter();

    customerBox = await Hive.openBox(customerBoxName);
    productBox = await Hive.openBox(productBoxName);
    orderBox = await Hive.openBox(orderBoxName);
  }

  static Future<void> storeCustomer(CustomerModel customer) async {
    int nextId = 1;
    if (customerBox.keys.isNotEmpty) {
      final List<int> ids = customerBox.keys.map((key) => int.tryParse(key.toString()) ?? 0).toList();
      nextId = (ids.reduce(max)) + 1;
    }

    customer.id = nextId;
    await customerBox.put(customer.id, customer.toMap());
  }

  static List<CustomerModel> getAllCustomers() {
    return customerBox.values.map((customerData) {
      final Map<String, dynamic> customerMap = Map<String, dynamic>.from(customerData as Map);
      return CustomerModel.fromMap(customerMap);
    }).toList();
  }

  static CustomerModel? getSingleCustomer(int id) {
    return customerBox.get(id);
  }

  static storeProducts() async {
    for (var element in products) {
      await productBox.put(element.id, element.toMap());
    }
  }

  static List<ProductModel> getAllProducts() {
    return productBox.values.map((productData) {
      final Map<String, dynamic> productMap = Map<String, dynamic>.from(productData as Map);
      return ProductModel.fromMap(productMap);
    }).toList();
  }

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

List<ProductModel> products = [
  ProductModel(id: 1, name: "Floral", category: "Perfume", unitPrice: 500, discountPrice: 200),
  ProductModel(id: 2, name: "Perfume 1", category: "Perfume", unitPrice: 500, discountPrice: 200),
  ProductModel(id: 3, name: "SandWitch", category: "Bread", unitPrice: 500, discountPrice: 200),
  ProductModel(id: 4, name: "Sandal", category: "FootWears", unitPrice: 500, discountPrice: 200),
];

// List<OrderModel> orders = [
//   OrderModel(
//     id: 1,
//     recieptNumber: "INV-19865",
//     orderType: "Delivery",
//     grossTotal: 1500,
//     netTotal: 1300,
//     discount: 40,
//     orderNumber: "ORD-7637",
//     products: [
//       products[0],
//       products[3],
//     ],
//   ),
//   OrderModel(
//     id: 2,
//     recieptNumber: "INV-7652",
//     orderType: "Counter Sale",
//     grossTotal: 1200,
//     netTotal: 1200,
//     discount: 40,
//     orderNumber: "ORD-76371",
//     products: [
//       products[1],
//     ],
//   ),
//   OrderModel(
//     id: 3,
//     recieptNumber: "INV-8734",
//     orderType: "Counter Sale",
//     grossTotal: 1600,
//     netTotal: 1000,
//     discount: 40,
//     orderNumber: "ORD-76372",
//     products: [
//       products[0],
//       products[2],
//       products[3],
//     ],
//   ),
//   OrderModel(
//     id: 4,
//     recieptNumber: "INV-3527",
//     orderType: "Delivery",
//     grossTotal: 2500,
//     netTotal: 900,
//     discount: 40,
//     orderNumber: "ORD-76373",
//     products: [
//       products[0],
//       products[1],
//       products[2],
//       products[3],
//     ],
//   ),
//   OrderModel(
//     id: 5,
//     recieptNumber: "INV-19865",
//     orderType: "Delivery",
//     grossTotal: 1500,
//     netTotal: 1300,
//     discount: 40,
//     orderNumber: "ORD-7637",
//     products: [
//       products[0],
//       products[3],
//     ],
//   ),
//   OrderModel(
//     id: 6,
//     recieptNumber: "INV-7652",
//     orderType: "Counter Sale",
//     grossTotal: 1200,
//     netTotal: 1200,
//     discount: 40,
//     orderNumber: "ORD-76371",
//     products: [
//       products[1],
//     ],
//   ),
//   OrderModel(
//     id: 7,
//     recieptNumber: "INV-8734",
//     orderType: "Counter Sale",
//     grossTotal: 1600,
//     netTotal: 1000,
//     discount: 40,
//     orderNumber: "ORD-76372",
//     products: [
//       products[0],
//       products[2],
//       products[3],
//     ],
//   ),
//   OrderModel(
//     id: 8,
//     recieptNumber: "INV-3527",
//     orderType: "Delivery",
//     grossTotal: 2500,
//     netTotal: 900,
//     discount: 40,
//     orderNumber: "ORD-76373",
//     products: [
//       products[0],
//       products[1],
//       products[2],
//       products[3],
//     ],
//   ),
// ];
