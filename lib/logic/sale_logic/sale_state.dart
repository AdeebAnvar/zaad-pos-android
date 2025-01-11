// ignore_for_file: public_member_api_docs, sort_constructors_first
part of "sale_bloc.dart";

abstract class SaleState {}

class SaleStateInitial extends SaleState {}

class SaleLoadingState extends SaleState {}

class SaleLoadedState extends SaleState {
  List<ProductModel> products;
  List<CategoryModel> categories;
  SaleLoadedState({
    required this.products,
    required this.categories,
  });
}

class SaleErrorState extends SaleState {
  String message;

  SaleErrorState({required this.message});
}
