// ignore_for_file: public_member_api_docs, sort_constructors_first
part of "crm_bloc.dart";

abstract class CrmState {}

class CrmInitialState extends CrmState {}

class CrmScreenLoadingState extends CrmState {}

class CrmScreenLoadingSuccessState extends CrmState {
  final List<CustomerModel> customersList;
  final List<CustomerModel> filteredCustomersList; // Add this

  CrmScreenLoadingSuccessState({
    required this.customersList,
    required this.filteredCustomersList,
  });
}

class CustomerOrdersFetchLoadingState extends CrmState {}

class CustomerOrdersFetchedState extends CrmState {
  List<OrderModel> orders;
  CustomerOrdersFetchedState({
    required this.orders,
  });
}
