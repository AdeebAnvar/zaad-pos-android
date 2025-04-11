import 'package:hive/hive.dart';
import 'package:pos_app/data/models/cart_model.dart';
import 'package:pos_app/data/models/orders_model.dart';

class CartDb {
  static String cartBoxName = "zaad_pos_cart";

  static late Box cartBox;
  static initCartDb() async => cartBox = await Hive.openBox(cartBoxName);
  static addCartItemToLocal(CartItemModel cartItemModel) async {
    await cartBox.add(cartItemModel.toJson());
  }

  static updateItemFromCartLocal(int index, CartItemModel cartItemModel) async {
    await cartBox.putAt(index, cartItemModel.toJson());
  }

  static removeItemFromCartLocal(int index, CartItemModel cartItemModel) async {
    await cartBox.deleteAt(index);
  }

  static CartModel? getCartFromLocal() {
    if (cartBox.isNotEmpty) {
      print(cartBox.values);
      List<CartItemModel> cartItemsList = cartBox.values.map((cartData) {
        final Map<String, dynamic> cartMap = Map<String, dynamic>.from(cartData);
        return CartItemModel.fromJson(cartMap);
      }).toList();
      double grandTotal = 0.00;
      for (var cartItem in cartItemsList) {
        grandTotal = cartItem.totalPrice! + grandTotal;
      }
      return CartModel(cartItems: cartItemsList, totalCartPrice: grandTotal);
    } else {
      return null;
    }
  }

  static clearDb() async {
    await cartBox.clear();
  }
}
