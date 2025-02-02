// ignore_for_file: public_member_api_docs, sort_constructors_first
part of "cart_bloc.dart";

abstract class CartEvent {}

class CartInitialEvent extends CartEvent {}

class AddToCartEvent extends CartEvent {
  final ProductModel product;
  AddToCartEvent({required this.product});
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

class LoadCartEvent extends CartEvent {}

class SubmitingCartEvent extends CartEvent {
  OrderModel orderModel;
  CustomerModel customerModel;
  SubmitingCartEvent({
    required this.orderModel,
    required this.customerModel,
  });
}
