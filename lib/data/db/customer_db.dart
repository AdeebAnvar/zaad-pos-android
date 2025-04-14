import 'package:hive/hive.dart';
import 'package:pos_app/data/api/service.dart';
import 'package:pos_app/data/api/urls.dart';
import 'package:pos_app/data/models/customer_model.dart';
import 'package:pos_app/data/models/response_model.dart';

class CustomerDb {
  static String customerBoxName = "zaad_pos_customers";

  static late Box customerBox;
  static initCustomerDb() async => customerBox = await Hive.openBox(customerBoxName);
  static Future<int> storeCustomer(CustomerModel customer) async {
    int customerId = await customerBox.add(customer.toJson());
    return customerId;
  }

  static Future<void> updateCustomer(int index, CustomerModel customer) async {
    customerBox.putAt(index, customer.toJson());
  }

  static List<CustomerModel> getAllCustomers() {
    return customerBox.keys.map((key) {
      final customerData = customerBox.get(key);
      final Map<String, dynamic> customerMap = Map<String, dynamic>.from(customerData as Map);
      final customer = CustomerModel.fromJson(customerMap);
      if (customer.id == 0 || customer.id == null) {
        customer.id = key;
      }
      return customer;
    }).toList();
  }

  static CustomerModel? getSingleCustomer(int id) {
    return customerBox.get(id);
  }

  static Future<void> clearCustomerDb() async => await customerBox.clear();
}
