import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/constatnts/enums.dart';
import 'package:pos_app/data/db/cart_db.dart';
import 'package:pos_app/data/db/customer_db.dart';
import 'package:pos_app/data/db/order_db.dart';
import 'package:pos_app/data/db/product_db.dart';
import 'package:pos_app/data/models/cart_model.dart';
import 'package:pos_app/data/models/customer_model.dart';
import 'package:pos_app/data/models/orders_model.dart';
import 'package:pos_app/data/models/product_model.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(CartInitialState()) {
    on<AddToCartEvent>((event, emit) async {
      CartModel? cartModel = CartDb.getCartFromLocal();
      if (cartModel == null) {
        await CartDb.addCartItemToLocal(CartItemModel(product: event.product, quantity: 1));
      } else {
        int existingItemIndex = cartModel.cartItems!.indexWhere((cartItem) => cartItem.product!.id == event.product.id);
        if (existingItemIndex == -1) {
          await CartDb.addCartItemToLocal(CartItemModel(product: event.product, quantity: 1));
        } else {
          await CartDb.updateItemFromCartLocal(existingItemIndex, CartItemModel(product: event.product, quantity: cartModel.cartItems![existingItemIndex].quantity! + 1));
        }
      }
      cartModel = CartDb.getCartFromLocal();

      emit(CartLoadedState(cart: cartModel!));
    });

    on<LoadCartEvent>((event, emit) {
      OrderDb.getAllOrders();
      CartModel? cartModel = CartDb.getCartFromLocal();
      emit(CartLoadedState(cart: cartModel ?? CartModel(cartItems: [], grandTotal: 0)));
    });
    on<UpdateCartQuantityEvent>((event, emit) {
      CartModel? cartModel = CartDb.getCartFromLocal();
      cartModel ??= CartModel(cartItems: [], grandTotal: 0.0);
      int existingItemIndex = cartModel.cartItems!.indexWhere((e) => e.product!.id == event.product.id);
      if (existingItemIndex == -1) {
        CartDb.addCartItemToLocal(CartItemModel(product: event.product, quantity: event.quantity));
      } else {
        cartModel.cartItems![existingItemIndex].quantity = event.quantity;
        CartDb.updateItemFromCartLocal(existingItemIndex, cartModel.cartItems![existingItemIndex]);
      }
      cartModel = CartDb.getCartFromLocal();
      emit(CartLoadedState(cart: cartModel!));
    });
    on<SubmitingCartEvent>((event, emit) async {
      bool haveUser = event.orderModel.customerId != 0;
      if (!haveUser) {
        event.orderModel.customerId = await CustomerDb.storeCustomer(event.customerModel);
      }

      await OrderDb.createCustomerOrder(event.orderModel);
      emit(CartSubmittedState());
    });
  }
}
