import 'package:flutter/material.dart';
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
import 'package:pos_app/widgets/custom_snackbar.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(CartInitialState()) {
    /// Add item to cart
    on<AddToCartEvent>((event, emit) async {
      CartModel? cartModel = CartDb.getCartFromLocal(event.newCart);
      cartModel ??= CartModel(cartItems: [], totalCartPrice: 0);

      int index = cartModel.cartItems.indexWhere((e) => e.product.id == event.product.id);

      if (index == -1) {
        // New item, check stock
        ProductModel? updatedProduct = _updateStock(event.product, 1);
        if (updatedProduct != null) await CartDb.addCartItemToLocal(CartItemModel(product: updatedProduct, quantity: 1));
      } else {
        // Existing item, increase quantity by 1
        int newQuantity = cartModel.cartItems[index].quantity + 1;
        ProductModel? updatedProduct = _updateStock(event.product, 1); // increment by 1
        if (updatedProduct != null) await CartDb.updateItemFromCartLocal(index, CartItemModel(product: updatedProduct, quantity: newQuantity));
      }

      cartModel = CartDb.getCartFromLocal();
      emit(CartLoadedState(cart: cartModel!));
    });

    /// Load cart
    on<LoadCartFromLocalEvent>((event, emit) {
      CartModel? cartModel = CartDb.getCartFromLocal();
      emit(CartLoadedState(cart: cartModel ?? CartModel(cartItems: [], totalCartPrice: 0)));
    });

    /// Update quantity
    on<UpdateCartQuantityEvent>((event, emit) async {
      CartModel? cartModel = CartDb.getCartFromLocal();
      cartModel ??= CartModel(cartItems: [], totalCartPrice: 0);

      int index = cartModel.cartItems.indexWhere((e) => e.product.id == event.product.id);

      if (index == -1) {
        CustomSnackBar.showError(message: "Item not in cart");
        return;
      }

      CartItemModel existingItem = cartModel.cartItems[index];
      int quantityDiff = event.quantity - existingItem.quantity;

      if (event.quantity < 1) {
        // Remove item, release stock
        ProductDb.releaseStock(existingItem.product, existingItem.quantity);
        CartDb.removeItemFromCartLocal(index, existingItem);
      } else if (quantityDiff > 0) {
        // Add more, check stock
        ProductModel? updatedProduct = _updateStock(existingItem.product, quantityDiff);
        if (updatedProduct != null) await CartDb.updateItemFromCartLocal(index, CartItemModel(product: updatedProduct, quantity: event.quantity, discount: existingItem.discount));
      } else if (quantityDiff < 0) {
        // Reduce quantity, release stock
        ProductDb.releaseStock(existingItem.product, -quantityDiff);
        await CartDb.updateItemFromCartLocal(index, CartItemModel(product: existingItem.product, quantity: event.quantity, discount: existingItem.discount));
      }

      cartModel = CartDb.getCartFromLocal();
      emit(CartLoadedState(cart: cartModel));
    });

    /// Submit cart
    on<SubmitingCartEvent>((event, emit) async {
      if (!event.orderModel.isValid()) {
        CustomSnackBar.showError(message: "Invalid order data. Please check all fields.");
        return;
      }

      for (var item in event.orderModel.orderItems ?? []) {
        if (!item.isValid()) {
          CustomSnackBar.showError(message: "Invalid order item data. Please check product info.");
          return;
        }
      }

      bool haveUser = event.orderModel.customerId != 0;
      if (!haveUser) {
        event.orderModel.customerId = await CustomerDb.storeCustomer(event.customerModel);
      }

      await OrderDb.createCustomerOrder(event.orderModel);
      emit(CartSubmittedState());
    });
    on<ProductDiscountEvent>((event, emit) {
      CartModel? cartModel = CartDb.getCartFromLocal();
      if (event.discountedPrice == -1) {
        event.cartItemModel.removeDiscount();
        int index = cartModel!.cartItems.indexWhere((e) => e.product.id == event.cartItemModel.product.id);
        cartModel.cartItems[index] = event.cartItemModel;
        cartModel.totalCartPrice = cartModel.calculateTotalCartPrice();

        CartDb.updateItemFromCartLocal(index, event.cartItemModel);
        print('dgjojn ${cartModel.toMap()}');

        emit(CartLoadedState(cart: cartModel));
      } else {
        // CartItemModel cartItemModel = cartModel!.cartItems.firstWhere((e) => e.product.id == event.cartItemModel.product.id);
        // cartItemModel.discount = event.discountedPrice;
        event.cartItemModel.applyDiscount(event.discountedPrice, isPercentage: event.isPercentage);
        // cartModel!.totalCartPrice = cartModel.calculateTotalCartPrice();
        // print(cartModel.totalCartPrice);
        int index = cartModel!.cartItems.indexWhere((e) => e.product.id == event.cartItemModel.product.id);
        event.cartItemModel.discountType = event.isPercentage ? DiscountType.byPercentage.value : DiscountType.byAmount.value;
        cartModel.cartItems[index] = event.cartItemModel;
        cartModel.totalCartPrice = cartModel.calculateTotalCartPrice();
        print('dgjojn ${cartModel.toMap()}');
        CartDb.updateItemFromCartLocal(index, event.cartItemModel);
        emit(CartLoadedState(cart: cartModel));
      }
    });
    on<CartDiscountEvent>((event, emit) {
      CartModel? cartModel = CartDb.getCartFromLocal();
      if (event.discountedPrice == -1) {
        event.cartModel.removeDiscount();

        emit(CartLoadedState(cart: cartModel));
      } else {
        int index = cartModel!.cartItems.indexWhere((e) => e.product.id == event.cartItemModel.product.id);
        event.cartItemModel.discountType = event.isPercentage ? DiscountType.byPercentage.value : DiscountType.byAmount.value;
        cartModel.cartItems[index] = event.cartItemModel;
        cartModel.totalCartPrice = cartModel.calculateTotalCartPrice();
        print('dgjojn ${cartModel.toMap()}');
        CartDb.updateItemFromCartLocal(index, event.cartItemModel);
        emit(CartLoadedState(cart: cartModel));
      }
    });
  }

  /// Internal method to update stock and show snack messages
  ProductModel? _updateStock(ProductModel product, int quantity) {
    (String, ProductModel) stockResponse = ProductDb.updateStock(product, quantity);
    if (stockResponse.$1.isNotEmpty) {
      CustomSnackBar.showWarning(message: stockResponse.$1);
      return null;
    } else {
      CustomSnackBar.showSuccess(message: '${stockResponse.$2.name} added to cart');
      return stockResponse.$2;
    }
  }
}
