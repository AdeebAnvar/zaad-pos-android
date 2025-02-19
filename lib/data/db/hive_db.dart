import 'package:hive_flutter/hive_flutter.dart';
import 'package:pos_app/data/db/cart_db.dart';
import 'package:pos_app/data/db/customer_db.dart';
import 'package:pos_app/data/db/order_db.dart';
import 'package:pos_app/data/db/product_db.dart';
import 'package:pos_app/data/db/user_db.dart';

class HiveDb {
  static initHive() async {
    await Hive.initFlutter();
    await UserDb.initUserDb();
    await CustomerDb.initCustomerDb();
    await OrderDb.initOrderDb();
    await ProductDb.initProductDb();
    await ProductDb.initProductCategoryDb();
    await CartDb.initCartDb();
  }

  static clearDb() async {
    await Hive.deleteFromDisk();
    await initHive();
  }
}
