import 'package:hive/hive.dart';
import 'package:pos_app/data/db/product_db.dart';
import 'package:pos_app/data/models/cart_model.dart';
import 'package:pos_app/data/models/orders_model.dart';
import 'package:pos_app/data/models/product_model.dart';

class CartDb {
  static String cartBoxName = "zaad_pos_cart";

  static late Box cartBox;
  static initCartDb() async {
    try {
      cartBox = await Hive.openBox(cartBoxName);
    } catch (e) {
      print(e);
    }
  }

  static addCartItemToLocal(CartModel cartModel) async {
    if (cartModel.cartId == 0) {
      // New Cart
      cartBox.add(cartModel.toMap());
    } else {}
    // cartItemModel.updateTotalPrice();
    ProductModel? product = ProductDb.getProductByProductId(cartItemModel.product.id ?? 0);
    if (product == null) return;

    // Check if enough stock is available
    int currentStock = product.minStockQty ?? 0;
    if (currentStock < cartItemModel.quantity) {
      print("Not enough stock for product: ${product.name}");
      return;
    }

    // Update product in Hive
    await ProductDb.productBox.put(product.id, product.toJson());

    // Add item to cart
    await cartBox.add(cartItemModel.toJson());
  }

  static updateItemFromCartLocal(int index, CartItemModel cartItemModel) async {
    // Update total price for modified item
    cartItemModel.updateTotalPrice();
    await cartBox.putAt(index, cartItemModel.toJson());
  }

  static removeItemFromCartLocal(int index, CartItemModel cartItemModel) async {
    await cartBox.deleteAt(index);
  }

  static CartModel? getCartFromLocal(int cartId) {
    if (cartBox.isNotEmpty) {
      List<CartItemModel> cartItemsList = cartBox.values.map((cartData) {
        final Map<String, dynamic> cartMap = Map<String, dynamic>.from(cartData as Map);
        return CartItemModel.fromJson(cartMap);
      }).toList();

      // Create cart model and calculate total
      CartModel cartModel = CartModel(discount: 0, cartItems: cartItemsList, totalCartPrice: 0.0);
      cartModel.updateTotalCartPrice();

      return cartModel;
    } else {
      return null;
    }
  }

  static clearCartDb() async => await cartBox.clear();
}
