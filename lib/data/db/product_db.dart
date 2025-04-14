import 'package:hive/hive.dart';
import 'package:pos_app/data/models/category_model.dart';
import 'package:pos_app/data/models/product_model.dart';

class ProductDb {
//BOX NAME
  static String productBoxName = "zaad_pos_product";
  static String productCategoryBoxName = "zaad_pos_product_Categories";

  static late Box productBox;
  static late Box productCategoryBox;

//INIT BOX
  static initProductDb() async => productBox = await Hive.openBox(productBoxName);
  static initProductCategoryDb() async => productCategoryBox = await Hive.openBox(productCategoryBoxName);

// STORE CATEGORIES
  static storeProductCategories(List<CategoryModel> categoryList) async {
    for (var category in categoryList) {
      await productCategoryBox.put(category.id, category.toJson());
    }
  }

// STORE PRODUCTS
  static storeProducts(List<ProductModel> productsList) async {
    for (var product in productsList) {
      await productBox.put(product.id, product.toJson());
    }
  }

  // GET CATEGORIES
  static List<CategoryModel> getCategories() {
    return productCategoryBox.values.map((productCategoryData) {
      final Map<String, dynamic> productCategoryMap = Map<String, dynamic>.from(productCategoryData as Map);
      return CategoryModel.fromJson(productCategoryMap);
    }).toList();
  }

  // GET PRODUCTS
  static List<ProductModel> getProducts() {
    return productBox.values.map((productData) {
      final Map<String, dynamic> productMap = Map<String, dynamic>.from(productData as Map);
      return ProductModel.fromJson(productMap);
    }).toList();
  }

  static Future<void> clearProductDb() async => await productBox.clear();
  static Future<void> clearProductCategoryDb() async => await productCategoryBox.clear();
}
