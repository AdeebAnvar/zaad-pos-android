import 'package:hive/hive.dart';
import 'package:pos_app/data/models/cart_model.dart';

class CartDb {
  static String cartBoxName = "zaad_pos_cart";

  static late Box cartBox;
  static initCartDb() async => cartBox = await Hive.openBox(cartBoxName);
  static addCartItemToLocal(CartItemModel cartItemModel) async {
    await cartBox.add(cartItemModel.toMap());
  }

  static updateItemFromCartLocal(int index, CartItemModel cartItemModel) async {
    await cartBox.putAt(index, cartItemModel.toMap());
  }

  static CartModel? getCartFromLocal() {
    if (cartBox.isNotEmpty) {
      print(cartBox.values);
      // cartBox.clear();
      List<CartItemModel> cartItemsList = cartBox.values.map((cartData) {
        final Map<String, dynamic> cartMap = Map<String, dynamic>.from(cartData);
        return CartItemModel.fromMap(cartMap);
      }).toList();
      double grandTotal = 0.00;
      for (var cartItem in cartItemsList) {
        grandTotal = cartItem.totalPrice! + grandTotal;
      }
      return CartModel(cartItems: cartItemsList, grandTotal: grandTotal);
    } else {
      return null;
    }
  }

  static clearDb() async {
    await cartBox.clear();
  }
}
