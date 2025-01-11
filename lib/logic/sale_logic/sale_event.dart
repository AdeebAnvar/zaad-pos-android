// ignore_for_file: public_member_api_docs, sort_constructors_first
part of "sale_bloc.dart";

abstract class SaleEvent {}

class LoadProductsEvent extends SaleEvent {}

class SearchProductsEvent extends SaleEvent {
  String productName;
  SearchProductsEvent({
    required this.productName,
  });
}

class ChangeProductByCategoryEvent extends SaleEvent {
  int id;
  ChangeProductByCategoryEvent({
    required this.id,
  });
}
