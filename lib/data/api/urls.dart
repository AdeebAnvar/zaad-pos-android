import 'package:pos_app/data/db/user_db.dart';
import 'package:pos_app/data/utils/extensions.dart';

class Urls {
  static dynamic getHeaders() {
    print('token : ${UserDb.getAuthToken()}');
    var ss = {
      'Content-Type': 'application/json',
      'Authorization': UserDb.getAuthToken().isNullOrEmpty() ? "" : 'Bearer ${UserDb.getAuthToken()}',
    };

    return ss;
  }

  static String baseUrl = "https://zaad-pos-backend.onrender.com/";
  // static String baseUrl = "http://192.168.100.97:20399/";

  static String login = "user/login";
  static String getAllCategories = "product/get_all_categories";
  static String getAllProducts = "product/get_all_products";
  static String getAllCustomers = "customer/get_all_customers";
  static String saveCustomer = "customer/save_customer";
  static String saveOrder = "order/saveOrder";
  static String getAllOrders = "order/getAllOrders";
  static String saveProduct = "product/save_product";
  static String saveBranch = "branch/save_branch";
  static String getAllBranches = "branch/getAllBranches";
  static String getAllUsers = "user/get_all_users";
  static String createUser = "user/add_user";
  static String createCategory = "product/add_category";
  static String createProduct = "product/save_product";
}
