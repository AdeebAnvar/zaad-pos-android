import 'package:hive_flutter/hive_flutter.dart';
import 'package:pos_app/data/db/customer_db.dart';
import 'package:pos_app/data/db/order_db.dart';
import 'package:pos_app/data/db/product_db.dart';
import 'package:pos_app/data/db/user_db.dart';

class HiveDb {
  static initHive() async {
    await Hive.initFlutter();

    UserDb.initUserDb();
    CustomerDb.initCustomerDb();
    OrderDb.initOrderDb();
    ProductDb.initProductDb();
    ProductDb.initProductCategoryDb();
  }
}
