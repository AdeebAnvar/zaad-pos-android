import 'package:hive_flutter/hive_flutter.dart';
import 'package:pos_app/data/db/cart_db.dart';
import 'package:pos_app/data/db/customer_db.dart';
import 'package:pos_app/data/db/order_db.dart';
import 'package:pos_app/data/db/product_db.dart';
import 'package:pos_app/data/db/user_db.dart';

class HiveDb {
  static initHive() async {
    try {
      await Hive.initFlutter();
      await UserDb.initUserDb();
      await CustomerDb.initCustomerDb();
      await OrderDb.initOrderDb();
      await ProductDb.initProductDb();
      await ProductDb.initProductCategoryDb();
      await CartDb.initCartDb();
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  static clearDb() async {
    await UserDb.clearUserDb();
    await CustomerDb.clearCustomerDb();
    await OrderDb.clearOrderDb();
    await ProductDb.clearProductDb();
    await ProductDb.clearProductCategoryDb();
    await CartDb.clearCartDb();
  }
}
