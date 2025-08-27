import 'package:hive/hive.dart';
import 'package:pos_app/constatnts/utils/image_utils.dart';
import 'package:pos_app/data/models/category_model.dart';
import 'package:pos_app/data/models/product_model.dart';

class ProductDb {
//BOX NAME
  static String productBoxName = "zaad_pos_product";
  static String productCategoryBoxName = "zaad_pos_product_Categories";

  static late Box productBox;
  static late Box productCategoryBox;

//INIT BOX
  static initProductDb() async {
    try {
      productBox = await Hive.openBox(productBoxName);
    } catch (e) {
      print(e);
    }
  }

  static initProductCategoryDb() async {
    try {
      productCategoryBox = await Hive.openBox(productCategoryBoxName);
    } catch (e) {
      print(e);
    }
  }

  static (String, ProductModel) updateStock(ProductModel productModel, int quantity) {
    final productJson = productBox.get(productModel.id);
    if (productJson == null) return ("${productModel.name} not found", productModel);

    ProductModel product = ProductModel.fromJson(Map<String, dynamic>.from(productJson));

    if (product.stockApplicable == 1) {
      if (product.minStockQty! >= quantity) {
        product.minStockQty = product.minStockQty! - quantity;
        productBox.put(product.id, product.toJson());
        return ("", product);
      } else {
        return ("${product.name} is Out Of Stock", product);
      }
    }

    return ("", product);
  }

  static ProductModel releaseStock(ProductModel productModel, int quantity) {
    final productJson = productBox.get(productModel.id);
    if (productJson == null) return productModel;

    ProductModel product = ProductModel.fromJson(Map<String, dynamic>.from(productJson));
    if (product.stockApplicable == 1) {
      product.minStockQty = (product.minStockQty ?? 0) + quantity;
      productBox.put(product.id, product.toJson());
    }
    return product;
  }

// STORE CATEGORIES
  static storeProductCategories(List<CategoryModel> categoryList) async {
    for (var category in categoryList) {
      await productCategoryBox.put(category.id, category.toJson());
    }
  }

// STORE PRODUCTS
  static storeProducts(List<ProductModel> productsList) async {
    for (var product in productsList) {
      // Download the image if it's not already saved locally
      if (product.image != null && product.localImagePath == "") {
        final fileName = '${product.name}-${product.id}.jpg';
        final localPath = await ImageUtils().downloadImage(product.image!, fileName);
        product.localImagePath = localPath; // Save the local image path
      }
      print(product.toJson());
      // Store the product in local storage
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

  // GET ALL PRODUCTS
  static List<ProductModel> getProducts() {
    return productBox.values.map((productData) {
      final Map<String, dynamic> productMap = Map<String, dynamic>.from(productData as Map);
      return ProductModel.fromJson(productMap);
    }).toList();
  }

  // Get one product
  static ProductModel? getProductByProductId(int productId) {
    try {
      final productMap = productBox.values.firstWhere(
        (product) => product['id'] == productId,
        orElse: () => null,
      );
      if (productMap == null) return null;
      return ProductModel.fromJson(Map<String, dynamic>.from(productMap));
    } catch (e) {
      return null;
    }
  }

  static Future<void> clearProductDb() async => await productBox.clear();
  static Future<void> clearProductCategoryDb() async => await productCategoryBox.clear();
}
