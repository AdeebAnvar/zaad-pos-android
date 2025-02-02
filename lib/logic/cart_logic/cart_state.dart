// ignore_for_file: public_member_api_docs, sort_constructors_first
part of "cart_bloc.dart";

abstract class CartState {}

class CartInitialState extends CartState {}

class CartLoadingState extends CartState {}

class CartLoadedState extends CartState {
  CartModel cart;
  CartLoadedState({
    required this.cart,
  });
}

class UpdatedCartQuantityState extends CartState {
  final ProductModel product;
  final int quantity;

  UpdatedCartQuantityState({required this.product, required this.quantity});
}

class CartSubmittedState extends CartState {}
