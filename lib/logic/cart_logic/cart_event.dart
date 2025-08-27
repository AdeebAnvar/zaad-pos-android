// ignore_for_file: public_member_api_docs, sort_constructors_first
part of "cart_bloc.dart";

abstract class CartEvent {}

class CartInitialEvent extends CartEvent {}

class AddToCartEvent extends CartEvent {
  final bool isNewCart;
  final ProductModel product;
  AddToCartEvent({required this.isNewCart, required this.product});
}

class RemoveFromCartEvent extends CartEvent {
  final ProductModel product;
  RemoveFromCartEvent({required this.product});
}

class UpdateCartQuantityEvent extends CartEvent {
  final ProductModel product;
  final int quantity;
  UpdateCartQuantityEvent({required this.product, required this.quantity});
}

class ClearCartEvent extends CartEvent {}

class LoadCartFromLocalEvent extends CartEvent {}

class ProductDiscountEvent extends CartEvent {
  final double discountedPrice;
  final CartItemModel cartItemModel;
  final bool isPercentage;
  ProductDiscountEvent({required this.isPercentage, required this.cartItemModel, required this.discountedPrice});
}

class CartDiscountEvent extends CartEvent {
  final double discountedPrice;
  final CartModel cartModel;
  final bool isPercentage;
  CartDiscountEvent({required this.isPercentage, required this.cartModel, required this.discountedPrice});
}

class SubmitingCartEvent extends CartEvent {
  OrderModel orderModel;
  CustomerModel customerModel;
  SubmitingCartEvent({
    required this.orderModel,
    required this.customerModel,
  });
}
