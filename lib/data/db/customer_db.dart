import 'package:hive/hive.dart';
import 'package:pos_app/data/models/customer_model.dart';

class CustomerDb {
  static String customerBoxName = "zaad_pos_customers";

  static late Box customerBox;
  static initCustomerDb() async => customerBox = await Hive.openBox(customerBoxName);

  static Future<int> storeCustomer(CustomerModel customer) async {
    int customerId = await customerBox.add(customer.toMap());

    return customerId;
  }

  static Future<void> updateCustomer(int index, CustomerModel customer) async {
    customerBox.putAt(index, customer.toMap());
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
