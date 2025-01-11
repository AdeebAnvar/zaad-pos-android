import 'package:hive/hive.dart';
import 'package:pos_app/data/models/customer_model.dart';
import 'dart:math' show max;

class CustomerDb {
  static String customerBoxName = "zaad_pos_customers";

  static late Box customerBox;
  static initCustomerDb() async => customerBox = await Hive.openBox(customerBoxName);

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
}
