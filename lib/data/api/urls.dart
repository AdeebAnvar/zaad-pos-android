import 'package:pos_app/data/db/user_db.dart';
import 'package:pos_app/data/utils/extensions.dart';

class Urls {
  static dynamic getHeaders() {
    var ss = {
      'Content-Type': 'application/json',
      'Authorization': UserDb.getAuthToken().isNullOrEmpty() ? "" : 'Bearer ${UserDb.getAuthToken()}',
    };

    return ss;
  }

  static String baseUrl = "https://zaad-pos-backend.onrender.com/";
  // static String baseUrl = "http://192.168.56.232:20399/";

  static String login = "${baseUrl}user/login";
  static String getAllCategories = "${baseUrl}product/get_all_categories";
  static String getAllProducts = "${baseUrl}product/get_all_products";
  static String getAllCustomers = "${baseUrl}customer/get_all_customers";
  static String saveCustomer = "${baseUrl}customer/save_customer";
}
