import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/data/db/customer_db.dart';
import 'package:pos_app/data/db/hive_db.dart';
import 'package:pos_app/data/db/order_db.dart';
import 'package:pos_app/data/models/customer_model.dart';
import 'package:pos_app/data/models/orders_model.dart';

part 'crm_event.dart';
part 'crm_state.dart';

class CrmBloc extends Bloc<CrmEvent, CrmState> {
  List<CustomerModel> allCustomers = [];

  CrmBloc() : super(CrmInitialState()) {
    on<GetAllCustomersEvent>((event, emit) async {
      emit(CrmScreenLoadingState());
      allCustomers = CustomerDb.getAllCustomers();
      emit(CrmScreenLoadingSuccessState(
        customersList: allCustomers,
        filteredCustomersList: allCustomers,
      ));
    });

    on<AddCustomerEvent>((event, emit) async {
      emit(CrmScreenLoadingState());
      CustomerDb.storeCustomer(event.customer);
      allCustomers = CustomerDb.getAllCustomers();
      emit(CrmScreenLoadingSuccessState(
        customersList: allCustomers,
        filteredCustomersList: allCustomers,
      ));
    });

    on<SearchCustomersEvent>((event, emit) {
      if (state is CrmScreenLoadingSuccessState) {
        final query = event.searchQuery.toLowerCase();

        final filteredList = query.isEmpty
            ? allCustomers
            : allCustomers
                .where(
                  (customer) => customer.name!.toLowerCase().contains(query) || customer.phone!.toLowerCase().contains(query) || customer.email!.toLowerCase().contains(query),
                )
                .toList();

        emit(CrmScreenLoadingSuccessState(
          customersList: allCustomers,
          filteredCustomersList: filteredList,
        ));
      }
    });

    on<SelectCustomerEvent>((event, emit) {
      if (state is CrmScreenLoadingSuccessState) {
        final filteredList = [event.selectedCustomer];
        emit(CrmScreenLoadingSuccessState(
          customersList: allCustomers,
          filteredCustomersList: filteredList,
        ));
      }
    });

    on<FetchCustomerOrdersEvent>((event, emit) {
      emit(CustomerOrdersFetchLoadingState());
      List<OrderModel> ordersList = OrderDb.getAllOrdersOfCustomer(event.customerId);
      emit(CustomerOrdersFetchedState(orders: ordersList));
    });
  }
}
