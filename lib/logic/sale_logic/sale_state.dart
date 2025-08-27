// ignore_for_file: public_member_api_docs, sort_constructors_first
part of "sale_bloc.dart";

abstract class SaleState {}

class SaleStateInitial extends SaleState {}

class SaleLoadingState extends SaleState {}

class SaleLoadedState extends SaleState {
  final List<ProductModel> products;
  final List<CategoryModel> categories;
  final int currentCategoryId;
  final String currentSearchQuery;

  SaleLoadedState({
    required this.products,
    required this.categories,
    this.currentCategoryId = 0,
    this.currentSearchQuery = '',
  });
}

class SaleErrorState extends SaleState {
  final String message;

  SaleErrorState({required this.message});
}
