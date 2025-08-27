// ignore_for_file: public_member_api_docs, sort_constructors_first
part of "sale_bloc.dart";

abstract class SaleEvent {}

class LoadProductsEvent extends SaleEvent {
  final String productName;
  LoadProductsEvent({
    required this.productName,
  });
}

class SearchProductsEvent extends SaleEvent {
  final String productName;
  SearchProductsEvent({
    required this.productName,
  });
}

class ChangeProductByCategoryEvent extends SaleEvent {
  final int id;
  ChangeProductByCategoryEvent({
    required this.id,
  });
}

class ClearSearchEvent extends SaleEvent {}
