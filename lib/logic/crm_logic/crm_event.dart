// ignore_for_file: public_member_api_docs, sort_constructors_first
part of "crm_bloc.dart";

abstract class CrmEvent {}

class GetAllCustomersEvent extends CrmEvent {}

class AddCustomerEvent extends CrmEvent {
  CustomerModel customer;
  AddCustomerEvent({
    required this.customer,
  });
}

class SearchCustomersEvent extends CrmEvent {
  final String searchQuery;
  SearchCustomersEvent({required this.searchQuery});
}

class SelectCustomerEvent extends CrmEvent {
  final CustomerModel selectedCustomer;
  SelectCustomerEvent({required this.selectedCustomer});
}

class FetchCustomerOrdersEvent extends CrmEvent {
  final int customerId;

  FetchCustomerOrdersEvent({required this.customerId});
}
